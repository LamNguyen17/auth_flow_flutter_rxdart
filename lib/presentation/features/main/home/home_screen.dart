import 'package:auth_flow_flutter_rxdart/common/blocs/bloc_provider.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/profile/profile_state.dart';
import 'package:auth_flow_flutter_rxdart/presentation/navigations/app_nav_manager.dart';
import 'package:flutter/material.dart';

import 'package:auth_flow_flutter_rxdart/di/injection.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/profile/profile_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _profileBloc = BlocProvider.of<ProfileBloc>(AppNavManager.currentContext.currentContext!)!;

  @override
  void initState() {
    super.initState();
    _profileBloc.initState.add(null);
    print('HomeScreen_initState:');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('Home Screen'),
        ),
        // body: Text('Home Screen'),
        body: StreamBuilder<ProfileState?>(
          stream: _profileBloc.authStatus$,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final state = snapshot.data;
              if (state is ProfileSuccess) {
                final user = state.data;
                return Text(
                  'Hello ${user.displayName}',
                  style: const TextStyle(
                    fontSize: 26,
                  ),
                );
              } else if (state is ProfileError) {
                return Text('Profile Error: ${state.message}');
              }
            }
            return const Text('Default Profile Screen');
          },
        ));
  }
}
