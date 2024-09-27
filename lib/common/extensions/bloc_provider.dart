import 'package:flutter/material.dart';

// Generic Interface for all BLoCs
abstract class BlocBase {
  void dispose();
}

// Updated BlocProvider
class BlocProvider<T extends BlocBase> extends StatefulWidget {
  final T bloc;
  final Widget? child;

  const BlocProvider({
    super.key,
    required this.bloc,
    this.child,
  });

  const BlocProvider.value({
    super.key,
    required this.bloc,
    this.child,
  });

  @override
  BlocProviderState<T> createState() => BlocProviderState<T>();

  static T? of<T extends BlocBase>(BuildContext context) {
    BlocProvider<T>? provider =
        context.findAncestorWidgetOfExactType<BlocProvider<T>>();
    return provider?.bloc;
  }
}

class BlocProviderState<T extends BlocBase> extends State<BlocProvider<T>> {
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox.shrink();
  }
}