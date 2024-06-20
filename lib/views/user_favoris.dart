import 'package:flutter/material.dart';
import '../models/annonce.dart';
import '../services/api_service.dart';
import 'annonce_detail_page.dart';

class UserFavorisPage extends StatefulWidget {
  const UserFavorisPage({super.key});

  @override
  _UserFavorisPageState createState() => _UserFavorisPageState();
}

class _UserFavorisPageState extends State<UserFavorisPage> {
  List<Annonce> userFavorisData = [];
  final ScrollController _scrollController = ScrollController();
  bool _loading = false;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _fetchUserFavoris();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent &&
          !_loading) {
        _fetchUserFavoris();
      }
    });
  }

  Future<void> _fetchUserFavoris() async {
    setState(() {
      _loading = true;
    });

    try {
      final apiService = ApiService();
      final newAnnonces = await apiService.fetchUserFavorites();
      setState(() {
        userFavorisData.addAll(newAnnonces);
        _loading = false;
        _page++;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print('Failed to load user favoris: $e');
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
        title: const Text('Mes favoris'),
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
          itemCount: userFavorisData.length + 1,
          itemBuilder: (context, index) {
            if (index == userFavorisData.length) {
              return _loading
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox.shrink();
            }
            final annonce = userFavorisData[index];
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
