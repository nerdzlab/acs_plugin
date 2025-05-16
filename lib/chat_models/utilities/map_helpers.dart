Object? readValueObject(Map json, String key) =>
    (json[key] as Map?)?.cast<String, dynamic>();

Object? readValueListObjects(Map json, String key) {
  final value = json[key] as List?;

  return value?.map((e) => (e as Map).cast<String, dynamic>()).toList();
}
