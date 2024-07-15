import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  String? displayName;
  String? email;
  bool? isEmailVerified;
  bool? isAnonymous;
  String? phoneNumber;
  String? photoURL;

  Customer({
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
