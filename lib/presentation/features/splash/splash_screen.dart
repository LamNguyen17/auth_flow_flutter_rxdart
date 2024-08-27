import 'package:flutter/material.dart';

import 'package:auth_flow_flutter_rxdart/di/injection.dart';
import 'package:auth_flow_flutter_rxdart/common/services/notification_service.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/auth/auth_bloc.dart';
import 'package:auth_flow_flutter_rxdart/presentation/components/app_button.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/splash/splash_bloc.dart';
import 'package:auth_flow_flutter_rxdart/presentation/assets/images/app_images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _splashBloc = injector.get<SplashBloc>();
  final _authBloc = injector.get<AuthBloc>();

  @override
  void initState() {
    super.initState();
    _authBloc.initState.add(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      AppImages.fbLogo,
                      height: 180,
                    ),
                    const SizedBox(height: 20),
                    AppTouchable(
                      child: Container(
                        width: 300,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 24.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Center(child: Text('Đăng nhập')),
                      ),
                      onPress: () {
                        _splashBloc.onSignIn.add(null);
                        // _notificationService.showNotification('Hello', 'Hello world');
                      },
                    ),
                    const SizedBox(height: 20),
                    AppTouchable(
                      onPress: () {
                        _splashBloc.onRegister.add(null);
                      },
                      child: Container(
                        width: 300,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 24.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Center(child: Text('Đăng ký')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
