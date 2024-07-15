import 'package:auth_flow_flutter_rxdart/domain/usecases/base_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/get_profile_usecase.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/profile/profile_state.dart';

class ProfileBloc {
  /// Input
  final Sink<void> initState;
  final Function0<void> dispose;

  /// Output
  final Stream<ProfileState?> authStatus$;

  factory ProfileBloc(GetProfileUseCase getProfileUseCase) {
    final initState = BehaviorSubject<void>();

    final Stream<ProfileState?> authStatus$ = initState
        .debounceTime(const Duration(milliseconds: 350))
        .exhaustMap((_) {
      return Stream.fromFuture(getProfileUseCase.execute(NoParams()))
          .flatMap((either) => either.fold((error) {
                return Stream.value(ProfileError(error.toString()));
              }, (data) {
                return Stream.value(ProfileSuccess(data: data));
              }))
          .onErrorReturnWith(
              (error, _) => const ProfileError("Đã có lỗi xảy ra"));
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
