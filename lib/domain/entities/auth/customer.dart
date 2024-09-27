import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Customer extends Equatable {
  final String? displayName;
  final String? email;
  final bool? isEmailVerified;
  final bool? isAnonymous;
  final String? phoneNumber;
  final String? photoURL;

  const Customer({
    this.displayName,
    this.email,
    this.isEmailVerified,
    this.isAnonymous,
    this.phoneNumber,
    this.photoURL,
  });

  @override
  List<Object?> get props => [
        displayName,
        email,
        isEmailVerified,
        isAnonymous,
        phoneNumber,
        photoURL,
      ];
}
