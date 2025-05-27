// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'read_receipt_received_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReadReceiptReceivedEvent _$ReadReceiptReceivedEventFromJson(
    Map<String, dynamic> json) {
  return _ReadReceiptReceivedEvent.fromJson(json);
}

/// @nodoc
mixin _$ReadReceiptReceivedEvent {
  String get threadId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sender', readValue: readValueObject)
  CommunicationIdentifier? get sender => throw _privateConstructorUsedError;
  @JsonKey(name: 'recipient', readValue: readValueObject)
  CommunicationIdentifier? get recipient => throw _privateConstructorUsedError;
  String get chatMessageId => throw _privateConstructorUsedError;
  String? get readOn => throw _privateConstructorUsedError;

  /// Serializes this ReadReceiptReceivedEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReadReceiptReceivedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReadReceiptReceivedEventCopyWith<ReadReceiptReceivedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReadReceiptReceivedEventCopyWith<$Res> {
  factory $ReadReceiptReceivedEventCopyWith(ReadReceiptReceivedEvent value,
          $Res Function(ReadReceiptReceivedEvent) then) =
      _$ReadReceiptReceivedEventCopyWithImpl<$Res, ReadReceiptReceivedEvent>;
  @useResult
  $Res call(
      {String threadId,
      @JsonKey(name: 'sender', readValue: readValueObject)
      CommunicationIdentifier? sender,
      @JsonKey(name: 'recipient', readValue: readValueObject)
      CommunicationIdentifier? recipient,
      String chatMessageId,
      String? readOn});

  $CommunicationIdentifierCopyWith<$Res>? get sender;
  $CommunicationIdentifierCopyWith<$Res>? get recipient;
}

/// @nodoc
class _$ReadReceiptReceivedEventCopyWithImpl<$Res,
        $Val extends ReadReceiptReceivedEvent>
    implements $ReadReceiptReceivedEventCopyWith<$Res> {
  _$ReadReceiptReceivedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReadReceiptReceivedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? threadId = null,
    Object? sender = freezed,
    Object? recipient = freezed,
    Object? chatMessageId = null,
    Object? readOn = freezed,
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
      chatMessageId: null == chatMessageId
          ? _value.chatMessageId
          : chatMessageId // ignore: cast_nullable_to_non_nullable
              as String,
      readOn: freezed == readOn
          ? _value.readOn
          : readOn // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of ReadReceiptReceivedEvent
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

  /// Create a copy of ReadReceiptReceivedEvent
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
abstract class _$$ReadReceiptReceivedEventImplCopyWith<$Res>
    implements $ReadReceiptReceivedEventCopyWith<$Res> {
  factory _$$ReadReceiptReceivedEventImplCopyWith(
          _$ReadReceiptReceivedEventImpl value,
          $Res Function(_$ReadReceiptReceivedEventImpl) then) =
      __$$ReadReceiptReceivedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String threadId,
      @JsonKey(name: 'sender', readValue: readValueObject)
      CommunicationIdentifier? sender,
      @JsonKey(name: 'recipient', readValue: readValueObject)
      CommunicationIdentifier? recipient,
      String chatMessageId,
      String? readOn});

  @override
  $CommunicationIdentifierCopyWith<$Res>? get sender;
  @override
  $CommunicationIdentifierCopyWith<$Res>? get recipient;
}

/// @nodoc
class __$$ReadReceiptReceivedEventImplCopyWithImpl<$Res>
    extends _$ReadReceiptReceivedEventCopyWithImpl<$Res,
        _$ReadReceiptReceivedEventImpl>
    implements _$$ReadReceiptReceivedEventImplCopyWith<$Res> {
  __$$ReadReceiptReceivedEventImplCopyWithImpl(
      _$ReadReceiptReceivedEventImpl _value,
      $Res Function(_$ReadReceiptReceivedEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReadReceiptReceivedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? threadId = null,
    Object? sender = freezed,
    Object? recipient = freezed,
    Object? chatMessageId = null,
    Object? readOn = freezed,
  }) {
    return _then(_$ReadReceiptReceivedEventImpl(
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
      chatMessageId: null == chatMessageId
          ? _value.chatMessageId
          : chatMessageId // ignore: cast_nullable_to_non_nullable
              as String,
      readOn: freezed == readOn
          ? _value.readOn
          : readOn // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReadReceiptReceivedEventImpl implements _ReadReceiptReceivedEvent {
  const _$ReadReceiptReceivedEventImpl(
      {required this.threadId,
      @JsonKey(name: 'sender', readValue: readValueObject) this.sender,
      @JsonKey(name: 'recipient', readValue: readValueObject) this.recipient,
      required this.chatMessageId,
      this.readOn});

  factory _$ReadReceiptReceivedEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReadReceiptReceivedEventImplFromJson(json);

  @override
  final String threadId;
  @override
  @JsonKey(name: 'sender', readValue: readValueObject)
  final CommunicationIdentifier? sender;
  @override
  @JsonKey(name: 'recipient', readValue: readValueObject)
  final CommunicationIdentifier? recipient;
  @override
  final String chatMessageId;
  @override
  final String? readOn;

  @override
  String toString() {
    return 'ReadReceiptReceivedEvent(threadId: $threadId, sender: $sender, recipient: $recipient, chatMessageId: $chatMessageId, readOn: $readOn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReadReceiptReceivedEventImpl &&
            (identical(other.threadId, threadId) ||
                other.threadId == threadId) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.recipient, recipient) ||
                other.recipient == recipient) &&
            (identical(other.chatMessageId, chatMessageId) ||
                other.chatMessageId == chatMessageId) &&
            (identical(other.readOn, readOn) || other.readOn == readOn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, threadId, sender, recipient, chatMessageId, readOn);

  /// Create a copy of ReadReceiptReceivedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReadReceiptReceivedEventImplCopyWith<_$ReadReceiptReceivedEventImpl>
      get copyWith => __$$ReadReceiptReceivedEventImplCopyWithImpl<
          _$ReadReceiptReceivedEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReadReceiptReceivedEventImplToJson(
      this,
    );
  }
}

abstract class _ReadReceiptReceivedEvent implements ReadReceiptReceivedEvent {
  const factory _ReadReceiptReceivedEvent(
      {required final String threadId,
      @JsonKey(name: 'sender', readValue: readValueObject)
      final CommunicationIdentifier? sender,
      @JsonKey(name: 'recipient', readValue: readValueObject)
      final CommunicationIdentifier? recipient,
      required final String chatMessageId,
      final String? readOn}) = _$ReadReceiptReceivedEventImpl;

  factory _ReadReceiptReceivedEvent.fromJson(Map<String, dynamic> json) =
      _$ReadReceiptReceivedEventImpl.fromJson;

  @override
  String get threadId;
  @override
  @JsonKey(name: 'sender', readValue: readValueObject)
  CommunicationIdentifier? get sender;
  @override
  @JsonKey(name: 'recipient', readValue: readValueObject)
  CommunicationIdentifier? get recipient;
  @override
  String get chatMessageId;
  @override
  String? get readOn;

  /// Create a copy of ReadReceiptReceivedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReadReceiptReceivedEventImplCopyWith<_$ReadReceiptReceivedEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}
