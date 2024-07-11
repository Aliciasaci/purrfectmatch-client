part of 'association_bloc.dart';

@immutable

abstract class AssociationState {}

class AssociationInitial extends AssociationState {}

class AssociationLoading extends AssociationState {}

class AssociationLoaded extends AssociationState {
  final List<Association> associations;

  AssociationLoaded(this.associations);
}

class AssociationError extends AssociationState {
  final String message;

  AssociationError(this.message);
}
