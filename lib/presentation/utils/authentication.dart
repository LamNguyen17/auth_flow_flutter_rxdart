
import 'package:auth_flow_flutter_rxdart/firebase_options.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/auth/user_info/user_info_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class Authentication {
  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => UserInfoScreen(
            user: user,
          ),
        ),
      );
    }
    return firebaseApp;
  }

  static Future<dynamic> signInWithGoogle({required BuildContext context}) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      print('googleUser: $googleUser');
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      print('googleUser_googleAuth: $googleAuth - ${googleAuth?.accessToken} - ${googleAuth?.idToken}');
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      print('googleUser_credential: $credential');
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      print('googleUser_userCredential: $userCredential');
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException->$e');
    } on Exception catch (e) {
      print('Exception->$e');
    }
  }
  // static Future<User?> signInWithGoogle({required BuildContext context}) async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   User? user;
  //
  //   if (kIsWeb) {
  //     GoogleAuthProvider authProvider = GoogleAuthProvider();
  //
  //     try {
  //       final UserCredential userCredential = await auth.signInWithPopup(authProvider);
  //       print('signInWithGoogle_userCredential: $userCredential');
  //       user = userCredential.user;
  //     } catch (e) {
  //       print(e.toString());
  //     }
  //   } else {
  //     final GoogleSignIn googleSignIn = GoogleSignIn();
  //     print('signInWithGoogle: $googleSignIn');
  //     final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  //     print('signInWithGoogle_1: $googleSignInAccount');
  //
  //     if (googleSignInAccount != null) {
  //       final GoogleSignInAuthentication googleSignInAuthentication =
  //       await googleSignInAccount.authentication;
  //
  //       final AuthCredential credential = GoogleAuthProvider.credential(
  //         accessToken: googleSignInAuthentication.accessToken,
  //         idToken: googleSignInAuthentication.idToken,
  //       );
  //
  //       try {
  //         final UserCredential userCredential =
  //         await auth.signInWithCredential(credential);
  //
  //         user = userCredential.user;
  //       } on FirebaseAuthException catch (e) {
  //         if (e.code == 'account-exists-with-different-credential') {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             Authentication.customSnackBar(
  //               content:
  //               'The account already exists with a different credential',
  //             ),
  //           );
  //         } else if (e.code == 'invalid-credential') {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             Authentication.customSnackBar(
  //               content:
  //               'Error occurred while accessing credentials. Try again.',
  //             ),
  //           );
  //         }
  //       } catch (e) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           Authentication.customSnackBar(
  //             content: 'Error occurred using Google Sign In. Try again.',
  //           ),
  //         );
  //       }
  //     }
  //   }
  //
  //   return user;
  // }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }
}