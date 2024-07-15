import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:auth_flow_flutter_rxdart/data/models/auth/customer_model.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/sign_in_usecase.dart';

abstract class AuthRemoteDataSource {
  Future<CustomerResponse> signInWithGoogle();
  Future<CustomerResponse> signIn(ReqLoginCommand command);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl(this._firebaseAuth, this._googleSignIn);

  @override
  Future<CustomerResponse> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    final UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);
    User? user = userCredential.user;
    if (user != null) {
      CustomerResponse transform = CustomerResponse(
          displayName: user.displayName,
          email: user.email,
          isEmailVerified: user.emailVerified,
          isAnonymous: user.isAnonymous,
          phoneNumber: user.phoneNumber,
          photoURL: user.photoURL);
      Map<String, dynamic> userMap = transform.toMap();
      return CustomerResponse.fromJson(userMap);
    } else {
      throw Exception('Sign in with Google failed');
    }
  }

  @override
  Future<CustomerResponse> signIn(ReqLoginCommand command) async {
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: command.email,
      password: command.password,
    );
    User? user = userCredential.user;
    if (user != null) {
      CustomerResponse transform = CustomerResponse(
          displayName: user.displayName,
          email: user.email,
          isEmailVerified: user.emailVerified,
          isAnonymous: user.isAnonymous,
          phoneNumber: user.phoneNumber,
          photoURL: user.photoURL);
      Map<String, dynamic> userMap = transform.toMap();
      return CustomerResponse.fromJson(userMap);
    } else {
      throw Exception('Sign in with email and password failed');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Logout failed');
    }
  }
}
