import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import 'package:auth_flow_flutter_rxdart/presentation/features/main/profile/profile_state.dart';

class ProfileBloc {
  /// Input
  final Sink<void> initState;
  final Function0<void> dispose;

  /// Output
  final Stream<ProfileState?> authStatus$;

  factory ProfileBloc() {
    final initState = BehaviorSubject<void>();

    final Stream<ProfileState?> authStatus$ = initState
        .flatMap((_) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return Stream<ProfileState?>.value(ProfileSuccess(data: user));
      } else {
        return Stream<ProfileState?>.value(const ProfileError('User not found'));
      }
    });

    return ProfileBloc._(
      initState: initState,
      authStatus$: authStatus$,
      dispose: () {
        initState.close();
      },
    );
  }

  ProfileBloc._({
    required this.initState,
    required this.dispose,
    required this.authStatus$,
  });
}
