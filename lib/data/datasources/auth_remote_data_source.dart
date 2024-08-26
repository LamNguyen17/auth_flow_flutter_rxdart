import 'dart:core';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/register_usecase.dart';
import 'package:auth_flow_flutter_rxdart/data/models/auth/customer_model.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/sign_in_usecase.dart';

abstract class AuthRemoteDataSource {
  Future<CustomerResponse> signInWithGoogle();

  Future<dynamic> signInWithApple();

  Future<CustomerResponse> signInWithFacebook();

  Future<CustomerResponse> signIn(ReqLoginCommand command);

  Future<CustomerResponse> register(ReqRegisterCommand command);

  Future<void> logout();

  Future<CustomerResponse> getProfile();

  Future<void> deleteAccount();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl(this._firebaseAuth, this._googleSignIn);

  @override
  Future<CustomerResponse> getProfile() async {
    final AccessToken? accessToken = await FacebookAuth.instance.accessToken;
    if (accessToken != null) {
      final userData = await FacebookAuth.instance.getUserData();
      CustomerResponse transform = CustomerResponse(
        displayName: userData['name'],
        email: userData['email'],
        photoURL: userData['picture']['data']['url'],
      );
      Map<String, dynamic> userMap = transform.toMap();
      return CustomerResponse.fromJson(userMap);
    } else {
      User? user = FirebaseAuth.instance.currentUser;
      print('AuthRemoteDataSourceImpl_getProfile: $user');
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
        throw Exception('Get profile failed');
      }
    }
  }

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
  Future<CustomerResponse> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    if (loginResult.status == LoginStatus.success) {
      final userData = await FacebookAuth.instance.getUserData();
      CustomerResponse transform = CustomerResponse(
        displayName: userData['name'],
        email: userData['email'],
        photoURL: userData['picture']['data']['url'],
      );
      Map<String, dynamic> userMap = transform.toMap();
      return CustomerResponse.fromJson(userMap);
    } else {
      throw Exception('Sign in with Facebook failed');
    }
  }

  @override
  Future<CustomerResponse> register(ReqRegisterCommand command) async {
    final UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
      throw Exception('Register with email and password failed');
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

  @override
  Future<void> deleteAccount() async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
    } catch (e) {
      throw Exception('Delete Account failed');
    }
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Future<dynamic> signInWithApple() async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    } catch (e) {
      throw Exception('Delete Account failed');
    }
  }
}
