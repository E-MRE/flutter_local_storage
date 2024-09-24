import 'package:flutter_local_storage/flutter_local_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import '../models/sample_storage_model.dart';
import 'hive_common.dart';

///!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\\\
///******************************************************************\\\
///--- PLEASE DOWNLOAD libisar_macos.dylib FILE BEFORE RUN TEST! ----\\\
///******************************************************************\\\
///!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\\\

final _allKeys = [
  _CustomKey.model,
  _CustomKey.list,
  _CustomKey.invalid,
  _CustomKey.primitive,
  _CustomKey.simpleList,
];

class InvalidStorageModel {
  final String name;
  const InvalidStorageModel(this.name);
}

class _CustomKey implements StorageKeys {
  @override
  final String key;

  const _CustomKey._(this.key);

  static const _CustomKey model = _CustomKey._('MODEL');
  static const _CustomKey list = _CustomKey._('LIST');
  static const _CustomKey invalid = _CustomKey._('INVALID');
  static const _CustomKey primitive = _CustomKey._('PRIMITIVE');
  static const _CustomKey simpleList = _CustomKey._('SIMPLE_LIST');
}

void main() {
  late FlutterLocalStorageService hive;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initTests();
    hive = HiveStorageManager();
    hive.register<SampleStorageModel>((json) => SampleStorageModel.fromJson(json));
    hive.registerPrimitiveList<String>((json) {
      if (json is! List) {
        return [];
      }

      return json.map((element) => element.toString()).toList();
    });
    hive.registerList<SampleStorageModel>((json) {
      if (json is! List) {
        return [];
      }

      return json.map((element) => SampleStorageModel.fromJson(element)).toList();
    });
  });

  tearDownAll(() {
    try {
      for (var key in _allKeys) {
        Hive.box<SampleStorageModel>(name: key.key).deleteFromDisk();
        Hive.box<List<SampleStorageModel>>(name: key.key).deleteFromDisk();
        Hive.box<String>(name: key.key).deleteFromDisk();
        Hive.box<List<String>>(name: key.key).deleteFromDisk();
      }
    } catch (_) {}
  });

  group('Add, get and delete operations on SampleStorageModel test', () {
    test('Add item to storage test', () {
      final addResult = hive.setValue<SampleStorageModel>(
        _CustomKey.model,
        const SampleStorageModel(id: 3, name: 'myMan'),
      );

      expect(addResult.isSuccess, true);
      expect(addResult.message, isEmpty);
    });

    test('Get item from Storage', () {
      final itemResult = hive.getValue<SampleStorageModel>(_CustomKey.model);
      expect(itemResult.isSuccessAndDataExists, true);
      expect(itemResult.data!.id, 3);
      expect(itemResult.data!.name, 'myMan');
    });

    test('Delete item from storage test', () {
      final deleteResult = hive.deleteValue<SampleStorageModel>(_CustomKey.model);
      expect(deleteResult.isSuccess, true);
      expect(deleteResult.message, isEmpty);
    });
  });

  group('Add, get and delete operations on List<StorageModel> test', () {
    test('Add SampleStorageModel items to Storage test', () {
      final addResult = hive.setValue<List<SampleStorageModel>>(
        _CustomKey.list,
        [
          const SampleStorageModel(id: 3, name: 'myMan'),
          const SampleStorageModel(id: 4, name: 'myMan2'),
          const SampleStorageModel(id: 5, name: 'myMan3'),
        ],
      );

      expect(addResult.isSuccess, true);
      expect(addResult.message, isEmpty);
    });

    test('Get SampleStorageModel items from Storage test', () {
      final itemResult = hive.getValue<List<SampleStorageModel>>(_CustomKey.list);
      expect(itemResult.isSuccessAndDataExists, true);
      expect(itemResult.data!.length, 3);
      expect(itemResult.data!.first.name, 'myMan');
    });

    test('Delete SampleStorageModel items from Storage test', () {
      final deleteResult = hive.deleteValue<List<SampleStorageModel>>(_CustomKey.list);
      expect(deleteResult.isSuccess, true);
      expect(deleteResult.message, isEmpty);
    });
  });

  group('Add, get and delete operations on String value test', () {
    test('Add String value to storage test', () {
      final itemResult = hive.setValue<String>(_CustomKey.primitive, 'My value');
      expect(itemResult.isSuccess, true);
    });

    test('Get String value from storage test', () {
      final valueResult = hive.getValue<String>(_CustomKey.primitive);
      expect(valueResult.isSuccessAndDataExists, true);
      expect(valueResult.data, isNotNull);
      expect(valueResult.data, isNotEmpty);
      expect(valueResult.data, 'My value');
    });

    test('Delete String value from storage test', () {
      final valueResult = hive.deleteValue<String>(_CustomKey.primitive);
      expect(valueResult.isSuccess, true);
    });
  });

  group('Add, get and delete String list test', () {
    test('Add String list value to storage test', () {
      final itemResult = hive.setValue<List<String>>(_CustomKey.simpleList, ['My value', 'Your value']);
      expect(itemResult.isSuccess, true);
    });

    test('Get String list value from storage test', () {
      final valueResult = hive.getValue<List<String>>(_CustomKey.simpleList);
      expect(valueResult.isSuccessAndDataExists, true);
      expect(valueResult.data, isNotNull);
      expect(valueResult.data, isNotEmpty);
      expect(valueResult.data!.length, 2);
      expect(valueResult.data!.first, 'My value');
      expect(valueResult.data!.last, 'Your value');
    });

    test('Delete String list value from storage test', () {
      final itemResult = hive.deleteValue<List<String>>(_CustomKey.simpleList);
      expect(itemResult.isSuccess, true);
    });
  });

  group('Add, get and delete invalid model test', () {
    test('Add invalid item to storage test', () {
      final addResult = hive.setValue<InvalidStorageModel>(_CustomKey.invalid, const InvalidStorageModel('invalid'));

      expect(addResult.isSuccess, false);
      expect(addResult.message, isNotEmpty);
      expect(addResult.message, ErrorMessages.invalidStorageItem.code);
    });

    test('Get not exists item from storage test', () {
      final itemResult = hive.getValue<InvalidStorageModel>(_CustomKey.invalid);
      expect(itemResult.isSuccessAndDataExists, false);
      expect(itemResult.data, isNull);
      expect(itemResult.message, isNotEmpty);
      expect(itemResult.message, ErrorMessages.valueNotFoundOnStorageKey.code);
    });

    test('Delete not exists item from storage test', () {
      final itemResult = hive.deleteValue<InvalidStorageModel>(_CustomKey.invalid);
      expect(itemResult.isSuccess, false);
    });
  });
}
