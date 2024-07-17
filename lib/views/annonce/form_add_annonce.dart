import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../models/cat.dart';
import '../../services/api_service.dart';
import '../../blocs/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cat/form_add_cat.dart';
import '../../models/annonce.dart';

class AddAnnonce extends StatefulWidget {
  const AddAnnonce({super.key});

  @override
  _AddAnnonceState createState() => _AddAnnonceState();
}

class _AddAnnonceState extends State<AddAnnonce> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<Cat> _userCats = [];
  Cat? _selectedCat;

  @override
  void initState() {
    super.initState();
    _loadUserCats();
  }

  Future<void> _loadUserCats() async {
    final authState = BlocProvider.of<AuthBloc>(context).state;
    if (authState is AuthAuthenticated) {
      final userId = authState.user.id;
      if (userId != null) {
        try {
          final cats = await ApiService().fetchCatsByUser(userId);
          setState(() {
            _userCats = cats;
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.dataSendError)),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _sendData() async {
    final String title = _titleController.text;
    final String description = _descriptionController.text;

    if (title.isEmpty || description.isEmpty || _selectedCat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.pleaseFillAllFields)),
      );
      return;
    }

    Annonce annonce = Annonce(
      Title: title,
      Description: description.isNotEmpty ? description : '',
      CatID: _selectedCat!.ID.toString(),
    );

    try {
      await ApiService().createAnnonce(annonce);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.dataSentSuccessfully)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppLocalizations.of(context)!.dataSendError}: $e')),
      );
    }
  }

  Widget buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    IconData? icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange[100]!),
        borderRadius: BorderRadius.circular(40),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          icon: icon != null ? Icon(icon, color: Colors.orange[100]) : null,
          border: InputBorder.none,
          labelText: labelText,
        ),
      ),
    );
  }

  Widget buildDropdownFormField({
    required List<DropdownMenuItem<Cat>> items,
    required String labelText,
    required Cat? value,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange[100]!),
        borderRadius: BorderRadius.circular(40),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: DropdownButtonFormField<Cat>(
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: labelText,
        ),
        items: items,
        onChanged: (Cat? newValue) {
          setState(() {
            _selectedCat = newValue;
          });
        },
        value: value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addAnnonceTitle),
        backgroundColor: Colors.orange[100],
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.orange[100]!, Colors.orange[200]!],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      child: Column(
                        children: [
                          buildTextFormField(
                            controller: _titleController,
                            labelText: "${AppLocalizations.of(context)!.annonceTitle} *",
                            icon: Icons.title,
                          ),
                          const SizedBox(height: 15),
                          buildTextFormField(
                            controller: _descriptionController,
                            labelText: AppLocalizations.of(context)!.description,
                            icon: Icons.description,
                          ),
                          const SizedBox(height: 15),
                          buildDropdownFormField(
                            items: _userCats.map((Cat cat) {
                              return DropdownMenuItem<Cat>(
                                value: cat,
                                child: Text(cat.name),
                              );
                            }).toList(),
                            labelText: "${AppLocalizations.of(context)!.selectCat} *",
                            value: _selectedCat,
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _sendData,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange[100],
                                padding: const EdgeInsets.all(15),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.add,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Divider(
                            color: Colors.grey,
                            height: 20,
                            thickness: 1,
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange[100],
                                padding: const EdgeInsets.all(15),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const AddCat()),
                                );
                              },
                              child: Text(
                                AppLocalizations.of(context)!.addCat,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
