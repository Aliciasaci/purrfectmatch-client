import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AddCat extends StatefulWidget {
  const AddCat({super.key});

  @override
  State<AddCat> createState() => _AddCatState();
}

class _AddCatState extends State<AddCat> {
  String? _selectedValue;
  final List<String> _options = ['male', 'femelle'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Créer un profil de chat',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Nom",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          maxLines: 2,
                          decoration: const InputDecoration(
                            labelText: "Description",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          maxLines: 1,
                          decoration: const InputDecoration(
                            labelText: "Age",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          maxLines: 1,
                          decoration: const InputDecoration(
                            labelText: "Color",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          maxLines: 1,
                          decoration: const InputDecoration(
                            labelText: "Comportement",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          maxLines: 1,
                          decoration: const InputDecoration(
                            labelText: "race",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 15),
                        DropdownButton<String>(
                          value: _selectedValue,
                          hint: const Text('Sélectionnez un genre'), // Texte affiché avant la sélection
                          items: _options.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedValue = newValue; // Mise à jour de la valeur sélectionnée
                            });
                          },
                          isExpanded: true,
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: () async {
                            // Action à effectuer lors du clic sur le bouton de sélection de fichier
                            FilePickerResult? result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['jpg', 'png', 'doc'],
                            );
                            if (result != null) {
                              PlatformFile file = result.files.first;
                              // Vous pouvez utiliser file pour obtenir des informations sur le fichier sélectionné
                              print('Nom du fichier: ${file.name}');
                              print('Chemin du fichier: ${file.path}');
                              print('Taille du fichier: ${file.size}');
                              print('Extension du fichier: ${file.extension}');
                            } else {
                              // Gérer le cas où aucun fichier n'est sélectionné
                              print('Aucun fichier sélectionné.');
                            }
                          },
                          child: const Text('Sélectionner un fichier'),
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: () {
                            // Action à effectuer lors de la soumission du formulaire
                            print('Formulaire envoyé');
                          },
                          child: const Text('Envoyer'),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
