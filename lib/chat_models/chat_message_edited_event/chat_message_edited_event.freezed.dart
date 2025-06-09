// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message_edited_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatMessageEditedEvent _$ChatMessageEditedEventFromJson(
    Map<String, dynamic> json) {
  return _ChatMessageEditedEvent.fromJson(json);
}

/// @nodoc
mixin _$ChatMessageEditedEvent {
  String get threadId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sender', readValue: readValueObject)
  CommunicationIdentifier? get sender => throw _privateConstructorUsedError;
  @JsonKey(name: 'recipient', readValue: readValueObject)
  CommunicationIdentifier? get recipient => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  String get senderDisplayName => throw _privateConstructorUsedError;
  String get createdOn => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  ChatMessageType? get type => throw _privateConstructorUsedError;
  String? get editedOn => throw _privateConstructorUsedError;
  @JsonKey(name: 'metadata', readValue: readValueObject)
  ChatMessageMetadata? get metadata => throw _privateConstructorUsedError;

  /// Serializes this ChatMessageEditedEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatMessageEditedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatMessageEditedEventCopyWith<ChatMessageEditedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageEditedEventCopyWith<$Res> {
  factory $ChatMessageEditedEventCopyWith(ChatMessageEditedEvent value,
          $Res Function(ChatMessageEditedEvent) then) =
      _$ChatMessageEditedEventCopyWithImpl<$Res, ChatMessageEditedEvent>;
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
      String message,
      ChatMessageType? type,
      String? editedOn,
      @JsonKey(name: 'metadata', readValue: readValueObject)
      ChatMessageMetadata? metadata});

  $CommunicationIdentifierCopyWith<$Res>? get sender;
  $CommunicationIdentifierCopyWith<$Res>? get recipient;
  $ChatMessageMetadataCopyWith<$Res>? get metadata;
}

/// @nodoc
class _$ChatMessageEditedEventCopyWithImpl<$Res,
        $Val extends ChatMessageEditedEvent>
    implements $ChatMessageEditedEventCopyWith<$Res> {
  _$ChatMessageEditedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatMessageEditedEvent
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
    Object? message = null,
    Object? type = freezed,
    Object? editedOn = freezed,
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
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ChatMessageType?,
      editedOn: freezed == editedOn
          ? _value.editedOn
          : editedOn // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as ChatMessageMetadata?,
    ) as $Val);
  }

  /// Create a copy of ChatMessageEditedEvent
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

  /// Create a copy of ChatMessageEditedEvent
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

  /// Create a copy of ChatMessageEditedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatMessageMetadataCopyWith<$Res>? get metadata {
    if (_value.metadata == null) {
      return null;
    }

    return $ChatMessageMetadataCopyWith<$Res>(_value.metadata!, (value) {
      return _then(_value.copyWith(metadata: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChatMessageEditedEventImplCopyWith<$Res>
    implements $ChatMessageEditedEventCopyWith<$Res> {
  factory _$$ChatMessageEditedEventImplCopyWith(
          _$ChatMessageEditedEventImpl value,
          $Res Function(_$ChatMessageEditedEventImpl) then) =
      __$$ChatMessageEditedEventImplCopyWithImpl<$Res>;
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
      String message,
      ChatMessageType? type,
      String? editedOn,
      @JsonKey(name: 'metadata', readValue: readValueObject)
      ChatMessageMetadata? metadata});

  @override
  $CommunicationIdentifierCopyWith<$Res>? get sender;
  @override
  $CommunicationIdentifierCopyWith<$Res>? get recipient;
  @override
  $ChatMessageMetadataCopyWith<$Res>? get metadata;
}

/// @nodoc
class __$$ChatMessageEditedEventImplCopyWithImpl<$Res>
    extends _$ChatMessageEditedEventCopyWithImpl<$Res,
        _$ChatMessageEditedEventImpl>
    implements _$$ChatMessageEditedEventImplCopyWith<$Res> {
  __$$ChatMessageEditedEventImplCopyWithImpl(
      _$ChatMessageEditedEventImpl _value,
      $Res Function(_$ChatMessageEditedEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatMessageEditedEvent
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
    Object? message = null,
    Object? type = freezed,
    Object? editedOn = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$ChatMessageEditedEventImpl(
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
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ChatMessageType?,
      editedOn: freezed == editedOn
          ? _value.editedOn
          : editedOn // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as ChatMessageMetadata?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMessageEditedEventImpl implements _ChatMessageEditedEvent {
  const _$ChatMessageEditedEventImpl(
      {required this.threadId,
      @JsonKey(name: 'sender', readValue: readValueObject) this.sender,
      @JsonKey(name: 'recipient', readValue: readValueObject) this.recipient,
      required this.id,
      required this.senderDisplayName,
      required this.createdOn,
      required this.version,
      required this.message,
      this.type,
      this.editedOn,
      @JsonKey(name: 'metadata', readValue: readValueObject) this.metadata});

  factory _$ChatMessageEditedEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageEditedEventImplFromJson(json);

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
  final String message;
  @override
  final ChatMessageType? type;
  @override
  final String? editedOn;
  @override
  @JsonKey(name: 'metadata', readValue: readValueObject)
  final ChatMessageMetadata? metadata;

  @override
  String toString() {
    return 'ChatMessageEditedEvent(threadId: $threadId, sender: $sender, recipient: $recipient, id: $id, senderDisplayName: $senderDisplayName, createdOn: $createdOn, version: $version, message: $message, type: $type, editedOn: $editedOn, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageEditedEventImpl &&
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
            (identical(other.message, message) || other.message == message) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.editedOn, editedOn) ||
                other.editedOn == editedOn) &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, threadId, sender, recipient, id,
      senderDisplayName, createdOn, version, message, type, editedOn, metadata);

  /// Create a copy of ChatMessageEditedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageEditedEventImplCopyWith<_$ChatMessageEditedEventImpl>
      get copyWith => __$$ChatMessageEditedEventImplCopyWithImpl<
          _$ChatMessageEditedEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageEditedEventImplToJson(
      this,
    );
  }
}

abstract class _ChatMessageEditedEvent implements ChatMessageEditedEvent {
  const factory _ChatMessageEditedEvent(
      {required final String threadId,
      @JsonKey(name: 'sender', readValue: readValueObject)
      final CommunicationIdentifier? sender,
      @JsonKey(name: 'recipient', readValue: readValueObject)
      final CommunicationIdentifier? recipient,
      required final String id,
      required final String senderDisplayName,
      required final String createdOn,
      required final String version,
      required final String message,
      final ChatMessageType? type,
      final String? editedOn,
      @JsonKey(name: 'metadata', readValue: readValueObject)
      final ChatMessageMetadata? metadata}) = _$ChatMessageEditedEventImpl;

  factory _ChatMessageEditedEvent.fromJson(Map<String, dynamic> json) =
      _$ChatMessageEditedEventImpl.fromJson;

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
  String get message;
  @override
  ChatMessageType? get type;
  @override
  String? get editedOn;
  @override
  @JsonKey(name: 'metadata', readValue: readValueObject)
  ChatMessageMetadata? get metadata;

  /// Create a copy of ChatMessageEditedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatMessageEditedEventImplCopyWith<_$ChatMessageEditedEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}
