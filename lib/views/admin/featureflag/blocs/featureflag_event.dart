part of 'featureflag_bloc.dart';

@immutable

abstract class FeatureFlagEvent {}

class LoadFeatureFlags extends FeatureFlagEvent {}

class UpdateFeatureFlagStatus extends FeatureFlagEvent {
  final int featureFlagId;
  final bool isEnabled;
  final String message;

  UpdateFeatureFlagStatus(this.featureFlagId, this.isEnabled, this.message);
}