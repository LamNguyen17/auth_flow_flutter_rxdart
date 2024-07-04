class MemoryGateway {
  static var _instance = MemoryGateway();
  dynamic _data;

  MemoryGateway() {
    if (MemoryGateway._instance != null) {
      throw const FormatException(
          'Error: Instantiation failed: Use SingletonClass.getInstance() instead of new.');
    }
    MemoryGateway._instance = this;
    _data = {};
  }

  static getInstance() {
    return MemoryGateway._instance;
  }

  static get(String key) {
    return MemoryGateway.getInstance().getItem(key);
  }

  static set(String key, String value) {
    MemoryGateway.getInstance().setItem(key, value);
  }

  static clear() {
    MemoryGateway.getInstance().clearAll();
  }

  getItem(String key) {
    if (_data) {
      var value = _data[key];
      return value ? value : null;
    }
    return null;
  }

  setItem(String key, String value) {
    if (_data) {
      _data[key] = value;
    }
    return true;
  }

  clearAll() {
    return _data = {};
  }
}
