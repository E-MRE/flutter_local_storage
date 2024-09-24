abstract class LocalStorageModel {
  const LocalStorageModel();

  LocalStorageModel fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson();
}
