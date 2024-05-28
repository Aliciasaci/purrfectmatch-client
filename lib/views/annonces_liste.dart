import 'package:flutter/material.dart';
import '../models/annonce.dart';
import '../services/api_service.dart';
import 'annonce_detail_page.dart';

class AnnoncesListPage extends StatefulWidget {
  const AnnoncesListPage({super.key});

  @override
  _AnnoncesListPageState createState() => _AnnoncesListPageState();
}

class _AnnoncesListPageState extends State<AnnoncesListPage> {
  List<Annonce> annoncesData = [];
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.amberAccent[100]!, Colors.orange[400]!],
          ),
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
            return Card(
              margin: const EdgeInsets.all(10),
              color: Colors.white,
              child: ListTile(
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
