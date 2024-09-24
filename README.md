# Flutter Local Storage


```dart
class ExampleKeys implements StorageKeys {
  @override
  final String key;
  const ExampleKeys._(this.key);

  static const ExampleKeys myKeys = ExampleKeys._('MyKey');
}

```

