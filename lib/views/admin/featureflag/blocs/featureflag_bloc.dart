import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purrfectmatch/models/feature_flag.dart';
import 'package:purrfectmatch/services/api_service.dart';

part 'featureflag_state.dart';
part 'featureflag_event.dart';

class FeatureFlagBloc extends Bloc<FeatureFlagEvent, FeatureFlagState> {
  final ApiService apiService;

  FeatureFlagBloc({required this.apiService}) : super(FeatureFlagInitial()) {
    on<LoadFeatureFlags>(_onLoadFeatureFlags);
    on<UpdateFeatureFlagStatus>(_onUpdateFeatureFlagStatus);
  }

  Future<void> _onLoadFeatureFlags(LoadFeatureFlags event, Emitter<FeatureFlagState> emit) async {
    emit(FeatureFlagLoading());
    try {
      final featureFlags = await apiService.fetchAllFeatureFlags();
      print('FeatureFlags: $featureFlags');
      emit(FeatureFlagLoaded(featureFlags));
    } catch (e) {
      print('Error: $e');
      emit(FeatureFlagError('Error while loading feature flags.'));
    }
  }

  Future<void> _onUpdateFeatureFlagStatus(UpdateFeatureFlagStatus event, Emitter<FeatureFlagState> emit) async {
    if (state is FeatureFlagLoaded) {
      try {
        final updatedFeatureFlags = (state as FeatureFlagLoaded).featureFlags.map((featureFlag) {
          if (featureFlag.id == event.featureFlagId) {
            return featureFlag.copyWith(isEnabled: event.isEnabled);
          }
          return featureFlag;
        }).toList();

        await apiService.updateFeatureFlagStatus(event.featureFlagId, event.isEnabled);
        emit(FeatureFlagLoaded(updatedFeatureFlags, message: event.message));
      } catch (e) {
        emit(FeatureFlagError('Error while updating feature flag status.'));
      }
    }
  }
}

