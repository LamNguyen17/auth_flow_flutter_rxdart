extension DoubleExtension on double {
  double toFixed(int n) => double.parse(toStringAsFixed(n));
}