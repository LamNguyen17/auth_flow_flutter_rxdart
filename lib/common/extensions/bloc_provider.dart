import 'package:flutter/material.dart';

// Generic Interface for all BLoCs
abstract class BlocBase {
  void dispose();
}

// Updated BlocProvider
class BlocProvider<T extends BlocBase> extends StatefulWidget {
  final T bloc;
  final Widget child;

  BlocProvider({
    required this.bloc,
    required this.child,
  });

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends BlocBase>(BuildContext context) {
    final provider = context.findAncestorStateOfType<_BlocProviderState<T>>();
    return provider!.widget.bloc;
  }
}

class _BlocProviderState<T extends BlocBase> extends State<BlocProvider<T>> {
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

// MultiBlocProvider with Disposal
class MultiBlocProvider extends StatefulWidget {
  final List<BlocProvider> providers;
  final Widget child;

  MultiBlocProvider({
    required this.providers,
    required this.child,
  });

  @override
  _MultiBlocProviderState createState() => _MultiBlocProviderState();
}

class _MultiBlocProviderState extends State<MultiBlocProvider> {
  @override
  void dispose() {
    // Dispose all BLoCs provided
    for (final provider in widget.providers) {
      provider.bloc.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget tree = widget.child;

    for (final provider in widget.providers.reversed) {
      tree = BlocProvider(
        bloc: provider.bloc,
        child: tree,
      );
    }

    return tree;
  }
}
