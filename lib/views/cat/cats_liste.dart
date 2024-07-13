import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/cat.dart';
import '../../models/user.dart';
import '../../services/api_service.dart';
import 'cat_details.dart';
import 'edit_cat_details.dart';
import '../../blocs/auth/auth_bloc.dart';

class CatsListPage extends StatefulWidget {
  final String? userId; // Change the userId type to String

  const CatsListPage({super.key, this.userId});

  @override
  _CatsListPageState createState() => _CatsListPageState();
}

class _CatsListPageState extends State<CatsListPage> {
  List<Cat> catsData = [];
  final ScrollController _scrollController = ScrollController();
  bool _loading = false;
  int _page = 1;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _fetchCats();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_loading) {
        _fetchCats();
      }
    });
  }

  Future<void> _loadCurrentUser() async {
    final authState = BlocProvider.of<AuthBloc>(context).state;
    if (authState is AuthAuthenticated) {
      setState(() {
        currentUser = authState.user;
      });
    }
  }

  Future<void> _fetchCats() async {
    setState(() {
      _loading = true;
    });

    try {
      final apiService = ApiService();
      List<Cat> newCats;
      if (widget.userId != null) {
        newCats = await apiService.fetchCatsByUser(widget.userId!);
      } else {
        newCats = await apiService.fetchAllCats();
      }
      setState(() {
        catsData = newCats;
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

  Future<void> _deleteCat(int catId) async {
    try {
      final apiService = ApiService();
      await apiService.deleteCat(catId);
      setState(() {
        catsData.removeWhere((cat) => cat.ID == catId);
      });
    } catch (e) {
      print('Failed to delete cat: $e');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _navigateAndEditCat(Cat cat) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCatDetails(cat: cat),
      ),
    );

    if (result == true) {
      // If a cat was edited, reload the list
      _fetchCats();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.catListTitle),
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
          itemCount: catsData.length + 1,
          itemBuilder: (context, index) {
            if (index == catsData.length) {
              return _loading ? const Center(child: CircularProgressIndicator()) : const SizedBox.shrink();
            }
            final cat = catsData[index];
            return Card(
              margin: const EdgeInsets.all(10),
              color: Colors.white,
              child: ListTile(
                leading: cat.picturesUrl.isNotEmpty ? Image.network(cat.picturesUrl[0]) : const Icon(Icons.pets),
                title: Text(cat.name),
                subtitle: Text(
                    '${AppLocalizations.of(context)!.race}: ${cat.race}\n${AppLocalizations.of(context)!.color}: ${cat.color}\n${AppLocalizations.of(context)!.behavior}: ${cat.behavior}\n${AppLocalizations.of(context)!.reserved}: ${cat.reserved ? AppLocalizations.of(context)!.yes : AppLocalizations.of(context)!.no}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (currentUser != null && cat.userId == currentUser!.id)
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.green),
                        onPressed: () => _navigateAndEditCat(cat),
                      ),
                    if (currentUser != null && cat.userId == currentUser!.id)
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteCat(cat.ID!),
                      ),
                  ],
                ),
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
