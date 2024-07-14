import 'package:flutter/material.dart';
import '../../models/cat.dart';
import '../../services/api_service.dart';
import 'cat_details.dart';

class CatsListPage extends StatefulWidget {
  const CatsListPage({super.key});

  @override
  _CatsListPageState createState() => _CatsListPageState();
}

class _CatsListPageState extends State<CatsListPage> {
  List<Cat> catsData = [];
  final ScrollController _scrollController = ScrollController();
  bool _loading = false;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _fetchCats();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_loading) {
        _fetchCats();
      }
    });
  }

  Future<void> _fetchCats() async {
    setState(() {
      _loading = true;
    });

    try {
      final apiService = ApiService();
      final newCats = await apiService.fetchAllCats();
      setState(() {
        catsData.addAll(newCats);
        _loading = false;
        _page++;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print('Failed to load cats: $e');
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
        title: const Text('Liste des Chats'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: catsData.length + 1,
          itemBuilder: (context, index) {
            if (index == catsData.length) {
              return _loading
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox.shrink();
            }
            final cat = catsData[index];
            return Card(
              margin: const EdgeInsets.all(10),
              color: Colors.white,
              child: ListTile(
                leading: cat.picturesUrl.isNotEmpty
                    ? Image.network(cat.picturesUrl[0])
                    : const Icon(Icons.pets),
                title: Text(cat.name),
                subtitle: Text(
                    'Race: ${cat.race}\nCouleur: ${cat.color}\nComportement: ${cat.behavior}\nRéservé: ${cat.reserved ? "Oui" : "Non"}'),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CatDetails(cat: cat),
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
