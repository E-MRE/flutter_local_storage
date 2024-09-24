import 'package:flutter_local_storage/flutter_local_storage.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

final class HiveStorageManager with HiveRegisterAdapterMixin implements FlutterLocalStorageService {
  final String? customDirectory;
  final List<Type> _primitives = [
    int,
    double,
    num,
    BigInt,
    String,
    bool,
    List<int>,
    List<double>,
    List<num>,
    List<BigInt>,
    List<String>,
    List<bool>,
  ];

  HiveStorageManager({this.customDirectory});

  @override
  Future<void> init() async {
    Hive.defaultDirectory = await _getPath();
    registerAdapters();
  }

  @override
  void register<T extends LocalStorageModel>(T Function(dynamic json) fromJson) {
    Hive.registerAdapter<T>(T.toString(), fromJson);
  }

  @override
  void registerList<T extends LocalStorageModel>(List<T> Function(dynamic json) fromJson) {
    Hive.registerAdapter<List<T>>('List<${T.toString()}>', fromJson);
  }

  @override
  void registerPrimitiveList<T extends Object>(List<T> Function(dynamic json) fromJson) {
    Hive.registerAdapter<List<T>>('List<${T.toString()}>', fromJson);
  }

  @override
  Result setValue<T>(StorageKeys key, T item) {
    bool isValidType = item is LocalStorageModel || item is List<LocalStorageModel> || _isPrimitive<T>();

    if (!isValidType) {
      return Result.error(message: ErrorMessages.invalidStorageItem.code);
    }

    final box = _getBox<T>(key);
    box.put(key.key, item);
    final isAdded = box.containsKey(key.key);

    return Result(isSuccess: isAdded, message: isAdded ? '' : ErrorMessages.unexpectedErrorWhenAddToLocal.code);
  }

  @override
  DataResult<T> getValue<T>(StorageKeys key, {T? defaultValue}) {
    try {
      final box = _getBox<T>(key);
      final value = box.get(key.key, defaultValue: defaultValue);

      if (value == null) {
        return DataResult<T>.error(message: ErrorMessages.valueNotFoundOnStorageKey.code, data: defaultValue);
      }

      return DataResult<T>.success(data: value);
    } catch (exception) {
      return DataResult<T>.error(message: exception.toString(), data: defaultValue);
    }
  }

  @override
  Result deleteValue<T>(StorageKeys key) {
    final box = _getBox<T>(key);
    bool isDeleted = box.delete(key.key);
    if (isDeleted) {
      return Result.success();
    }

    return isDeleted ? Result.success() : Result.error(message: ErrorMessages.unexpectedErrorWhenDeleteFromLocal.code);
  }

  Future<String> _getPath() async {
    if (customDirectory != null && customDirectory!.isNotEmpty) {
      return customDirectory!;
    }

    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Box<T> _getBox<T>(StorageKeys key) {
    return Hive.box<T>(name: key.key);
  }

  bool _isPrimitive<T>() =>
      _primitives.any((element) => T.toString().toLowerCase().contains(element.toString().toLowerCase()));
}
