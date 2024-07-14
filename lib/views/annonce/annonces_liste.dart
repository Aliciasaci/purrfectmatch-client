import 'package:flutter/material.dart';
import '../../models/annonce.dart';
import '../../models/cat.dart';
import '../../services/api_service.dart';
import 'annonce_detail_page.dart';

class AnnoncesListPage extends StatefulWidget {
  const AnnoncesListPage({super.key});

  @override
  _AnnoncesListPageState createState() => _AnnoncesListPageState();
}

class _AnnoncesListPageState extends State<AnnoncesListPage> {
  List<Annonce> annoncesData = [];
  Map<String, Cat> catsData = {};
  final ScrollController _scrollController = ScrollController();
  bool _loading = false;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _fetchAnnonces();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_loading) {
        _fetchAnnonces();
      }
    });
  }

  Future<void> _fetchAnnonces() async {
    setState(() {
      _loading = true;
    });

    try {
      final apiService = ApiService();
      final newAnnonces = await apiService.fetchAllAnnonces();
      for (var annonce in newAnnonces) {
        if (annonce.CatID != null) {
          final cat = await apiService.fetchCatByID(annonce.CatID!);
          catsData[annonce.CatID!] = cat;
        }
      }
      setState(() {
        annoncesData.addAll(newAnnonces);
        _loading = false;
        _page++;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print('Failed to load annonces: $e');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Annonces'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: annoncesData.length + 1,
          itemBuilder: (context, index) {
            if (index == annoncesData.length) {
              return _loading
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox.shrink();
            }
            final annonce = annoncesData[index];
            final cat = annonce.CatID != null ? catsData[annonce.CatID!] : null;
            return Card(
              margin: const EdgeInsets.all(10),
              color: Colors.white,
              child: ListTile(
                leading: cat != null && cat.picturesUrl.isNotEmpty
                    ? Image.network(cat.picturesUrl.first,
                        width: 50, height: 50, fit: BoxFit.cover)
                    : const Icon(Icons.image, size: 50),
                title: Text(annonce.Title),
                subtitle: Text(
                    'Description: ${annonce.Description}\nCat ID: ${annonce.CatID}'),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnnonceDetailPage(annonce: annonce),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
