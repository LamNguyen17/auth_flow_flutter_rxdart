enum Flavor { dev, prod }

class FlavorValues {
  final String baseUrl;

  FlavorValues({required this.baseUrl});
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final FlavorValues values;
  static dynamic _instance;

  factory FlavorConfig({
    required Flavor flavor,
    required FlavorValues values,
  }) {
    _instance ??= FlavorConfig._(
      flavor,
      enumName(flavor.toString()),
      values,
    );
    return _instance;
  }

  FlavorConfig._(
    this.flavor,
    this.name,
    this.values,
  );

  static FlavorConfig get instance {
    return _instance;
  }

  static String enumName(String enumToString) {
    var paths = enumToString.split('.');
    return paths[paths.length - 1];
  }

  static bool isProduction() => _instance.flavor == Flavor.prod;

  static bool isDevelopment() => _instance.flavor == Flavor.dev;
}
