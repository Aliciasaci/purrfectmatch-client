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
  bool _hasMore = true;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _fetchAnnonces();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_loading &&
          _hasMore) {
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

      List<Annonce> validAnnonces = [];
      for (var annonce in newAnnonces) {
        if (annonce.CatID != null) {
          try {
            final cat = await apiService.fetchCatByID(annonce.CatID);
            catsData[annonce.CatID] = cat;
            validAnnonces.add(annonce);
          } catch (e) {
            // Si le chat n'existe plus, on ne l'ajoute pas à la liste des annonces valides
            print('Chat does not exist for Annonce ID: ${annonce.ID}');
          }
        } else {
          validAnnonces.add(annonce);
        }
      }

      setState(() {
        annoncesData.addAll(validAnnonces);
        _loading = false;
        _hasMore = validAnnonces.isNotEmpty;
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
        backgroundColor: Colors.orange[100],
      ),
      body: _loading
          ? Center(child: Text("Loading..."))
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.orange[100]!, Colors.orange[200]!],
                ),
              ),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: annoncesData.length + 1,
                itemBuilder: (context, index) {
                  if (index == annoncesData.length) {
                    return _loading
                        ? const Center(child: CircularProgressIndicator())
                        : !_hasMore
                            ? const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(child: Text('No more annonces')),
                              )
                            : const SizedBox.shrink();
                  }
                  final annonce = annoncesData[index];
                  final cat =
                      annonce.CatID != null ? catsData[annonce.CatID] : null;
                  return Card(
                    margin: const EdgeInsets.all(10),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 4,
                    child: ListTile(
                      leading: cat != null && cat.picturesUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                cat.picturesUrl.first,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.image, size: 50),
                      title: Text(
                        annonce.Title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Description: ${annonce.Description}\nChat: ${cat?.name ?? 'Unknown'}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      trailing:
                          const Icon(Icons.arrow_forward, color: Colors.orange),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AnnonceDetailPage(annonce: annonce),
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
