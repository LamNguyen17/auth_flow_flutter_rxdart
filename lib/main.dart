import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:auth_flow_flutter_rxdart/firebase_options.dart';
import 'package:flutter_dropdown_alert/dropdown_alert.dart';

import 'package:auth_flow_flutter_rxdart/di/injection.dart';
import 'package:auth_flow_flutter_rxdart/common/extensions/bloc_provider.dart';
import 'package:auth_flow_flutter_rxdart/common/services/notification_service.dart';
import 'package:auth_flow_flutter_rxdart/data/common/helper/flavor_config.dart';
import 'package:auth_flow_flutter_rxdart/data/config/app_config.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/auth/auth_bloc.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/favourites/favourite_bloc.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/profile/profile_bloc.dart';
import 'package:auth_flow_flutter_rxdart/presentation/navigations/app_nav_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await configureDI();
  FlavorConfig(
    flavor: Flavor.prod,
    values: FlavorValues(baseUrl: AppConfig.baseUrl),
  );
  await NotificationService().init();
  // Bloc.observer = const AppBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
        bloc: injector.get<ProfileBloc>(),
        child: BlocProvider<AuthBloc>(
            bloc: injector.get<AuthBloc>(),
            child: BlocProvider<FavouriteBloc>(
                bloc: injector.get<FavouriteBloc>(),
                child: MaterialApp.router(
                  routerConfig: AppNavManager.router,
                  title: 'Flutter Demo',
                  debugShowCheckedModeBanner: false,
                  // darkTheme: ThemeData(
                  //   brightness: Brightness.dark,
                  // ),
                  // themeMode: ThemeMode.dark,
                  theme: ThemeData(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    colorScheme:
                        ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                    useMaterial3: true,
                  ),
                  // home: const MyHomePage(title: 'Flutter Demo Home Page'),
                  builder: (context, child) => Stack(
                    children: [child!, const DropdownAlert()],
                  ),
                ))));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// class AppBlocObserver extends BlocObserver {
//   const AppBlocObserver();
//
//   @override
//   void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
//     super.onChange(bloc, change);
//     if (bloc is Cubit) print(change);
//   }
//
//   @override
//   void onTransition(
//     Bloc<dynamic, dynamic> bloc,
//     Transition<dynamic, dynamic> transition,
//   ) {
//     super.onTransition(bloc, transition);
//     print(transition);
//   }
// }
