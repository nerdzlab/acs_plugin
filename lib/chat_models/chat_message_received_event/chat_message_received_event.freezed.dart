// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message_received_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatMessageReceivedEvent _$ChatMessageReceivedEventFromJson(
    Map<String, dynamic> json) {
  return _ChatMessageReceivedEvent.fromJson(json);
}

/// @nodoc
mixin _$ChatMessageReceivedEvent {
  String get threadId => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  @JsonKey(name: 'sender', readValue: readValueObject)
  CommunicationIdentifier? get sender => throw _privateConstructorUsedError;
  @JsonKey(name: 'recipient', readValue: readValueObject)
  CommunicationIdentifier? get recipient => throw _privateConstructorUsedError;
  String? get senderDisplayName => throw _privateConstructorUsedError;
  String? get createdOn => throw _privateConstructorUsedError;
  ChatMessageType get type => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this ChatMessageReceivedEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatMessageReceivedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatMessageReceivedEventCopyWith<ChatMessageReceivedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageReceivedEventCopyWith<$Res> {
  factory $ChatMessageReceivedEventCopyWith(ChatMessageReceivedEvent value,
          $Res Function(ChatMessageReceivedEvent) then) =
      _$ChatMessageReceivedEventCopyWithImpl<$Res, ChatMessageReceivedEvent>;
  @useResult
  $Res call(
      {String threadId,
      String id,
      String message,
      String version,
      @JsonKey(name: 'sender', readValue: readValueObject)
      CommunicationIdentifier? sender,
      @JsonKey(name: 'recipient', readValue: readValueObject)
      CommunicationIdentifier? recipient,
      String? senderDisplayName,
      String? createdOn,
      ChatMessageType type,
      Map<String, dynamic>? metadata});

  $CommunicationIdentifierCopyWith<$Res>? get sender;
  $CommunicationIdentifierCopyWith<$Res>? get recipient;
}

/// @nodoc
class _$ChatMessageReceivedEventCopyWithImpl<$Res,
        $Val extends ChatMessageReceivedEvent>
    implements $ChatMessageReceivedEventCopyWith<$Res> {
  _$ChatMessageReceivedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatMessageReceivedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? threadId = null,
    Object? id = null,
    Object? message = null,
    Object? version = null,
    Object? sender = freezed,
    Object? recipient = freezed,
    Object? senderDisplayName = freezed,
    Object? createdOn = freezed,
    Object? type = null,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      threadId: null == threadId
          ? _value.threadId
          : threadId // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
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
      createdOn: freezed == createdOn
          ? _value.createdOn
          : createdOn // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ChatMessageType,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }

  /// Create a copy of ChatMessageReceivedEvent
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

  /// Create a copy of ChatMessageReceivedEvent
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
abstract class _$$ChatMessageReceivedEventImplCopyWith<$Res>
    implements $ChatMessageReceivedEventCopyWith<$Res> {
  factory _$$ChatMessageReceivedEventImplCopyWith(
          _$ChatMessageReceivedEventImpl value,
          $Res Function(_$ChatMessageReceivedEventImpl) then) =
      __$$ChatMessageReceivedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String threadId,
      String id,
      String message,
      String version,
      @JsonKey(name: 'sender', readValue: readValueObject)
      CommunicationIdentifier? sender,
      @JsonKey(name: 'recipient', readValue: readValueObject)
      CommunicationIdentifier? recipient,
      String? senderDisplayName,
      String? createdOn,
      ChatMessageType type,
      Map<String, dynamic>? metadata});

  @override
  $CommunicationIdentifierCopyWith<$Res>? get sender;
  @override
  $CommunicationIdentifierCopyWith<$Res>? get recipient;
}

/// @nodoc
class __$$ChatMessageReceivedEventImplCopyWithImpl<$Res>
    extends _$ChatMessageReceivedEventCopyWithImpl<$Res,
        _$ChatMessageReceivedEventImpl>
    implements _$$ChatMessageReceivedEventImplCopyWith<$Res> {
  __$$ChatMessageReceivedEventImplCopyWithImpl(
      _$ChatMessageReceivedEventImpl _value,
      $Res Function(_$ChatMessageReceivedEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatMessageReceivedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? threadId = null,
    Object? id = null,
    Object? message = null,
    Object? version = null,
    Object? sender = freezed,
    Object? recipient = freezed,
    Object? senderDisplayName = freezed,
    Object? createdOn = freezed,
    Object? type = null,
    Object? metadata = freezed,
  }) {
    return _then(_$ChatMessageReceivedEventImpl(
      threadId: null == threadId
          ? _value.threadId
          : threadId // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
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
      createdOn: freezed == createdOn
          ? _value.createdOn
          : createdOn // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ChatMessageType,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMessageReceivedEventImpl implements _ChatMessageReceivedEvent {
  const _$ChatMessageReceivedEventImpl(
      {required this.threadId,
      required this.id,
      required this.message,
      required this.version,
      @JsonKey(name: 'sender', readValue: readValueObject) this.sender,
      @JsonKey(name: 'recipient', readValue: readValueObject) this.recipient,
      this.senderDisplayName,
      this.createdOn,
      required this.type,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$ChatMessageReceivedEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageReceivedEventImplFromJson(json);

  @override
  final String threadId;
  @override
  final String id;
  @override
  final String message;
  @override
  final String version;
  @override
  @JsonKey(name: 'sender', readValue: readValueObject)
  final CommunicationIdentifier? sender;
  @override
  @JsonKey(name: 'recipient', readValue: readValueObject)
  final CommunicationIdentifier? recipient;
  @override
  final String? senderDisplayName;
  @override
  final String? createdOn;
  @override
  final ChatMessageType type;
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
    return 'ChatMessageReceivedEvent(threadId: $threadId, id: $id, message: $message, version: $version, sender: $sender, recipient: $recipient, senderDisplayName: $senderDisplayName, createdOn: $createdOn, type: $type, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageReceivedEventImpl &&
            (identical(other.threadId, threadId) ||
                other.threadId == threadId) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.recipient, recipient) ||
                other.recipient == recipient) &&
            (identical(other.senderDisplayName, senderDisplayName) ||
                other.senderDisplayName == senderDisplayName) &&
            (identical(other.createdOn, createdOn) ||
                other.createdOn == createdOn) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      threadId,
      id,
      message,
      version,
      sender,
      recipient,
      senderDisplayName,
      createdOn,
      type,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of ChatMessageReceivedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageReceivedEventImplCopyWith<_$ChatMessageReceivedEventImpl>
      get copyWith => __$$ChatMessageReceivedEventImplCopyWithImpl<
          _$ChatMessageReceivedEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageReceivedEventImplToJson(
      this,
    );
  }
}

abstract class _ChatMessageReceivedEvent implements ChatMessageReceivedEvent {
  const factory _ChatMessageReceivedEvent(
      {required final String threadId,
      required final String id,
      required final String message,
      required final String version,
      @JsonKey(name: 'sender', readValue: readValueObject)
      final CommunicationIdentifier? sender,
      @JsonKey(name: 'recipient', readValue: readValueObject)
      final CommunicationIdentifier? recipient,
      final String? senderDisplayName,
      final String? createdOn,
      required final ChatMessageType type,
      final Map<String, dynamic>? metadata}) = _$ChatMessageReceivedEventImpl;

  factory _ChatMessageReceivedEvent.fromJson(Map<String, dynamic> json) =
      _$ChatMessageReceivedEventImpl.fromJson;

  @override
  String get threadId;
  @override
  String get id;
  @override
  String get message;
  @override
  String get version;
  @override
  @JsonKey(name: 'sender', readValue: readValueObject)
  CommunicationIdentifier? get sender;
  @override
  @JsonKey(name: 'recipient', readValue: readValueObject)
  CommunicationIdentifier? get recipient;
  @override
  String? get senderDisplayName;
  @override
  String? get createdOn;
  @override
  ChatMessageType get type;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of ChatMessageReceivedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatMessageReceivedEventImplCopyWith<_$ChatMessageReceivedEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}
