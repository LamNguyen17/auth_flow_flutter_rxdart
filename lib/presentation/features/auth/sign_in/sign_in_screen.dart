import 'package:auth_flow_flutter_rxdart/presentation/assets/images/app_images.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/auth/auth_state.dart';
import 'package:flutter/material.dart';

import 'package:auth_flow_flutter_rxdart/di/injection.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/auth/auth_bloc.dart';
import 'package:auth_flow_flutter_rxdart/presentation/components/clear_focus.dart';
import 'package:auth_flow_flutter_rxdart/presentation/utils/authentication.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/auth/sign_in/widgets/google_sign_in.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _authBloc = injector.get<AuthBloc>();

  @override
  void initState() {
    super.initState();
    // _authBloc.isLoading.listen((isLoading) {
    //   if (isLoading) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text('Loading...'),
    //       ),
    //     );
    //   }
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _authBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ClearFocus(
        child: SafeArea(
          child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppImages.fbLogo,
                    height: 100,
                  ),
                  renderInputWidget(),
                ]),
          ),
        ),
      ),
    );
  }

  Widget renderInputWidget() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        // Add horizontal margin to the entire column
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: const Text(
                    '*',
                    style: TextStyle(fontSize: 12, color: Colors.red),
                  ),
                ),
              ],
            ),
            renderEmailTextField(),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: const Text(
                    'Mật khẩu',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: const Text(
                    '*',
                    style: TextStyle(fontSize: 12, color: Colors.red),
                  ),
                ),
              ],
            ),
            renderPasswordTextField(),
            const SizedBox(height: 20),
            renderSignInButton(),
            const SizedBox(height: 50),
            renderCustomDivider(),
            const SizedBox(height: 50),
            FutureBuilder(
              future: Authentication.initializeFirebase(context: context),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Error initializing Firebase');
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return const GoogleSignIn();
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ));
  }

  Widget renderEmailTextField() {
    final node = FocusScope.of(context);
    return StreamBuilder<String?>(
        stream: _authBloc.email$,
        builder: (context, snapshot) {
          return TextFormField(
            onEditingComplete: () => node.nextFocus(),
            maxLength: 50,
            controller: _authBloc.emailTextEditing,
            onChanged: _authBloc.email,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(fontSize: 12, color: Colors.black),
            decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 10.0),
                counter: const SizedBox.shrink(),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(color: Colors.green),
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(color: Colors.blueGrey),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(color: Colors.blueGrey),
                ),
                hintText: 'Nhập email',
                errorText: snapshot.data,
                hintStyle:
                    const TextStyle(fontSize: 12, color: Colors.blueGrey)),
          );
        });
  }

  Widget renderPasswordTextField() {
    return StreamBuilder<String?>(
        stream: _authBloc.password$,
        builder: (context, snapshot) {
          return TextFormField(
            maxLength: 20,
            obscureText: true,
            controller: _authBloc.passwordTextEditing,
            onChanged: _authBloc.password,
            style: const TextStyle(fontSize: 12, color: Colors.black),
            decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 10.0),
                counter: const SizedBox.shrink(),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(color: Colors.green),
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(color: Colors.blueGrey),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(color: Colors.blueGrey),
                ),
                hintText: 'Nhập mật khẩu',
                errorText: snapshot.data,
                hintStyle: TextStyle(fontSize: 12, color: Colors.blueGrey)),
          );
        });
  }

  Widget renderSignInButton() {
    return SizedBox(
      width: 300,
      height: 45,
      child: StreamBuilder<bool>(
          stream: _authBloc.isSubmit$,
          builder: (context, snapshot) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14.0, vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                splashFactory: NoSplash.splashFactory,
                backgroundColor:
                    snapshot.data == true ? Colors.green : Colors.grey[50],
              ),
              onPressed: snapshot.data == true ? () {
                // devlamnt176@gmail.com / azerTyy101794
                _authBloc.login.add(LoginCommand(
                        email: _authBloc.emailTextEditing.text,
                        password: _authBloc.passwordTextEditing
                            .text) // Add email and password from text field
                    );
              } : null,
              child: const Text('Đăng nhập',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            );
          }),
    );
  }

  Widget renderCustomDivider() {
    return const Row(children: <Widget>[
      Expanded(
        child: Divider(
          color: Colors.grey,
          thickness: 1,
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          'Or continue with',
          style: TextStyle(color: Colors.black),
        ),
      ),
      Expanded(
        child: Divider(
          color: Colors.grey,
          thickness: 1,
        ),
      ),
    ]);
  }
}
