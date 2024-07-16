import 'package:flutter/material.dart';

// Generic Interface for all BLoCs
abstract class BlocBase {
  void dispose();
}

// Generic BLoC provider
class BlocProvider<T extends BlocBase> extends StatefulWidget {
  const BlocProvider({
    super.key,
    required this.bloc,
    this.child,
  });

  final T bloc;
  final Widget? child;

  @override
  State<BlocProvider<BlocBase>> createState() => _BlocProviderState<T>();

  static T? of<T extends BlocBase>(BuildContext context) {
    BlocProvider<T>? provider =
    context.findAncestorWidgetOfExactType<BlocProvider<T>>();
    return provider?.bloc;
  }
}

class _BlocProviderState<T> extends State<BlocProvider<BlocBase>> {
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

// MultiBlocProvider to handle multiple BLoCs
class MultiBlocProvider extends StatelessWidget {
  final List<BlocProvider> providers;
  final Widget child;

  const MultiBlocProvider({
    super.key,
    required this.providers,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Widget tree = child;
    for (final provider in providers.reversed) {
      tree = provider.copyWith(child: tree);
    }
    return tree;
  }
}

// Extension method to copy BlocProvider with a new child
extension BlocProviderExtension on BlocProvider {
  BlocProvider copyWith({required Widget child}) {
    return BlocProvider(
      key: key,
      bloc: bloc,
      child: child,
    );
  }
}