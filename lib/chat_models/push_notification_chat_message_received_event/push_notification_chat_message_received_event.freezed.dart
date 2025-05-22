// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'push_notification_chat_message_received_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PushNotificationChatMessageReceivedEvent
    _$PushNotificationChatMessageReceivedEventFromJson(
        Map<String, dynamic> json) {
  return _PushNotificationChatMessageReceivedEvent.fromJson(json);
}

/// @nodoc
mixin _$PushNotificationChatMessageReceivedEvent {
  String get messageId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get threadId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sender', readValue: readValueObject)
  CommunicationIdentifier? get sender => throw _privateConstructorUsedError;
  @JsonKey(name: 'recipient', readValue: readValueObject)
  CommunicationIdentifier? get recipient => throw _privateConstructorUsedError;
  String? get senderDisplayName => throw _privateConstructorUsedError;
  String? get originalArrivalTime => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'metadata', readValue: readValueObject)
  ChatMessageMetadata? get metadata => throw _privateConstructorUsedError;

  /// Serializes this PushNotificationChatMessageReceivedEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PushNotificationChatMessageReceivedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PushNotificationChatMessageReceivedEventCopyWith<
          PushNotificationChatMessageReceivedEvent>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PushNotificationChatMessageReceivedEventCopyWith<$Res> {
  factory $PushNotificationChatMessageReceivedEventCopyWith(
          PushNotificationChatMessageReceivedEvent value,
          $Res Function(PushNotificationChatMessageReceivedEvent) then) =
      _$PushNotificationChatMessageReceivedEventCopyWithImpl<$Res,
          PushNotificationChatMessageReceivedEvent>;
  @useResult
  $Res call(
      {String messageId,
      String type,
      String threadId,
      @JsonKey(name: 'sender', readValue: readValueObject)
      CommunicationIdentifier? sender,
      @JsonKey(name: 'recipient', readValue: readValueObject)
      CommunicationIdentifier? recipient,
      String? senderDisplayName,
      String? originalArrivalTime,
      String version,
      String message,
      @JsonKey(name: 'metadata', readValue: readValueObject)
      ChatMessageMetadata? metadata});

  $CommunicationIdentifierCopyWith<$Res>? get sender;
  $CommunicationIdentifierCopyWith<$Res>? get recipient;
  $ChatMessageMetadataCopyWith<$Res>? get metadata;
}

/// @nodoc
class _$PushNotificationChatMessageReceivedEventCopyWithImpl<$Res,
        $Val extends PushNotificationChatMessageReceivedEvent>
    implements $PushNotificationChatMessageReceivedEventCopyWith<$Res> {
  _$PushNotificationChatMessageReceivedEventCopyWithImpl(
      this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PushNotificationChatMessageReceivedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messageId = null,
    Object? type = null,
    Object? threadId = null,
    Object? sender = freezed,
    Object? recipient = freezed,
    Object? senderDisplayName = freezed,
    Object? originalArrivalTime = freezed,
    Object? version = null,
    Object? message = null,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      messageId: null == messageId
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
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
      senderDisplayName: freezed == senderDisplayName
          ? _value.senderDisplayName
          : senderDisplayName // ignore: cast_nullable_to_non_nullable
              as String?,
      originalArrivalTime: freezed == originalArrivalTime
          ? _value.originalArrivalTime
          : originalArrivalTime // ignore: cast_nullable_to_non_nullable
              as String?,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as ChatMessageMetadata?,
    ) as $Val);
  }

  /// Create a copy of PushNotificationChatMessageReceivedEvent
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

  /// Create a copy of PushNotificationChatMessageReceivedEvent
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

  /// Create a copy of PushNotificationChatMessageReceivedEvent
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
abstract class _$$PushNotificationChatMessageReceivedEventImplCopyWith<$Res>
    implements $PushNotificationChatMessageReceivedEventCopyWith<$Res> {
  factory _$$PushNotificationChatMessageReceivedEventImplCopyWith(
          _$PushNotificationChatMessageReceivedEventImpl value,
          $Res Function(_$PushNotificationChatMessageReceivedEventImpl) then) =
      __$$PushNotificationChatMessageReceivedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String messageId,
      String type,
      String threadId,
      @JsonKey(name: 'sender', readValue: readValueObject)
      CommunicationIdentifier? sender,
      @JsonKey(name: 'recipient', readValue: readValueObject)
      CommunicationIdentifier? recipient,
      String? senderDisplayName,
      String? originalArrivalTime,
      String version,
      String message,
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
class __$$PushNotificationChatMessageReceivedEventImplCopyWithImpl<$Res>
    extends _$PushNotificationChatMessageReceivedEventCopyWithImpl<$Res,
        _$PushNotificationChatMessageReceivedEventImpl>
    implements _$$PushNotificationChatMessageReceivedEventImplCopyWith<$Res> {
  __$$PushNotificationChatMessageReceivedEventImplCopyWithImpl(
      _$PushNotificationChatMessageReceivedEventImpl _value,
      $Res Function(_$PushNotificationChatMessageReceivedEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of PushNotificationChatMessageReceivedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messageId = null,
    Object? type = null,
    Object? threadId = null,
    Object? sender = freezed,
    Object? recipient = freezed,
    Object? senderDisplayName = freezed,
    Object? originalArrivalTime = freezed,
    Object? version = null,
    Object? message = null,
    Object? metadata = freezed,
  }) {
    return _then(_$PushNotificationChatMessageReceivedEventImpl(
      messageId: null == messageId
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
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
      senderDisplayName: freezed == senderDisplayName
          ? _value.senderDisplayName
          : senderDisplayName // ignore: cast_nullable_to_non_nullable
              as String?,
      originalArrivalTime: freezed == originalArrivalTime
          ? _value.originalArrivalTime
          : originalArrivalTime // ignore: cast_nullable_to_non_nullable
              as String?,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as ChatMessageMetadata?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PushNotificationChatMessageReceivedEventImpl
    implements _PushNotificationChatMessageReceivedEvent {
  const _$PushNotificationChatMessageReceivedEventImpl(
      {required this.messageId,
      required this.type,
      required this.threadId,
      @JsonKey(name: 'sender', readValue: readValueObject) this.sender,
      @JsonKey(name: 'recipient', readValue: readValueObject) this.recipient,
      this.senderDisplayName,
      this.originalArrivalTime,
      required this.version,
      required this.message,
      @JsonKey(name: 'metadata', readValue: readValueObject) this.metadata});

  factory _$PushNotificationChatMessageReceivedEventImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$PushNotificationChatMessageReceivedEventImplFromJson(json);

  @override
  final String messageId;
  @override
  final String type;
  @override
  final String threadId;
  @override
  @JsonKey(name: 'sender', readValue: readValueObject)
  final CommunicationIdentifier? sender;
  @override
  @JsonKey(name: 'recipient', readValue: readValueObject)
  final CommunicationIdentifier? recipient;
  @override
  final String? senderDisplayName;
  @override
  final String? originalArrivalTime;
  @override
  final String version;
  @override
  final String message;
  @override
  @JsonKey(name: 'metadata', readValue: readValueObject)
  final ChatMessageMetadata? metadata;

  @override
  String toString() {
    return 'PushNotificationChatMessageReceivedEvent(messageId: $messageId, type: $type, threadId: $threadId, sender: $sender, recipient: $recipient, senderDisplayName: $senderDisplayName, originalArrivalTime: $originalArrivalTime, version: $version, message: $message, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PushNotificationChatMessageReceivedEventImpl &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.threadId, threadId) ||
                other.threadId == threadId) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.recipient, recipient) ||
                other.recipient == recipient) &&
            (identical(other.senderDisplayName, senderDisplayName) ||
                other.senderDisplayName == senderDisplayName) &&
            (identical(other.originalArrivalTime, originalArrivalTime) ||
                other.originalArrivalTime == originalArrivalTime) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      messageId,
      type,
      threadId,
      sender,
      recipient,
      senderDisplayName,
      originalArrivalTime,
      version,
      message,
      metadata);

  /// Create a copy of PushNotificationChatMessageReceivedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PushNotificationChatMessageReceivedEventImplCopyWith<
          _$PushNotificationChatMessageReceivedEventImpl>
      get copyWith =>
          __$$PushNotificationChatMessageReceivedEventImplCopyWithImpl<
              _$PushNotificationChatMessageReceivedEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PushNotificationChatMessageReceivedEventImplToJson(
      this,
    );
  }
}

abstract class _PushNotificationChatMessageReceivedEvent
    implements PushNotificationChatMessageReceivedEvent {
  const factory _PushNotificationChatMessageReceivedEvent(
          {required final String messageId,
          required final String type,
          required final String threadId,
          @JsonKey(name: 'sender', readValue: readValueObject)
          final CommunicationIdentifier? sender,
          @JsonKey(name: 'recipient', readValue: readValueObject)
          final CommunicationIdentifier? recipient,
          final String? senderDisplayName,
          final String? originalArrivalTime,
          required final String version,
          required final String message,
          @JsonKey(name: 'metadata', readValue: readValueObject)
          final ChatMessageMetadata? metadata}) =
      _$PushNotificationChatMessageReceivedEventImpl;

  factory _PushNotificationChatMessageReceivedEvent.fromJson(
          Map<String, dynamic> json) =
      _$PushNotificationChatMessageReceivedEventImpl.fromJson;

  @override
  String get messageId;
  @override
  String get type;
  @override
  String get threadId;
  @override
  @JsonKey(name: 'sender', readValue: readValueObject)
  CommunicationIdentifier? get sender;
  @override
  @JsonKey(name: 'recipient', readValue: readValueObject)
  CommunicationIdentifier? get recipient;
  @override
  String? get senderDisplayName;
  @override
  String? get originalArrivalTime;
  @override
  String get version;
  @override
  String get message;
  @override
  @JsonKey(name: 'metadata', readValue: readValueObject)
  ChatMessageMetadata? get metadata;

  /// Create a copy of PushNotificationChatMessageReceivedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PushNotificationChatMessageReceivedEventImplCopyWith<
          _$PushNotificationChatMessageReceivedEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}
