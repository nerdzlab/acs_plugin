// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_thread_created_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatThreadCreatedEvent _$ChatThreadCreatedEventFromJson(
    Map<String, dynamic> json) {
  return _ChatThreadCreatedEvent.fromJson(json);
}

/// @nodoc
mixin _$ChatThreadCreatedEvent {
  String get threadId => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  String get createdOn => throw _privateConstructorUsedError;
  @JsonKey(name: 'properties', readValue: readValueObject)
  SignalingChatThreadProperties get properties =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'participants', readValue: readValueListObjects)
  List<SignalingChatParticipant> get participants =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'createdBy', readValue: readValueObject)
  SignalingChatParticipant get createdBy => throw _privateConstructorUsedError;

  /// Serializes this ChatThreadCreatedEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatThreadCreatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatThreadCreatedEventCopyWith<ChatThreadCreatedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatThreadCreatedEventCopyWith<$Res> {
  factory $ChatThreadCreatedEventCopyWith(ChatThreadCreatedEvent value,
          $Res Function(ChatThreadCreatedEvent) then) =
      _$ChatThreadCreatedEventCopyWithImpl<$Res, ChatThreadCreatedEvent>;
  @useResult
  $Res call(
      {String threadId,
      String version,
      String createdOn,
      @JsonKey(name: 'properties', readValue: readValueObject)
      SignalingChatThreadProperties properties,
      @JsonKey(name: 'participants', readValue: readValueListObjects)
      List<SignalingChatParticipant> participants,
      @JsonKey(name: 'createdBy', readValue: readValueObject)
      SignalingChatParticipant createdBy});

  $SignalingChatThreadPropertiesCopyWith<$Res> get properties;
  $SignalingChatParticipantCopyWith<$Res> get createdBy;
}

/// @nodoc
class _$ChatThreadCreatedEventCopyWithImpl<$Res,
        $Val extends ChatThreadCreatedEvent>
    implements $ChatThreadCreatedEventCopyWith<$Res> {
  _$ChatThreadCreatedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatThreadCreatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? threadId = null,
    Object? version = null,
    Object? createdOn = null,
    Object? properties = null,
    Object? participants = null,
    Object? createdBy = null,
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
      createdOn: null == createdOn
          ? _value.createdOn
          : createdOn // ignore: cast_nullable_to_non_nullable
              as String,
      properties: null == properties
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as SignalingChatThreadProperties,
      participants: null == participants
          ? _value.participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<SignalingChatParticipant>,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as SignalingChatParticipant,
    ) as $Val);
  }

  /// Create a copy of ChatThreadCreatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SignalingChatThreadPropertiesCopyWith<$Res> get properties {
    return $SignalingChatThreadPropertiesCopyWith<$Res>(_value.properties,
        (value) {
      return _then(_value.copyWith(properties: value) as $Val);
    });
  }

  /// Create a copy of ChatThreadCreatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SignalingChatParticipantCopyWith<$Res> get createdBy {
    return $SignalingChatParticipantCopyWith<$Res>(_value.createdBy, (value) {
      return _then(_value.copyWith(createdBy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChatThreadCreatedEventImplCopyWith<$Res>
    implements $ChatThreadCreatedEventCopyWith<$Res> {
  factory _$$ChatThreadCreatedEventImplCopyWith(
          _$ChatThreadCreatedEventImpl value,
          $Res Function(_$ChatThreadCreatedEventImpl) then) =
      __$$ChatThreadCreatedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String threadId,
      String version,
      String createdOn,
      @JsonKey(name: 'properties', readValue: readValueObject)
      SignalingChatThreadProperties properties,
      @JsonKey(name: 'participants', readValue: readValueListObjects)
      List<SignalingChatParticipant> participants,
      @JsonKey(name: 'createdBy', readValue: readValueObject)
      SignalingChatParticipant createdBy});

  @override
  $SignalingChatThreadPropertiesCopyWith<$Res> get properties;
  @override
  $SignalingChatParticipantCopyWith<$Res> get createdBy;
}

/// @nodoc
class __$$ChatThreadCreatedEventImplCopyWithImpl<$Res>
    extends _$ChatThreadCreatedEventCopyWithImpl<$Res,
        _$ChatThreadCreatedEventImpl>
    implements _$$ChatThreadCreatedEventImplCopyWith<$Res> {
  __$$ChatThreadCreatedEventImplCopyWithImpl(
      _$ChatThreadCreatedEventImpl _value,
      $Res Function(_$ChatThreadCreatedEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatThreadCreatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? threadId = null,
    Object? version = null,
    Object? createdOn = null,
    Object? properties = null,
    Object? participants = null,
    Object? createdBy = null,
  }) {
    return _then(_$ChatThreadCreatedEventImpl(
      threadId: null == threadId
          ? _value.threadId
          : threadId // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      createdOn: null == createdOn
          ? _value.createdOn
          : createdOn // ignore: cast_nullable_to_non_nullable
              as String,
      properties: null == properties
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as SignalingChatThreadProperties,
      participants: null == participants
          ? _value._participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<SignalingChatParticipant>,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as SignalingChatParticipant,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatThreadCreatedEventImpl implements _ChatThreadCreatedEvent {
  const _$ChatThreadCreatedEventImpl(
      {required this.threadId,
      required this.version,
      required this.createdOn,
      @JsonKey(name: 'properties', readValue: readValueObject)
      required this.properties,
      @JsonKey(name: 'participants', readValue: readValueListObjects)
      required final List<SignalingChatParticipant> participants,
      @JsonKey(name: 'createdBy', readValue: readValueObject)
      required this.createdBy})
      : _participants = participants;

  factory _$ChatThreadCreatedEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatThreadCreatedEventImplFromJson(json);

  @override
  final String threadId;
  @override
  final String version;
  @override
  final String createdOn;
  @override
  @JsonKey(name: 'properties', readValue: readValueObject)
  final SignalingChatThreadProperties properties;
  final List<SignalingChatParticipant> _participants;
  @override
  @JsonKey(name: 'participants', readValue: readValueListObjects)
  List<SignalingChatParticipant> get participants {
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participants);
  }

  @override
  @JsonKey(name: 'createdBy', readValue: readValueObject)
  final SignalingChatParticipant createdBy;

  @override
  String toString() {
    return 'ChatThreadCreatedEvent(threadId: $threadId, version: $version, createdOn: $createdOn, properties: $properties, participants: $participants, createdBy: $createdBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatThreadCreatedEventImpl &&
            (identical(other.threadId, threadId) ||
                other.threadId == threadId) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.createdOn, createdOn) ||
                other.createdOn == createdOn) &&
            (identical(other.properties, properties) ||
                other.properties == properties) &&
            const DeepCollectionEquality()
                .equals(other._participants, _participants) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      threadId,
      version,
      createdOn,
      properties,
      const DeepCollectionEquality().hash(_participants),
      createdBy);

  /// Create a copy of ChatThreadCreatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatThreadCreatedEventImplCopyWith<_$ChatThreadCreatedEventImpl>
      get copyWith => __$$ChatThreadCreatedEventImplCopyWithImpl<
          _$ChatThreadCreatedEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatThreadCreatedEventImplToJson(
      this,
    );
  }
}

abstract class _ChatThreadCreatedEvent implements ChatThreadCreatedEvent {
  const factory _ChatThreadCreatedEvent(
          {required final String threadId,
          required final String version,
          required final String createdOn,
          @JsonKey(name: 'properties', readValue: readValueObject)
          required final SignalingChatThreadProperties properties,
          @JsonKey(name: 'participants', readValue: readValueListObjects)
          required final List<SignalingChatParticipant> participants,
          @JsonKey(name: 'createdBy', readValue: readValueObject)
          required final SignalingChatParticipant createdBy}) =
      _$ChatThreadCreatedEventImpl;

  factory _ChatThreadCreatedEvent.fromJson(Map<String, dynamic> json) =
      _$ChatThreadCreatedEventImpl.fromJson;

  @override
  String get threadId;
  @override
  String get version;
  @override
  String get createdOn;
  @override
  @JsonKey(name: 'properties', readValue: readValueObject)
  SignalingChatThreadProperties get properties;
  @override
  @JsonKey(name: 'participants', readValue: readValueListObjects)
  List<SignalingChatParticipant> get participants;
  @override
  @JsonKey(name: 'createdBy', readValue: readValueObject)
  SignalingChatParticipant get createdBy;

  /// Create a copy of ChatThreadCreatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatThreadCreatedEventImplCopyWith<_$ChatThreadCreatedEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}
