import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';


class AddAnnonce extends StatelessWidget {
  const AddAnnonce({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Fond blanc
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Ajouter une nouvelle annonce',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Titre de l'annonce",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // Action à effectuer lors du clic sur le bouton de sélection de fichier
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['jpg', 'pdf', 'doc'],
                        );
                        if (result != null) {
                          PlatformFile file = result.files.first;
                          // Vous pouvez utiliser file pour obtenir des informations sur le fichier sélectionné
                          print('Nom du fichier: ${file.name}');
                          print('Chemin du fichier: ${file.path}');
                          print('Taille du fichier: ${file.size}');
                          print(file.extension);
                        } else {
                          print('Aucun fichier sélectionné.');
                        }
                      },
                      child: const Text('Sélectionner un fichier'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Action à effectuer lors de la soumission du formulaire
                      },
                      child: const Text('Envoyer'),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
