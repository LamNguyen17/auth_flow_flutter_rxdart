import 'dart:io';
import 'package:flutter/material.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/bloc_provider.dart';
import 'package:auth_flow_flutter_rxdart/presentation/components/app_button.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/auth/auth_bloc.dart';
import 'package:auth_flow_flutter_rxdart/presentation/assets/images/app_images.dart';

class SocialSignInView extends StatelessWidget {
  const SocialSignInView({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Center(
            child: AppTouchable(
                onPress: () {
                  authBloc?.signInWithFacebook.add(null);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Image.asset(
                    AppImages.icFb,
                    width: 32,
                    height: 32,
                  ),
                )),
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: AppTouchable(
                onPress: () {
                  authBloc?.signInWithGoogle.add(null);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Image.asset(
                    AppImages.icGg,
                    width: 32,
                    height: 32,
                  ),
                )),
          ),
        ),
        Platform.isAndroid
            ? const SizedBox.shrink()
            : Expanded(
                flex: 1,
                child: Center(
                  child: AppTouchable(
                    onPress: () {
                      authBloc?.signInWithApple.add(null);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 24.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Image.asset(
                        AppImages.icApple,
                        width: 32,
                        height: 32,
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
