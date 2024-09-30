// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';

import 'package:flutter_dropdown_alert/dropdown_alert.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import 'package:auth_flow_flutter_rxdart/main.dart';
import 'package:auth_flow_flutter_rxdart/common/extensions/bloc_provider.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/auth/auth_bloc.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/profile/profile_bloc.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/favourites/favourite_bloc.dart';

class MockProfileBloc extends Mock implements ProfileBloc {}

class MockAuthBloc extends Mock implements AuthBloc {}

class MockFavouriteBloc extends Mock implements FavouriteBloc {}
void main() {
  late MockProfileBloc mockProfileBloc;
  late MockAuthBloc mockAuthBloc;
  late MockFavouriteBloc mockFavouriteBloc;

  setUp(() {
    // Registering mock BLoCs with GetIt
    mockProfileBloc = MockProfileBloc();
    mockAuthBloc = MockAuthBloc();
    mockFavouriteBloc = MockFavouriteBloc();
    final injector = GetIt.instance;
    injector.registerSingleton<ProfileBloc>(mockProfileBloc);
    injector.registerSingleton<AuthBloc>(mockAuthBloc);
    injector.registerSingleton<FavouriteBloc>(mockFavouriteBloc);
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  testWidgets('MyApp initializes with MaterialApp and BlocProviders', (WidgetTester tester) async {
    // Build the MyApp widget
    await tester.pumpWidget(const MyApp());

    // Check if MaterialApp is present
    expect(find.byType(MaterialApp), findsOneWidget);

    // Verify the BlocProvider setup
    expect(find.byType(BlocProvider<ProfileBloc>), findsOneWidget);
    expect(find.byType(BlocProvider<AuthBloc>), findsOneWidget);
    expect(find.byType(BlocProvider<FavouriteBloc>), findsOneWidget);

    // Verify DropdownAlert is included in the widget tree
    expect(find.byType(DropdownAlert), findsOneWidget);
  });

  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   // // Build our app and trigger a frame.
  //   // await tester.pumpWidget(const MyApp());
  //   //
  //   // // Verify that our counter starts at 0.
  //   // expect(find.text('0'), findsOneWidget);
  //   // expect(find.text('1'), findsNothing);
  //   //
  //   // // Tap the '+' icon and trigger a frame.
  //   // await tester.tap(find.byIcon(Icons.add));
  //   // await tester.pump();
  //   //
  //   // // Verify that our counter has incremented.
  //   // expect(find.text('0'), findsNothing);
  //   // expect(find.text('1'), findsOneWidget);
  // });
}
