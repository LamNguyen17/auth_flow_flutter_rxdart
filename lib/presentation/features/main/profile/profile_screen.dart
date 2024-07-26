import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:auth_flow_flutter_rxdart/di/injection.dart';
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
  final _movieBloc = injector.get<MovieBloc>();

  @override
  Widget build(BuildContext context) {
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
          child:
              BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
            if (state is ProfileSuccess) {
              final user = state.data;
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    user.photoURL != null
                        ? ClipOval(
                            child: Material(
                              child: Image.network(
                                user.photoURL!,
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
                    Text(
                      user.displayName ?? '',
                      style: const TextStyle(
                        fontSize: 26,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      '( ${user.email ?? ''} )',
                      style: const TextStyle(
                        fontSize: 20,
                        letterSpacing: 0.5,
                      ),
                    ),
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
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ),
      ),
    );
  }
}
