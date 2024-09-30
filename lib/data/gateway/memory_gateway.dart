class MemoryGateway {
  static final MemoryGateway _instance = MemoryGateway._internal();
  final Map<String, String> _data = {};

  // Private constructor
  MemoryGateway._internal();

  // Public method to get the singleton instance
  static MemoryGateway getInstance() {
    return _instance;
  }

  // Static methods to access data
  static String? get(String key) {
    return MemoryGateway.getInstance().getItem(key);
  }

  static void set(String key, String value) {
    MemoryGateway.getInstance().setItem(key, value);
  }

  static void clear() {
    MemoryGateway.getInstance().clearAll();
  }

  // Instance methods for data manipulation
  String? getItem(String key) {
    return _data[key];  // Automatically returns null if key is not found
  }

  void setItem(String key, String value) {
    _data[key] = value;
  }

  void clearAll() {
    _data.clear();  // Clears the map
  }
}