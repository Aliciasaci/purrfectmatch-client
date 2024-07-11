part of 'association_bloc.dart';

@immutable

abstract class AssociationEvent {}

class LoadAssociations extends AssociationEvent {}

class UpdateAssociationVerifyStatus extends AssociationEvent {
  final int associationId;
  final bool verified;

  UpdateAssociationVerifyStatus(this.associationId, this.verified);
}