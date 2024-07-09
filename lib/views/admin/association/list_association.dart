import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../services/api_service.dart';
import 'blocs/association_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ListAssociation extends StatelessWidget {
  const ListAssociation({super.key});

  static String get baseUrl => kIsWeb ? dotenv.env['WEB_BASE_URL']! : dotenv.env['MOBILE_BASE_URL']!;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AssociationBloc(apiService: ApiService())..add(LoadAssociations()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text('Liste des Associations')),
        body: BlocBuilder<AssociationBloc, AssociationState>(
          builder: (context, state) {
            if (state is AssociationLoaded) {
              return SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Nom')),
                          DataColumn(label: Text('Email')),
                          DataColumn(label: Text('Propriétaire')),
                          DataColumn(label: Text('Vérifié ?')),
                          DataColumn(label: Text('Voir Kbis')),
                          DataColumn(label: Text('Action')),
                        ],
                        rows: state.associations.map((association) => DataRow(cells: [
                          DataCell(Text(association.name)),
                          DataCell(Text(association.email)),
                          DataCell(Text(association.ownerId)),
                          //DataCell(Text(association.owner!.name!)),
                          DataCell(Text(association.verified! ? 'Oui' : 'Non')),
                          DataCell(IconButton(
                            icon: const Icon(Icons.visibility),
                            onPressed: () async {
                              try {
                                await launchUrl(Uri.parse(association.kbisFile));
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erreur lors de l\'ouverture du fichier KBIS')));
                              }
                            })),
                          DataCell(TextButton(
                            onPressed: () {
                              showVerificationModal(context, association.id!, BlocProvider.of<AssociationBloc>(context));
                            },
                            child: const Text('Valider'),
                          )),
                        ])).toList(),
                      ),
                    ),
                  ),
                ),
              );
            } else if (state is AssociationError) {
              return const Center(child: Text('Erreur lors du chargement des associations.'));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  void showVerificationModal(BuildContext context, int associationId, AssociationBloc associationBloc) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Êtes-vous sûr de vouloir valider cette association ?', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: const Text('Annuler'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  ElevatedButton(
                    child: const Text('Valider'),
                    onPressed: () {
                      associationBloc.add(UpdateAssociationVerifyStatus(associationId, true));
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Association validée avec succès')));
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
