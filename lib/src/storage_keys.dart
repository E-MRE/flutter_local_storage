/// You can create new classes from this class to provide your own manager.
class StorageKeys {
  /// Your String Key Name
  final String key;
  const StorageKeys._(this.key);

  /// Default Key
  static const StorageKeys test = StorageKeys._('TEST');
}
