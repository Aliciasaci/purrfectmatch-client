import 'package:flutter/material.dart';
import '../models/annonce.dart';
import '../models/cat.dart';
import '../services/api_service.dart';
import 'annonce_detail_page.dart';

class UserAnnoncesPage extends StatefulWidget {
  const UserAnnoncesPage({super.key});

  @override
  _UserAnnoncesPageState createState() => _UserAnnoncesPageState();
}

class _UserAnnoncesPageState extends State<UserAnnoncesPage> {
  List<Annonce> userAnnoncesData = [];
  Map<String, Cat> catsData = {};
  final ScrollController _scrollController = ScrollController();
  bool _loading = false;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _fetchUserAnnonces();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_loading) {
        _fetchUserAnnonces();
      }
    });
  }

  Future<void> _fetchUserAnnonces() async {
    setState(() {
      _loading = true;
    });

    try {
      final apiService = ApiService();
      final newAnnonces = await apiService.fetchUserAnnonces();
      for (var annonce in newAnnonces) {
        if (annonce.CatID != null) {
          final cat = await apiService.fetchCatByID(annonce.CatID!);
          catsData[annonce.CatID!] = cat;
        }
      }
      setState(() {
        userAnnoncesData.addAll(newAnnonces);
        _loading = false;
        _page++;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print('Failed to load user annonces: $e');
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
        title: const Text('Mes annonces'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: userAnnoncesData.length + 1,
          itemBuilder: (context, index) {
            if (index == userAnnoncesData.length) {
              return _loading
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox.shrink();
            }
            final annonce = userAnnoncesData[index];
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
