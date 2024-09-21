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
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  // static T of<T extends BlocBase>(BuildContext context) {
  //   final provider = context.findAncestorStateOfType<_BlocProviderState<T>>();
  //   return provider!.widget.bloc;
  // }
  static T? of<T extends BlocBase>(BuildContext context) {
    BlocProvider<T>? provider =
        context.findAncestorWidgetOfExactType<BlocProvider<T>>();
    return provider?.bloc;
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
    return widget.child ?? const SizedBox.shrink();
  }
}
//
// // MultiBlocProvider with Disposal
// class MultiBlocProvider extends StatefulWidget {
//   final List<BlocProvider> providers;
//   final Widget child;
//
//   MultiBlocProvider({
//     required this.providers,
//     required this.child,
//   });
//
//   @override
//   _MultiBlocProviderState createState() => _MultiBlocProviderState();
// }
//
// class _MultiBlocProviderState extends State<MultiBlocProvider> {
//   @override
//   void dispose() {
//     // Dispose all BLoCs provided
//     for (final provider in widget.providers) {
//       provider.bloc.dispose();
//     }
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Widget tree = widget.child;
//
//     for (final provider in widget.providers.reversed) {
//       tree = BlocProvider(
//         bloc: provider.bloc,
//         child: tree,
//       );
//     }
//
//     return tree;
//   }
// }
