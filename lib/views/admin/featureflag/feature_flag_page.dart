import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/featureflag_bloc.dart';

class FeatureFlagPage extends StatelessWidget {
  const FeatureFlagPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feature Flags'),
      ),
      body: BlocConsumer<FeatureFlagBloc, FeatureFlagState>(
        listener: (context, state) {
          if (state is FeatureFlagLoaded && state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message!)),
            );
          }
        },
        builder: (context, state) {
          if (state is FeatureFlagLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FeatureFlagLoaded) {
            return ListView.builder(
              itemCount: state.featureFlags.length,
              itemBuilder: (context, index) {
                final featureFlag = state.featureFlags[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: SwitchListTile(
                    title: Text(featureFlag.name),
                    value: featureFlag.isEnabled,
                    onChanged: (bool value) {
                      context.read<FeatureFlagBloc>().add(
                        UpdateFeatureFlagStatus(
                          featureFlag.id!,
                          value,
                          value ? 'Feature activée' : 'Feature désactivée',
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (state is FeatureFlagError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Pas de données à afficher.'));
          }
        },
      ),
    );
  }
}