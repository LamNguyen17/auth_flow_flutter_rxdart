import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:auth_flow_flutter_rxdart/domain/usecases/base_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/get_profile_usecase.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/profile/profile_state.dart';

class ProfileBloc extends Cubit<ProfileState> {
  final GetProfileUseCase getProfile;

  /// Input
  final Function0<void> dispose;

  /// Output
  StreamSubscription<ProfileState>? _profileSubscription;

  factory ProfileBloc(GetProfileUseCase getProfileUseCase) {
    final factory = ProfileBloc._(
      getProfile: getProfileUseCase,
      dispose: () {},
    );
    factory.initialize();
    return factory;
  }

  @override
  Future<void> close() {
    _profileSubscription?.cancel();
    dispose();
    return super.close();
  }

  void initialize() {
    print('initialize');
    _profileSubscription = getUserProfile().listen((event) {
      emit(event);
    });
  }

  Stream<ProfileState> getUserProfile() {
    return Stream.fromFuture(getProfile.execute(NoParams()))
        .debounceTime(const Duration(milliseconds: 350))
        .exhaustMap((either) => either.fold((error) {
              return Stream.value(ProfileError(error.toString()));
            }, (data) {
              return Stream.value(ProfileSuccess(data: data));
            }))
        .startWith(const ProfileLoading())
        .onErrorReturnWith(
            (error, _) => const ProfileError("Đã có lỗi xảy ra"));
  }

  ProfileBloc._({
    required this.getProfile,
    required this.dispose,
  }) : super(const ProfileInitial()) {
    // initialize();
  }
}
