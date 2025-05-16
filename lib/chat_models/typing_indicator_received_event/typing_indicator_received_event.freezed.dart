// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'typing_indicator_received_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TypingIndicatorReceivedEvent _$TypingIndicatorReceivedEventFromJson(
    Map<String, dynamic> json) {
  return _TypingIndicatorReceivedEvent.fromJson(json);
}

/// @nodoc
mixin _$TypingIndicatorReceivedEvent {
  String get threadId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sender', readValue: readValueObject)
  CommunicationIdentifier? get sender => throw _privateConstructorUsedError;
  @JsonKey(name: 'recipient', readValue: readValueObject)
  CommunicationIdentifier? get recipient => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  String? get receivedOn => throw _privateConstructorUsedError;
  String? get senderDisplayName => throw _privateConstructorUsedError;

  /// Serializes this TypingIndicatorReceivedEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TypingIndicatorReceivedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TypingIndicatorReceivedEventCopyWith<TypingIndicatorReceivedEvent>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TypingIndicatorReceivedEventCopyWith<$Res> {
  factory $TypingIndicatorReceivedEventCopyWith(
          TypingIndicatorReceivedEvent value,
          $Res Function(TypingIndicatorReceivedEvent) then) =
      _$TypingIndicatorReceivedEventCopyWithImpl<$Res,
          TypingIndicatorReceivedEvent>;
  @useResult
  $Res call(
      {String threadId,
      @JsonKey(name: 'sender', readValue: readValueObject)
      CommunicationIdentifier? sender,
      @JsonKey(name: 'recipient', readValue: readValueObject)
      CommunicationIdentifier? recipient,
      String version,
      String? receivedOn,
      String? senderDisplayName});

  $CommunicationIdentifierCopyWith<$Res>? get sender;
  $CommunicationIdentifierCopyWith<$Res>? get recipient;
}

/// @nodoc
class _$TypingIndicatorReceivedEventCopyWithImpl<$Res,
        $Val extends TypingIndicatorReceivedEvent>
    implements $TypingIndicatorReceivedEventCopyWith<$Res> {
  _$TypingIndicatorReceivedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TypingIndicatorReceivedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? threadId = null,
    Object? sender = freezed,
    Object? recipient = freezed,
    Object? version = null,
    Object? receivedOn = freezed,
    Object? senderDisplayName = freezed,
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
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      receivedOn: freezed == receivedOn
          ? _value.receivedOn
          : receivedOn // ignore: cast_nullable_to_non_nullable
              as String?,
      senderDisplayName: freezed == senderDisplayName
          ? _value.senderDisplayName
          : senderDisplayName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of TypingIndicatorReceivedEvent
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

  /// Create a copy of TypingIndicatorReceivedEvent
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
abstract class _$$TypingIndicatorReceivedEventImplCopyWith<$Res>
    implements $TypingIndicatorReceivedEventCopyWith<$Res> {
  factory _$$TypingIndicatorReceivedEventImplCopyWith(
          _$TypingIndicatorReceivedEventImpl value,
          $Res Function(_$TypingIndicatorReceivedEventImpl) then) =
      __$$TypingIndicatorReceivedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String threadId,
      @JsonKey(name: 'sender', readValue: readValueObject)
      CommunicationIdentifier? sender,
      @JsonKey(name: 'recipient', readValue: readValueObject)
      CommunicationIdentifier? recipient,
      String version,
      String? receivedOn,
      String? senderDisplayName});

  @override
  $CommunicationIdentifierCopyWith<$Res>? get sender;
  @override
  $CommunicationIdentifierCopyWith<$Res>? get recipient;
}

/// @nodoc
class __$$TypingIndicatorReceivedEventImplCopyWithImpl<$Res>
    extends _$TypingIndicatorReceivedEventCopyWithImpl<$Res,
        _$TypingIndicatorReceivedEventImpl>
    implements _$$TypingIndicatorReceivedEventImplCopyWith<$Res> {
  __$$TypingIndicatorReceivedEventImplCopyWithImpl(
      _$TypingIndicatorReceivedEventImpl _value,
      $Res Function(_$TypingIndicatorReceivedEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of TypingIndicatorReceivedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? threadId = null,
    Object? sender = freezed,
    Object? recipient = freezed,
    Object? version = null,
    Object? receivedOn = freezed,
    Object? senderDisplayName = freezed,
  }) {
    return _then(_$TypingIndicatorReceivedEventImpl(
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
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      receivedOn: freezed == receivedOn
          ? _value.receivedOn
          : receivedOn // ignore: cast_nullable_to_non_nullable
              as String?,
      senderDisplayName: freezed == senderDisplayName
          ? _value.senderDisplayName
          : senderDisplayName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TypingIndicatorReceivedEventImpl
    implements _TypingIndicatorReceivedEvent {
  const _$TypingIndicatorReceivedEventImpl(
      {required this.threadId,
      @JsonKey(name: 'sender', readValue: readValueObject) this.sender,
      @JsonKey(name: 'recipient', readValue: readValueObject) this.recipient,
      required this.version,
      this.receivedOn,
      this.senderDisplayName});

  factory _$TypingIndicatorReceivedEventImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$TypingIndicatorReceivedEventImplFromJson(json);

  @override
  final String threadId;
  @override
  @JsonKey(name: 'sender', readValue: readValueObject)
  final CommunicationIdentifier? sender;
  @override
  @JsonKey(name: 'recipient', readValue: readValueObject)
  final CommunicationIdentifier? recipient;
  @override
  final String version;
  @override
  final String? receivedOn;
  @override
  final String? senderDisplayName;

  @override
  String toString() {
    return 'TypingIndicatorReceivedEvent(threadId: $threadId, sender: $sender, recipient: $recipient, version: $version, receivedOn: $receivedOn, senderDisplayName: $senderDisplayName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TypingIndicatorReceivedEventImpl &&
            (identical(other.threadId, threadId) ||
                other.threadId == threadId) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.recipient, recipient) ||
                other.recipient == recipient) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.receivedOn, receivedOn) ||
                other.receivedOn == receivedOn) &&
            (identical(other.senderDisplayName, senderDisplayName) ||
                other.senderDisplayName == senderDisplayName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, threadId, sender, recipient,
      version, receivedOn, senderDisplayName);

  /// Create a copy of TypingIndicatorReceivedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TypingIndicatorReceivedEventImplCopyWith<
          _$TypingIndicatorReceivedEventImpl>
      get copyWith => __$$TypingIndicatorReceivedEventImplCopyWithImpl<
          _$TypingIndicatorReceivedEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TypingIndicatorReceivedEventImplToJson(
      this,
    );
  }
}

abstract class _TypingIndicatorReceivedEvent
    implements TypingIndicatorReceivedEvent {
  const factory _TypingIndicatorReceivedEvent(
      {required final String threadId,
      @JsonKey(name: 'sender', readValue: readValueObject)
      final CommunicationIdentifier? sender,
      @JsonKey(name: 'recipient', readValue: readValueObject)
      final CommunicationIdentifier? recipient,
      required final String version,
      final String? receivedOn,
      final String? senderDisplayName}) = _$TypingIndicatorReceivedEventImpl;

  factory _TypingIndicatorReceivedEvent.fromJson(Map<String, dynamic> json) =
      _$TypingIndicatorReceivedEventImpl.fromJson;

  @override
  String get threadId;
  @override
  @JsonKey(name: 'sender', readValue: readValueObject)
  CommunicationIdentifier? get sender;
  @override
  @JsonKey(name: 'recipient', readValue: readValueObject)
  CommunicationIdentifier? get recipient;
  @override
  String get version;
  @override
  String? get receivedOn;
  @override
  String? get senderDisplayName;

  /// Create a copy of TypingIndicatorReceivedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TypingIndicatorReceivedEventImplCopyWith<
          _$TypingIndicatorReceivedEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}
