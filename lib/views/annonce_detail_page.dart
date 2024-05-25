import 'package:flutter/material.dart';
import '../models/annonce.dart';

class AnnonceDetailPage extends StatefulWidget {
  final Annonce annonce;

  const AnnonceDetailPage({Key? key, required this.annonce}) : super(key: key);

  @override
  _AnnonceDetailPageState createState() => _AnnonceDetailPageState();
}

class _AnnonceDetailPageState extends State<AnnonceDetailPage> {
  @override
  void initState() {
    super.initState();
    print('====>Annonce créée : ${widget.annonce}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de l\'annonce'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.amberAccent[100]!, Colors.orange[400]!],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              color: Colors.white,
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Détails de l\'annonce',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      initialValue: widget.annonce.Title,
                      decoration: const InputDecoration(
                        labelText: "Titre de l'annonce",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      initialValue: widget.annonce.Description,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      initialValue: widget.annonce.CatID,
                      decoration: const InputDecoration(
                        labelText: "ID du chat",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Retour'),
                        ),
                        SizedBox(width: 7,),
                        ElevatedButton(
                          onPressed: () {
                            // à faire
                          },
                          child: const Text('Modifier'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
