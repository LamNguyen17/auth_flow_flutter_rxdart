import 'package:json_annotation/json_annotation.dart';

import 'package:auth_flow_flutter_rxdart/domain/entities/auth/customer.dart';

part 'customer_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CustomerResponse {
  final String? displayName;
  final String? email;
  final bool? isEmailVerified;
  final bool? isAnonymous;
  final String? phoneNumber;
  final String? photoURL;

  CustomerResponse({
    this.displayName,
    this.email,
    this.isEmailVerified,
    this.isAnonymous,
    this.phoneNumber,
    this.photoURL,
  });

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'isEmailVerified': isEmailVerified,
      'isAnonymous': isAnonymous,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
    };
  }

  factory CustomerResponse.fromJson(Map<String, dynamic> json) =>
      _$CustomerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerResponseToJson(this);

  Customer toEntity() {
    return Customer(
      displayName: displayName,
      email: email,
      isEmailVerified: isEmailVerified,
      isAnonymous: isAnonymous,
      phoneNumber: phoneNumber,
      photoURL: photoURL,
    );
  }
}
