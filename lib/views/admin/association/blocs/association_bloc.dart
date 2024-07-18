import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purrfectmatch/models/association.dart';
import 'package:purrfectmatch/services/api_service.dart';

part 'association_event.dart';
part 'association_state.dart';

class AssociationBloc extends Bloc<AssociationEvent, AssociationState> {
  final ApiService apiService;

  AssociationBloc({required this.apiService}) : super(AssociationInitial()) {
    on<LoadAssociations>(_onLoadAssociations);
    on<UpdateAssociationVerifyStatus>(_onUpdateAssociationVerifyStatus);
  }

  Future<void> _onLoadAssociations(LoadAssociations event, Emitter<AssociationState> emit) async {
    emit(AssociationLoading());
    try {
      final associations = await apiService.fetchAllAssociations();
      print('Associations: $associations');
      emit(AssociationLoaded(associations));
    } catch (e) {
      print('Error: $e');
      emit(AssociationError('Erreur lors du chargement des associations.'));
    }
  }

  Future<void> _onUpdateAssociationVerifyStatus(UpdateAssociationVerifyStatus event, Emitter<AssociationState> emit) async {
    if (state is AssociationLoaded) {
      try {
        final updatedAssociations = (state as AssociationLoaded).associations.map((association) {
          if (association.ID == event.associationId) {
            return association.copyWith(Verified: event.verified);
          }
          return association;
        }).toList();

        emit(AssociationLoaded(updatedAssociations));

        await apiService.updateAssociationVerifyStatus(event.associationId, event.verified);
      } catch (e) {
        emit(AssociationError('Erreur lors de la mise à jour du statut de vérification de l\'association.'));
      }
    }
  }
}
