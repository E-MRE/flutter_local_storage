import 'result.dart';

///This class provides operation result, operation message and also provides data.
///If you want to return data with success and message info same time than use this class.
///This class is generic type so you must set your data type. Your data must be an object.
///
///Simple example:
///
///```dart
///Future<DataResult<CityModel>> getCities(String countryCode) async{
///   final cities = await _service.getCities(countryCode);
///   return cities == null ? DataResult.error(message:'Data is null') : DataResult.success(data: cities);
///}
///```
class DataResult<TData> extends Result {
  ///Operation result data.
  final TData? data;

  ///Operation status code.
  final int? statusCode;

  bool get isSuccessAndDataExists => isSuccess && data != null;

  bool get isNotSuccessOrDataNotExists => !isSuccessAndDataExists;

  DataResult({required super.isSuccess, required super.message, required this.data, this.statusCode});

  ///When operation is success and also has data then use this.
  DataResult.success({required this.data, this.statusCode, super.message}) : super.success();

  ///When operation is success and also has data and message then use this.
  DataResult.successByMessage({required this.data, this.statusCode, required super.message}) : super.successByMessage();

  ///When operation is not success and also has data and message then use it.
  DataResult.error({this.data, this.statusCode, required super.message}) : super.error();

  ///When operation is not success and also has data and message is empty then use it.
  DataResult.errorByEmpty({this.data, this.statusCode}) : super.errorByEmpty();
}
