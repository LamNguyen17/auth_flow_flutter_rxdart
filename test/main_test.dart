import 'package:auth_flow_flutter_rxdart/common/extensions/bloc_provider.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/auth/auth_bloc.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/favourites/favourite_bloc.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/profile/profile_bloc.dart';
import 'package:auth_flow_flutter_rxdart/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/dropdown_alert.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:auth_flow_flutter_rxdart/di/injection.dart';
import 'package:firebase_core/firebase_core.dart';

import 'main_test.mocks.dart';

@GenerateMocks([ProfileBloc, AuthBloc, FavouriteBloc])
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await configureDI();
  });

  late MockProfileBloc mockProfileBloc;
  late MockAuthBloc mockAuthBloc;
  late MockFavouriteBloc mockFavouriteBloc;

  setUp(() {
    mockProfileBloc = MockProfileBloc();
    mockAuthBloc = MockAuthBloc();
    mockFavouriteBloc = MockFavouriteBloc();

    when(injector.get<ProfileBloc>()).thenReturn(mockProfileBloc);
    when(injector.get<AuthBloc>()).thenReturn(mockAuthBloc);
    when(injector.get<FavouriteBloc>()).thenReturn(mockFavouriteBloc);
  });

  testWidgets('MyApp widget should display MaterialApp and its components', (WidgetTester tester) async {
    // Arrange & Act
    await tester.pumpWidget(const MyApp());

    // Assert
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(DropdownAlert), findsOneWidget);
    expect(find.byType(Stack), findsOneWidget);
  });

  testWidgets('MyApp should contain correct theme data', (WidgetTester tester) async {
    // Arrange & Act
    await tester.pumpWidget(const MyApp());

    // Get the MaterialApp to verify the theme
    MaterialApp materialApp = tester.widget(find.byType(MaterialApp));

    // Assert
    expect(materialApp.debugShowCheckedModeBanner, false);
  });

  testWidgets('MyApp should use BlocProviders for ProfileBloc, AuthBloc, and FavouriteBloc', (WidgetTester tester) async {
    // Act
    await tester.pumpWidget(const MyApp());

    // Assert that the BLoC Providers are initialized correctly
    expect(find.byType(BlocProvider<ProfileBloc>), findsOneWidget);
    expect(find.byType(BlocProvider<AuthBloc>), findsOneWidget);
    expect(find.byType(BlocProvider<FavouriteBloc>), findsOneWidget);
  });
}