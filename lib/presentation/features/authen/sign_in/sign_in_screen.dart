import 'package:auth_flow_flutter_rxdart/presentation/utils/authentication.dart';
import 'package:flutter/material.dart';

import 'package:auth_flow_flutter_rxdart/presentation/assets/images/app_images.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/authen/sign_in/widgets/google_sign_in.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom: 20.0,
        ),
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          const Row(),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: Image.asset(AppImages.fbLogo, height: 160,)
                ),
                const SizedBox(height: 20),
                const Text(
                  'FlutterFire',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                const Text(
                  'Authentication',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
          // const GoogleSignIn(),

          FutureBuilder(
            future: Authentication.initializeFirebase(context: context),
            builder: (context, snapshot) {
              print('snapshot: $snapshot');
              if (snapshot.hasError) {
                return const Text('Error initializing Firebase');
              } else if (snapshot.connectionState ==
                  ConnectionState.done) {
                return const GoogleSignIn();
              }
              return const CircularProgressIndicator();
            },
          ),
        ]),
      ),
    ));
  }
}
