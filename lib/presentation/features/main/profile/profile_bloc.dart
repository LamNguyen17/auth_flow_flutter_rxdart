import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/debug_stream.dart';
import 'package:auth_flow_flutter_rxdart/common/extensions/bloc_provider.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/base_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/get_profile_usecase.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/profile/profile_state.dart';

class ProfileBloc extends BlocBase {
  /// Input
  final Function0<void> disposeBag;
  final Sink<void> getProfile;

  /// Output
  final Stream<dynamic> getProfileMessage$;

  factory ProfileBloc(GetProfileUseCase getProfileUseCase) {
    final getProfile = BehaviorSubject<void>();
    final getProfileMessage$ = getProfile
        .debounceTime(const Duration(milliseconds: 350))
        .exhaustMap((_) {
          return Stream.fromFuture(getProfileUseCase.execute(NoParams()))
              .flatMap((either) => either.fold((error) {
                    return Stream.value(ProfileError(error.toString()));
                  }, (data) {
                    debugPrint('ProfileBloc_loggggg: $data');
                    return Stream.value(ProfileSuccess(data: data));
                  }))
              .debug()
              .startWith(const ProfileLoading())
              .onErrorReturnWith((error, _) => ProfileError(error.toString()));
        })
        .publishReplay(maxSize: 1)
        .autoConnect();

    final factory = ProfileBloc._(
      getProfile: getProfile,
      getProfileMessage$: getProfileMessage$,
      disposeBag: () {
        getProfile.close();
      },
    );
    // factory.initialize();
    return factory;
  }

  @override
  void dispose() {
    disposeBag();
  }

  ProfileBloc._({
    required this.getProfile,
    required this.getProfileMessage$,
    required this.disposeBag,
  });
}
