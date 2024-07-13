import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/race.dart';
import 'blocs/crud_race_bloc.dart';

class CrudRacePage extends StatelessWidget {
  const CrudRacePage({super.key});

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Gestion des races'),
      ),
      body: BlocConsumer<CrudRaceBloc, CrudRaceState>(
        listener: (context, state) {
          if (state is CrudRaceCreated) {
            showSnackBar(context, 'Race a été créée avec succès.');
          } else if (state is CrudRaceUpdated) {
            showSnackBar(context, 'Race a été mise à jour avec succès.');
          } else if (state is CrudRaceDeleted) {
            showSnackBar(context, 'Race a été supprimée avec succès.');
          }
        },
        builder: (context, state) {
          if (state is CrudRaceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CrudRaceLoaded) {
            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Nom Race')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: state.races.map((race) {
                      return DataRow(cells: [
                        DataCell(Text(race.raceName)),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  showEditRaceModalBottomSheet(context, race, BlocProvider.of<CrudRaceBloc>(context));
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  showDeleteRaceModalBottomSheet(context, race.id!, BlocProvider.of<CrudRaceBloc>(context));
                                },
                              ),
                            ],
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            );
          } else if (state is CrudRaceError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Aucun résultat trouvé.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddRaceModalBottomSheet(context, BlocProvider.of<CrudRaceBloc>(context)),
        child: const Icon(Icons.add),
      ),
    );
  }

  void showAddRaceModalBottomSheet(BuildContext context, CrudRaceBloc crudRaceBloc) {
    final TextEditingController raceNameController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Ajouter une race', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: raceNameController,
                  decoration: const InputDecoration(labelText: 'Nom Race', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final Race newRace = Race(raceName: raceNameController.text);
                    crudRaceBloc.add(CreateRace(newRace));
                    Navigator.of(context).pop();
                  },
                  child: const Text('Valider'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showEditRaceModalBottomSheet(BuildContext context, Race race, CrudRaceBloc crudRaceBloc) {
    final TextEditingController raceNameController = TextEditingController(text: race.raceName);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Editer une race', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: raceNameController,
                  decoration: const InputDecoration(labelText: 'Nom Race'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final Race updatedRace = Race(id: race.id, raceName: raceNameController.text);
                    crudRaceBloc.add(UpdateRace(updatedRace));
                    Navigator.of(context).pop();
                  },
                  child: const Text('Valider'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showDeleteRaceModalBottomSheet(BuildContext context, int raceId, CrudRaceBloc crudRaceBloc) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Supprimer une race', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const Text('Êtes-vous sûr de vouloir supprimer cette race ?'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  crudRaceBloc.add(DeleteRace(raceId, context));
                  Navigator.of(context).pop();
                },
                child: const Text('Supprimer'),
              ),
            ],
          ),
        );
      },
    );
  }
}