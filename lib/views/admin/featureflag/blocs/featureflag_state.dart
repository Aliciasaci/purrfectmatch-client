part of 'featureflag_bloc.dart';

@immutable
abstract class FeatureFlagState {}

class FeatureFlagInitial extends FeatureFlagState {}

class FeatureFlagLoading extends FeatureFlagState {}

class FeatureFlagLoaded extends FeatureFlagState {
  final List<FeatureFlag> featureFlags;
  final String? message;

  FeatureFlagLoaded(this.featureFlags, {this.message});
}

class FeatureFlagError extends FeatureFlagState {
  final String message;

  FeatureFlagError(this.message);
}