// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'signaling_chat_thread_properties.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SignalingChatThreadProperties _$SignalingChatThreadPropertiesFromJson(
    Map<String, dynamic> json) {
  return _SignalingChatThreadProperties.fromJson(json);
}

/// @nodoc
mixin _$SignalingChatThreadProperties {
  String get topic => throw _privateConstructorUsedError;

  /// Serializes this SignalingChatThreadProperties to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SignalingChatThreadProperties
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SignalingChatThreadPropertiesCopyWith<SignalingChatThreadProperties>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignalingChatThreadPropertiesCopyWith<$Res> {
  factory $SignalingChatThreadPropertiesCopyWith(
          SignalingChatThreadProperties value,
          $Res Function(SignalingChatThreadProperties) then) =
      _$SignalingChatThreadPropertiesCopyWithImpl<$Res,
          SignalingChatThreadProperties>;
  @useResult
  $Res call({String topic});
}

/// @nodoc
class _$SignalingChatThreadPropertiesCopyWithImpl<$Res,
        $Val extends SignalingChatThreadProperties>
    implements $SignalingChatThreadPropertiesCopyWith<$Res> {
  _$SignalingChatThreadPropertiesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SignalingChatThreadProperties
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topic = null,
  }) {
    return _then(_value.copyWith(
      topic: null == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SignalingChatThreadPropertiesImplCopyWith<$Res>
    implements $SignalingChatThreadPropertiesCopyWith<$Res> {
  factory _$$SignalingChatThreadPropertiesImplCopyWith(
          _$SignalingChatThreadPropertiesImpl value,
          $Res Function(_$SignalingChatThreadPropertiesImpl) then) =
      __$$SignalingChatThreadPropertiesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String topic});
}

/// @nodoc
class __$$SignalingChatThreadPropertiesImplCopyWithImpl<$Res>
    extends _$SignalingChatThreadPropertiesCopyWithImpl<$Res,
        _$SignalingChatThreadPropertiesImpl>
    implements _$$SignalingChatThreadPropertiesImplCopyWith<$Res> {
  __$$SignalingChatThreadPropertiesImplCopyWithImpl(
      _$SignalingChatThreadPropertiesImpl _value,
      $Res Function(_$SignalingChatThreadPropertiesImpl) _then)
      : super(_value, _then);

  /// Create a copy of SignalingChatThreadProperties
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topic = null,
  }) {
    return _then(_$SignalingChatThreadPropertiesImpl(
      topic: null == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SignalingChatThreadPropertiesImpl
    implements _SignalingChatThreadProperties {
  const _$SignalingChatThreadPropertiesImpl({required this.topic});

  factory _$SignalingChatThreadPropertiesImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$SignalingChatThreadPropertiesImplFromJson(json);

  @override
  final String topic;

  @override
  String toString() {
    return 'SignalingChatThreadProperties(topic: $topic)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignalingChatThreadPropertiesImpl &&
            (identical(other.topic, topic) || other.topic == topic));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, topic);

  /// Create a copy of SignalingChatThreadProperties
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SignalingChatThreadPropertiesImplCopyWith<
          _$SignalingChatThreadPropertiesImpl>
      get copyWith => __$$SignalingChatThreadPropertiesImplCopyWithImpl<
          _$SignalingChatThreadPropertiesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SignalingChatThreadPropertiesImplToJson(
      this,
    );
  }
}

abstract class _SignalingChatThreadProperties
    implements SignalingChatThreadProperties {
  const factory _SignalingChatThreadProperties({required final String topic}) =
      _$SignalingChatThreadPropertiesImpl;

  factory _SignalingChatThreadProperties.fromJson(Map<String, dynamic> json) =
      _$SignalingChatThreadPropertiesImpl.fromJson;

  @override
  String get topic;

  /// Create a copy of SignalingChatThreadProperties
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SignalingChatThreadPropertiesImplCopyWith<
          _$SignalingChatThreadPropertiesImpl>
      get copyWith => throw _privateConstructorUsedError;
}
