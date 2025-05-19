import 'dart:convert';

Object? readValueObject(Map json, String key) =>
    (json[key] as Map?)?.cast<String, dynamic>();

Object? readValueListObjects(Map json, String key) {
  final value = json[key] as List?;

  return value?.map((e) => (e as Map).cast<String, dynamic>()).toList();
}

Object? readValueAndDecodeObject(Map json, String key) {
  final value = json[key] as String?;

  if (value?.isEmpty ?? true) return null;
  final decodedValue = jsonDecode(value!);

  return (decodedValue as Map?)?.cast<String, dynamic>();
}

Object? readValueListAndDecodeObjects(Map json, String key) {
  final value = json[key] as String?;

  if (value?.isEmpty ?? true) return null;
  final decodedValue = jsonDecode(value!);

  return decodedValue?.map((e) => (e as Map).cast<String, dynamic>()).toList();
}
