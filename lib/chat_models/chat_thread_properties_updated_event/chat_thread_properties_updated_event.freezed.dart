// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_thread_properties_updated_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatThreadPropertiesUpdatedEvent _$ChatThreadPropertiesUpdatedEventFromJson(
    Map<String, dynamic> json) {
  return _ChatThreadPropertiesUpdatedEvent.fromJson(json);
}

/// @nodoc
mixin _$ChatThreadPropertiesUpdatedEvent {
  String get threadId => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  String get updatedOn => throw _privateConstructorUsedError;
  @JsonKey(name: 'properties', readValue: readValueObject)
  SignalingChatThreadProperties get properties =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'updatedBy', readValue: readValueObject)
  SignalingChatParticipant get updatedBy => throw _privateConstructorUsedError;

  /// Serializes this ChatThreadPropertiesUpdatedEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatThreadPropertiesUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatThreadPropertiesUpdatedEventCopyWith<ChatThreadPropertiesUpdatedEvent>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatThreadPropertiesUpdatedEventCopyWith<$Res> {
  factory $ChatThreadPropertiesUpdatedEventCopyWith(
          ChatThreadPropertiesUpdatedEvent value,
          $Res Function(ChatThreadPropertiesUpdatedEvent) then) =
      _$ChatThreadPropertiesUpdatedEventCopyWithImpl<$Res,
          ChatThreadPropertiesUpdatedEvent>;
  @useResult
  $Res call(
      {String threadId,
      String version,
      String updatedOn,
      @JsonKey(name: 'properties', readValue: readValueObject)
      SignalingChatThreadProperties properties,
      @JsonKey(name: 'updatedBy', readValue: readValueObject)
      SignalingChatParticipant updatedBy});

  $SignalingChatThreadPropertiesCopyWith<$Res> get properties;
  $SignalingChatParticipantCopyWith<$Res> get updatedBy;
}

/// @nodoc
class _$ChatThreadPropertiesUpdatedEventCopyWithImpl<$Res,
        $Val extends ChatThreadPropertiesUpdatedEvent>
    implements $ChatThreadPropertiesUpdatedEventCopyWith<$Res> {
  _$ChatThreadPropertiesUpdatedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatThreadPropertiesUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? threadId = null,
    Object? version = null,
    Object? updatedOn = null,
    Object? properties = null,
    Object? updatedBy = null,
  }) {
    return _then(_value.copyWith(
      threadId: null == threadId
          ? _value.threadId
          : threadId // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      updatedOn: null == updatedOn
          ? _value.updatedOn
          : updatedOn // ignore: cast_nullable_to_non_nullable
              as String,
      properties: null == properties
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as SignalingChatThreadProperties,
      updatedBy: null == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as SignalingChatParticipant,
    ) as $Val);
  }

  /// Create a copy of ChatThreadPropertiesUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SignalingChatThreadPropertiesCopyWith<$Res> get properties {
    return $SignalingChatThreadPropertiesCopyWith<$Res>(_value.properties,
        (value) {
      return _then(_value.copyWith(properties: value) as $Val);
    });
  }

  /// Create a copy of ChatThreadPropertiesUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SignalingChatParticipantCopyWith<$Res> get updatedBy {
    return $SignalingChatParticipantCopyWith<$Res>(_value.updatedBy, (value) {
      return _then(_value.copyWith(updatedBy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChatThreadPropertiesUpdatedEventImplCopyWith<$Res>
    implements $ChatThreadPropertiesUpdatedEventCopyWith<$Res> {
  factory _$$ChatThreadPropertiesUpdatedEventImplCopyWith(
          _$ChatThreadPropertiesUpdatedEventImpl value,
          $Res Function(_$ChatThreadPropertiesUpdatedEventImpl) then) =
      __$$ChatThreadPropertiesUpdatedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String threadId,
      String version,
      String updatedOn,
      @JsonKey(name: 'properties', readValue: readValueObject)
      SignalingChatThreadProperties properties,
      @JsonKey(name: 'updatedBy', readValue: readValueObject)
      SignalingChatParticipant updatedBy});

  @override
  $SignalingChatThreadPropertiesCopyWith<$Res> get properties;
  @override
  $SignalingChatParticipantCopyWith<$Res> get updatedBy;
}

/// @nodoc
class __$$ChatThreadPropertiesUpdatedEventImplCopyWithImpl<$Res>
    extends _$ChatThreadPropertiesUpdatedEventCopyWithImpl<$Res,
        _$ChatThreadPropertiesUpdatedEventImpl>
    implements _$$ChatThreadPropertiesUpdatedEventImplCopyWith<$Res> {
  __$$ChatThreadPropertiesUpdatedEventImplCopyWithImpl(
      _$ChatThreadPropertiesUpdatedEventImpl _value,
      $Res Function(_$ChatThreadPropertiesUpdatedEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatThreadPropertiesUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? threadId = null,
    Object? version = null,
    Object? updatedOn = null,
    Object? properties = null,
    Object? updatedBy = null,
  }) {
    return _then(_$ChatThreadPropertiesUpdatedEventImpl(
      threadId: null == threadId
          ? _value.threadId
          : threadId // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      updatedOn: null == updatedOn
          ? _value.updatedOn
          : updatedOn // ignore: cast_nullable_to_non_nullable
              as String,
      properties: null == properties
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as SignalingChatThreadProperties,
      updatedBy: null == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as SignalingChatParticipant,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatThreadPropertiesUpdatedEventImpl
    implements _ChatThreadPropertiesUpdatedEvent {
  const _$ChatThreadPropertiesUpdatedEventImpl(
      {required this.threadId,
      required this.version,
      required this.updatedOn,
      @JsonKey(name: 'properties', readValue: readValueObject)
      required this.properties,
      @JsonKey(name: 'updatedBy', readValue: readValueObject)
      required this.updatedBy});

  factory _$ChatThreadPropertiesUpdatedEventImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ChatThreadPropertiesUpdatedEventImplFromJson(json);

  @override
  final String threadId;
  @override
  final String version;
  @override
  final String updatedOn;
  @override
  @JsonKey(name: 'properties', readValue: readValueObject)
  final SignalingChatThreadProperties properties;
  @override
  @JsonKey(name: 'updatedBy', readValue: readValueObject)
  final SignalingChatParticipant updatedBy;

  @override
  String toString() {
    return 'ChatThreadPropertiesUpdatedEvent(threadId: $threadId, version: $version, updatedOn: $updatedOn, properties: $properties, updatedBy: $updatedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatThreadPropertiesUpdatedEventImpl &&
            (identical(other.threadId, threadId) ||
                other.threadId == threadId) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.updatedOn, updatedOn) ||
                other.updatedOn == updatedOn) &&
            (identical(other.properties, properties) ||
                other.properties == properties) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, threadId, version, updatedOn, properties, updatedBy);

  /// Create a copy of ChatThreadPropertiesUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatThreadPropertiesUpdatedEventImplCopyWith<
          _$ChatThreadPropertiesUpdatedEventImpl>
      get copyWith => __$$ChatThreadPropertiesUpdatedEventImplCopyWithImpl<
          _$ChatThreadPropertiesUpdatedEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatThreadPropertiesUpdatedEventImplToJson(
      this,
    );
  }
}

abstract class _ChatThreadPropertiesUpdatedEvent
    implements ChatThreadPropertiesUpdatedEvent {
  const factory _ChatThreadPropertiesUpdatedEvent(
          {required final String threadId,
          required final String version,
          required final String updatedOn,
          @JsonKey(name: 'properties', readValue: readValueObject)
          required final SignalingChatThreadProperties properties,
          @JsonKey(name: 'updatedBy', readValue: readValueObject)
          required final SignalingChatParticipant updatedBy}) =
      _$ChatThreadPropertiesUpdatedEventImpl;

  factory _ChatThreadPropertiesUpdatedEvent.fromJson(
          Map<String, dynamic> json) =
      _$ChatThreadPropertiesUpdatedEventImpl.fromJson;

  @override
  String get threadId;
  @override
  String get version;
  @override
  String get updatedOn;
  @override
  @JsonKey(name: 'properties', readValue: readValueObject)
  SignalingChatThreadProperties get properties;
  @override
  @JsonKey(name: 'updatedBy', readValue: readValueObject)
  SignalingChatParticipant get updatedBy;

  /// Create a copy of ChatThreadPropertiesUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatThreadPropertiesUpdatedEventImplCopyWith<
          _$ChatThreadPropertiesUpdatedEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}
