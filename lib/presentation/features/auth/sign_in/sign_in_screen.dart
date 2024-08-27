import 'package:flutter/material.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/bloc_provider.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/auth/social_sign_in/social_sign_in_view.dart';
import 'package:auth_flow_flutter_rxdart/presentation/assets/images/app_images.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/auth/auth_state.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/auth/auth_bloc.dart';
import 'package:auth_flow_flutter_rxdart/presentation/components/clear_focus.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
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
                  renderInputWidget(node, context),
                  const SocialSignInView(),
                ]),
          ),
        ),
      ),
    );
  }

  Widget renderInputWidget(FocusScopeNode node, BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
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
            renderEmailTextField(authBloc, node),
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
            renderPasswordTextField(authBloc),
            const SizedBox(height: 20),
            renderSignInButton(authBloc),
            const SizedBox(height: 50),
            renderCustomDivider(),
            const SizedBox(height: 50),
          ],
        ));
  }

  Widget renderEmailTextField(AuthBloc authBloc, FocusScopeNode node) {
    return StreamBuilder<String?>(
        stream: authBloc.email$,
        builder: (context, snapshot) {
          return TextFormField(
            onEditingComplete: () => node.nextFocus(),
            maxLength: 50,
            controller: authBloc.emailTextEditing,
            onChanged: authBloc.email,
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

  Widget renderPasswordTextField(AuthBloc authBloc) {
    return StreamBuilder<String?>(
        stream: authBloc.password$,
        builder: (context, snapshot) {
          return TextFormField(
            maxLength: 20,
            obscureText: true,
            controller: authBloc.passwordTextEditing,
            onChanged: authBloc.password,
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
                hintStyle:
                    const TextStyle(fontSize: 12, color: Colors.blueGrey)),
          );
        });
  }

  Widget renderSignInButton(AuthBloc authBloc) {
    return SizedBox(
      width: 300,
      height: 45,
      child: StreamBuilder<bool>(
          stream: authBloc.isSubmitLogin$,
          builder: (context, snapshotSubmit) {
            print('snapshotSubmit: ${snapshotSubmit.data}');
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                splashFactory: NoSplash.splashFactory,
                backgroundColor: snapshotSubmit.data == true
                    ? Colors.green
                    : Colors.grey[50],
              ),
              onPressed: snapshotSubmit.data == true
                  ? () {
                      authBloc.login.add(LoginCommand(
                          email: authBloc.emailTextEditing.text,
                          password: authBloc.passwordTextEditing.text));
                    }
                  : null,
              child: StreamBuilder(
                  stream: authBloc.isLoading$,
                  builder: (context, snapshot) {
                    bool isLoading = snapshot.data ?? false;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ))
                            : Text('Đăng nhập',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: snapshotSubmit.data == true
                                        ? Colors.white
                                        : Colors.grey[400])),
                      ],
                    );
                  }),
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
