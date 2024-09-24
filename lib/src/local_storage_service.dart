import 'package:flutter_local_storage/flutter_local_storage.dart';

/// This abstract is includes all necessary locale storage functions.
/// It means, if you want to use any manager to manage your locale operation, your manager have to includes those methods.
abstract class FlutterLocalStorageService {
  /// Add your register adapter function if you want
  Future<void> init();

  void register<T extends LocalStorageModel>(T Function(dynamic json) fromJson);

  void registerList<T extends LocalStorageModel>(List<T> Function(dynamic json) fromJson);

  void registerPrimitiveList<T extends Object>(List<T> Function(dynamic json) fromJson);

  /// Get data what you want from locale
  DataResult<T> getValue<T>(StorageKeys key, {T? defaultValue});

  /// set data what you want to save storage
  Result setValue<T>(StorageKeys key, T item);

  /// delete data what you want to delete it
  Result deleteValue<T>(StorageKeys key);
}
