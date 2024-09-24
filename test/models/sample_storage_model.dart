import 'package:flutter_local_storage/flutter_local_storage.dart';

class SampleStorageModel extends LocalStorageModel {
  final int id;
  final String name;

  const SampleStorageModel({required this.id, required this.name});

  @override
  SampleStorageModel fromJson(Map<String, dynamic> json) {
    return SampleStorageModel(id: json['id'], name: json['name']);
  }

  factory SampleStorageModel.fromJson(Map<String, dynamic> json) {
    return SampleStorageModel(id: json['id'], name: json['name']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
