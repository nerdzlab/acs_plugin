// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_messge_deleted_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatMessageDeletedEvent _$ChatMessageDeletedEventFromJson(
    Map<String, dynamic> json) {
  return _ChatMessageDeletedEvent.fromJson(json);
}

/// @nodoc
mixin _$ChatMessageDeletedEvent {
  String get threadId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sender', readValue: readValueObject)
  CommunicationIdentifier? get sender => throw _privateConstructorUsedError;
  @JsonKey(name: 'recipient', readValue: readValueObject)
  CommunicationIdentifier? get recipient => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  String get senderDisplayName => throw _privateConstructorUsedError;
  String get createdOn => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  ChatMessageType? get type => throw _privateConstructorUsedError;
  String? get deletedOn => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this ChatMessageDeletedEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatMessageDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatMessageDeletedEventCopyWith<ChatMessageDeletedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageDeletedEventCopyWith<$Res> {
  factory $ChatMessageDeletedEventCopyWith(ChatMessageDeletedEvent value,
          $Res Function(ChatMessageDeletedEvent) then) =
      _$ChatMessageDeletedEventCopyWithImpl<$Res, ChatMessageDeletedEvent>;
  @useResult
  $Res call(
      {String threadId,
      @JsonKey(name: 'sender', readValue: readValueObject)
      CommunicationIdentifier? sender,
      @JsonKey(name: 'recipient', readValue: readValueObject)
      CommunicationIdentifier? recipient,
      String id,
      String senderDisplayName,
      String createdOn,
      String version,
      ChatMessageType? type,
      String? deletedOn,
      Map<String, dynamic>? metadata});

  $CommunicationIdentifierCopyWith<$Res>? get sender;
  $CommunicationIdentifierCopyWith<$Res>? get recipient;
}

/// @nodoc
class _$ChatMessageDeletedEventCopyWithImpl<$Res,
        $Val extends ChatMessageDeletedEvent>
    implements $ChatMessageDeletedEventCopyWith<$Res> {
  _$ChatMessageDeletedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatMessageDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? threadId = null,
    Object? sender = freezed,
    Object? recipient = freezed,
    Object? id = null,
    Object? senderDisplayName = null,
    Object? createdOn = null,
    Object? version = null,
    Object? type = freezed,
    Object? deletedOn = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      threadId: null == threadId
          ? _value.threadId
          : threadId // ignore: cast_nullable_to_non_nullable
              as String,
      sender: freezed == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as CommunicationIdentifier?,
      recipient: freezed == recipient
          ? _value.recipient
          : recipient // ignore: cast_nullable_to_non_nullable
              as CommunicationIdentifier?,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      senderDisplayName: null == senderDisplayName
          ? _value.senderDisplayName
          : senderDisplayName // ignore: cast_nullable_to_non_nullable
              as String,
      createdOn: null == createdOn
          ? _value.createdOn
          : createdOn // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ChatMessageType?,
      deletedOn: freezed == deletedOn
          ? _value.deletedOn
          : deletedOn // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }

  /// Create a copy of ChatMessageDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CommunicationIdentifierCopyWith<$Res>? get sender {
    if (_value.sender == null) {
      return null;
    }

    return $CommunicationIdentifierCopyWith<$Res>(_value.sender!, (value) {
      return _then(_value.copyWith(sender: value) as $Val);
    });
  }

  /// Create a copy of ChatMessageDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CommunicationIdentifierCopyWith<$Res>? get recipient {
    if (_value.recipient == null) {
      return null;
    }

    return $CommunicationIdentifierCopyWith<$Res>(_value.recipient!, (value) {
      return _then(_value.copyWith(recipient: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChatMessageDeletedEventImplCopyWith<$Res>
    implements $ChatMessageDeletedEventCopyWith<$Res> {
  factory _$$ChatMessageDeletedEventImplCopyWith(
          _$ChatMessageDeletedEventImpl value,
          $Res Function(_$ChatMessageDeletedEventImpl) then) =
      __$$ChatMessageDeletedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String threadId,
      @JsonKey(name: 'sender', readValue: readValueObject)
      CommunicationIdentifier? sender,
      @JsonKey(name: 'recipient', readValue: readValueObject)
      CommunicationIdentifier? recipient,
      String id,
      String senderDisplayName,
      String createdOn,
      String version,
      ChatMessageType? type,
      String? deletedOn,
      Map<String, dynamic>? metadata});

  @override
  $CommunicationIdentifierCopyWith<$Res>? get sender;
  @override
  $CommunicationIdentifierCopyWith<$Res>? get recipient;
}

/// @nodoc
class __$$ChatMessageDeletedEventImplCopyWithImpl<$Res>
    extends _$ChatMessageDeletedEventCopyWithImpl<$Res,
        _$ChatMessageDeletedEventImpl>
    implements _$$ChatMessageDeletedEventImplCopyWith<$Res> {
  __$$ChatMessageDeletedEventImplCopyWithImpl(
      _$ChatMessageDeletedEventImpl _value,
      $Res Function(_$ChatMessageDeletedEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatMessageDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? threadId = null,
    Object? sender = freezed,
    Object? recipient = freezed,
    Object? id = null,
    Object? senderDisplayName = null,
    Object? createdOn = null,
    Object? version = null,
    Object? type = freezed,
    Object? deletedOn = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$ChatMessageDeletedEventImpl(
      threadId: null == threadId
          ? _value.threadId
          : threadId // ignore: cast_nullable_to_non_nullable
              as String,
      sender: freezed == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as CommunicationIdentifier?,
      recipient: freezed == recipient
          ? _value.recipient
          : recipient // ignore: cast_nullable_to_non_nullable
              as CommunicationIdentifier?,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      senderDisplayName: null == senderDisplayName
          ? _value.senderDisplayName
          : senderDisplayName // ignore: cast_nullable_to_non_nullable
              as String,
      createdOn: null == createdOn
          ? _value.createdOn
          : createdOn // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ChatMessageType?,
      deletedOn: freezed == deletedOn
          ? _value.deletedOn
          : deletedOn // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMessageDeletedEventImpl implements _ChatMessageDeletedEvent {
  const _$ChatMessageDeletedEventImpl(
      {required this.threadId,
      @JsonKey(name: 'sender', readValue: readValueObject) this.sender,
      @JsonKey(name: 'recipient', readValue: readValueObject) this.recipient,
      required this.id,
      required this.senderDisplayName,
      required this.createdOn,
      required this.version,
      this.type,
      this.deletedOn,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$ChatMessageDeletedEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageDeletedEventImplFromJson(json);

  @override
  final String threadId;
  @override
  @JsonKey(name: 'sender', readValue: readValueObject)
  final CommunicationIdentifier? sender;
  @override
  @JsonKey(name: 'recipient', readValue: readValueObject)
  final CommunicationIdentifier? recipient;
  @override
  final String id;
  @override
  final String senderDisplayName;
  @override
  final String createdOn;
  @override
  final String version;
  @override
  final ChatMessageType? type;
  @override
  final String? deletedOn;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ChatMessageDeletedEvent(threadId: $threadId, sender: $sender, recipient: $recipient, id: $id, senderDisplayName: $senderDisplayName, createdOn: $createdOn, version: $version, type: $type, deletedOn: $deletedOn, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageDeletedEventImpl &&
            (identical(other.threadId, threadId) ||
                other.threadId == threadId) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.recipient, recipient) ||
                other.recipient == recipient) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.senderDisplayName, senderDisplayName) ||
                other.senderDisplayName == senderDisplayName) &&
            (identical(other.createdOn, createdOn) ||
                other.createdOn == createdOn) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.deletedOn, deletedOn) ||
                other.deletedOn == deletedOn) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      threadId,
      sender,
      recipient,
      id,
      senderDisplayName,
      createdOn,
      version,
      type,
      deletedOn,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of ChatMessageDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageDeletedEventImplCopyWith<_$ChatMessageDeletedEventImpl>
      get copyWith => __$$ChatMessageDeletedEventImplCopyWithImpl<
          _$ChatMessageDeletedEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageDeletedEventImplToJson(
      this,
    );
  }
}

abstract class _ChatMessageDeletedEvent implements ChatMessageDeletedEvent {
  const factory _ChatMessageDeletedEvent(
      {required final String threadId,
      @JsonKey(name: 'sender', readValue: readValueObject)
      final CommunicationIdentifier? sender,
      @JsonKey(name: 'recipient', readValue: readValueObject)
      final CommunicationIdentifier? recipient,
      required final String id,
      required final String senderDisplayName,
      required final String createdOn,
      required final String version,
      final ChatMessageType? type,
      final String? deletedOn,
      final Map<String, dynamic>? metadata}) = _$ChatMessageDeletedEventImpl;

  factory _ChatMessageDeletedEvent.fromJson(Map<String, dynamic> json) =
      _$ChatMessageDeletedEventImpl.fromJson;

  @override
  String get threadId;
  @override
  @JsonKey(name: 'sender', readValue: readValueObject)
  CommunicationIdentifier? get sender;
  @override
  @JsonKey(name: 'recipient', readValue: readValueObject)
  CommunicationIdentifier? get recipient;
  @override
  String get id;
  @override
  String get senderDisplayName;
  @override
  String get createdOn;
  @override
  String get version;
  @override
  ChatMessageType? get type;
  @override
  String? get deletedOn;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of ChatMessageDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatMessageDeletedEventImplCopyWith<_$ChatMessageDeletedEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}
