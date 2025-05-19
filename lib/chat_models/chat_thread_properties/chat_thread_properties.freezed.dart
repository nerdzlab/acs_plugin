// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_thread_properties.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatThreadProperties _$ChatThreadPropertiesFromJson(Map<String, dynamic> json) {
  return _ChatThreadProperties.fromJson(json);
}

/// @nodoc
mixin _$ChatThreadProperties {
  String get id => throw _privateConstructorUsedError;
  String get topic => throw _privateConstructorUsedError;
  String get createdOn => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdBy', readValue: readValueObject)
  CommunicationIdentifier get createdBy => throw _privateConstructorUsedError;
  String? get deletedOn => throw _privateConstructorUsedError;

  /// Serializes this ChatThreadProperties to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatThreadProperties
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatThreadPropertiesCopyWith<ChatThreadProperties> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatThreadPropertiesCopyWith<$Res> {
  factory $ChatThreadPropertiesCopyWith(ChatThreadProperties value,
          $Res Function(ChatThreadProperties) then) =
      _$ChatThreadPropertiesCopyWithImpl<$Res, ChatThreadProperties>;
  @useResult
  $Res call(
      {String id,
      String topic,
      String createdOn,
      @JsonKey(name: 'createdBy', readValue: readValueObject)
      CommunicationIdentifier createdBy,
      String? deletedOn});

  $CommunicationIdentifierCopyWith<$Res> get createdBy;
}

/// @nodoc
class _$ChatThreadPropertiesCopyWithImpl<$Res,
        $Val extends ChatThreadProperties>
    implements $ChatThreadPropertiesCopyWith<$Res> {
  _$ChatThreadPropertiesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatThreadProperties
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? topic = null,
    Object? createdOn = null,
    Object? createdBy = null,
    Object? deletedOn = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      topic: null == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String,
      createdOn: null == createdOn
          ? _value.createdOn
          : createdOn // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as CommunicationIdentifier,
      deletedOn: freezed == deletedOn
          ? _value.deletedOn
          : deletedOn // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of ChatThreadProperties
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CommunicationIdentifierCopyWith<$Res> get createdBy {
    return $CommunicationIdentifierCopyWith<$Res>(_value.createdBy, (value) {
      return _then(_value.copyWith(createdBy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChatThreadPropertiesImplCopyWith<$Res>
    implements $ChatThreadPropertiesCopyWith<$Res> {
  factory _$$ChatThreadPropertiesImplCopyWith(_$ChatThreadPropertiesImpl value,
          $Res Function(_$ChatThreadPropertiesImpl) then) =
      __$$ChatThreadPropertiesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String topic,
      String createdOn,
      @JsonKey(name: 'createdBy', readValue: readValueObject)
      CommunicationIdentifier createdBy,
      String? deletedOn});

  @override
  $CommunicationIdentifierCopyWith<$Res> get createdBy;
}

/// @nodoc
class __$$ChatThreadPropertiesImplCopyWithImpl<$Res>
    extends _$ChatThreadPropertiesCopyWithImpl<$Res, _$ChatThreadPropertiesImpl>
    implements _$$ChatThreadPropertiesImplCopyWith<$Res> {
  __$$ChatThreadPropertiesImplCopyWithImpl(_$ChatThreadPropertiesImpl _value,
      $Res Function(_$ChatThreadPropertiesImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatThreadProperties
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? topic = null,
    Object? createdOn = null,
    Object? createdBy = null,
    Object? deletedOn = freezed,
  }) {
    return _then(_$ChatThreadPropertiesImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      topic: null == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String,
      createdOn: null == createdOn
          ? _value.createdOn
          : createdOn // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as CommunicationIdentifier,
      deletedOn: freezed == deletedOn
          ? _value.deletedOn
          : deletedOn // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatThreadPropertiesImpl implements _ChatThreadProperties {
  const _$ChatThreadPropertiesImpl(
      {required this.id,
      required this.topic,
      required this.createdOn,
      @JsonKey(name: 'createdBy', readValue: readValueObject)
      required this.createdBy,
      this.deletedOn});

  factory _$ChatThreadPropertiesImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatThreadPropertiesImplFromJson(json);

  @override
  final String id;
  @override
  final String topic;
  @override
  final String createdOn;
  @override
  @JsonKey(name: 'createdBy', readValue: readValueObject)
  final CommunicationIdentifier createdBy;
  @override
  final String? deletedOn;

  @override
  String toString() {
    return 'ChatThreadProperties(id: $id, topic: $topic, createdOn: $createdOn, createdBy: $createdBy, deletedOn: $deletedOn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatThreadPropertiesImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.topic, topic) || other.topic == topic) &&
            (identical(other.createdOn, createdOn) ||
                other.createdOn == createdOn) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.deletedOn, deletedOn) ||
                other.deletedOn == deletedOn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, topic, createdOn, createdBy, deletedOn);

  /// Create a copy of ChatThreadProperties
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatThreadPropertiesImplCopyWith<_$ChatThreadPropertiesImpl>
      get copyWith =>
          __$$ChatThreadPropertiesImplCopyWithImpl<_$ChatThreadPropertiesImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatThreadPropertiesImplToJson(
      this,
    );
  }
}

abstract class _ChatThreadProperties implements ChatThreadProperties {
  const factory _ChatThreadProperties(
      {required final String id,
      required final String topic,
      required final String createdOn,
      @JsonKey(name: 'createdBy', readValue: readValueObject)
      required final CommunicationIdentifier createdBy,
      final String? deletedOn}) = _$ChatThreadPropertiesImpl;

  factory _ChatThreadProperties.fromJson(Map<String, dynamic> json) =
      _$ChatThreadPropertiesImpl.fromJson;

  @override
  String get id;
  @override
  String get topic;
  @override
  String get createdOn;
  @override
  @JsonKey(name: 'createdBy', readValue: readValueObject)
  CommunicationIdentifier get createdBy;
  @override
  String? get deletedOn;

  /// Create a copy of ChatThreadProperties
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatThreadPropertiesImplCopyWith<_$ChatThreadPropertiesImpl>
      get copyWith => throw _privateConstructorUsedError;
}
