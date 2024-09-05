import 'package:flutter/material.dart';

import 'package:auth_flow_flutter_rxdart/di/injection.dart';
import 'package:auth_flow_flutter_rxdart/common/extensions/bloc_provider.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/auth/auth_bloc.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/profile/profile_state.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/profile/profile_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final authBloc = injector.get<AuthBloc>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profileBloc = BlocProvider.of<ProfileBloc>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Profile Screen'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: StreamBuilder(
              stream: profileBloc?.getProfileMessage$,
              builder: (context, snapshot) {
                return Center(
                  child: _renderStatePage(snapshot.data),
                );
              }),
        ),
      ),
    );
  }

  Widget _renderStatePage(ProfileState? state) {
    if (state is ProfileLoading) {
      return const CircularProgressIndicator();
    } else if (state is ProfileSuccess || state is ProfileError) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            state is ProfileSuccess && state.data.photoURL != null
                ? ClipOval(
                    child: Material(
                      child: Image.network(
                        state.data.photoURL!,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  )
                : const ClipOval(
                    child: Material(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Icon(
                          Icons.person,
                          size: 60,
                        ),
                      ),
                    ),
                  ),
            const SizedBox(height: 16.0),
            const Text(
              'Hello',
              style: TextStyle(
                fontSize: 26,
              ),
            ),
            const SizedBox(height: 8.0),
            state is ProfileSuccess &&
                    state.data.displayName?.isNotEmpty == true
                ? Text(
                    state.data.displayName!,
                    style: const TextStyle(
                      fontSize: 26,
                    ),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 8.0),
            state is ProfileSuccess && state.data.email?.isNotEmpty == true
                ? Text(
                    '( ${state.data.email ?? ''} )',
                    style: const TextStyle(
                      fontSize: 20,
                      letterSpacing: 0.5,
                    ),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 24.0),
            const Text(
              'You are now signed in using your Google account. To sign out of your account, click the "Sign Out" button below.',
              style: TextStyle(fontSize: 14, letterSpacing: 0.2),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                authBloc.logout.add(null);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.redAccent,
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              child: const Text('Đăng xuất',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  )),
            ),
          ]);
    } else {
      return const SizedBox();
    }
  }
}
