// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message_content.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatMessageContent _$ChatMessageContentFromJson(Map<String, dynamic> json) {
  return _ChatMessageContent.fromJson(json);
}

/// @nodoc
mixin _$ChatMessageContent {
  String? get message => throw _privateConstructorUsedError;
  String? get topic => throw _privateConstructorUsedError;
  @JsonKey(name: 'participants', readValue: readValueListObjects)
  List<ChatParticipant>? get participants => throw _privateConstructorUsedError;
  @JsonKey(name: 'initiator', readValue: readValueObject)
  CommunicationIdentifier? get initiator => throw _privateConstructorUsedError;

  /// Serializes this ChatMessageContent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatMessageContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatMessageContentCopyWith<ChatMessageContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageContentCopyWith<$Res> {
  factory $ChatMessageContentCopyWith(
          ChatMessageContent value, $Res Function(ChatMessageContent) then) =
      _$ChatMessageContentCopyWithImpl<$Res, ChatMessageContent>;
  @useResult
  $Res call(
      {String? message,
      String? topic,
      @JsonKey(name: 'participants', readValue: readValueListObjects)
      List<ChatParticipant>? participants,
      @JsonKey(name: 'initiator', readValue: readValueObject)
      CommunicationIdentifier? initiator});

  $CommunicationIdentifierCopyWith<$Res>? get initiator;
}

/// @nodoc
class _$ChatMessageContentCopyWithImpl<$Res, $Val extends ChatMessageContent>
    implements $ChatMessageContentCopyWith<$Res> {
  _$ChatMessageContentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatMessageContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
    Object? topic = freezed,
    Object? participants = freezed,
    Object? initiator = freezed,
  }) {
    return _then(_value.copyWith(
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      topic: freezed == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String?,
      participants: freezed == participants
          ? _value.participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<ChatParticipant>?,
      initiator: freezed == initiator
          ? _value.initiator
          : initiator // ignore: cast_nullable_to_non_nullable
              as CommunicationIdentifier?,
    ) as $Val);
  }

  /// Create a copy of ChatMessageContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CommunicationIdentifierCopyWith<$Res>? get initiator {
    if (_value.initiator == null) {
      return null;
    }

    return $CommunicationIdentifierCopyWith<$Res>(_value.initiator!, (value) {
      return _then(_value.copyWith(initiator: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChatMessageContentImplCopyWith<$Res>
    implements $ChatMessageContentCopyWith<$Res> {
  factory _$$ChatMessageContentImplCopyWith(_$ChatMessageContentImpl value,
          $Res Function(_$ChatMessageContentImpl) then) =
      __$$ChatMessageContentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? message,
      String? topic,
      @JsonKey(name: 'participants', readValue: readValueListObjects)
      List<ChatParticipant>? participants,
      @JsonKey(name: 'initiator', readValue: readValueObject)
      CommunicationIdentifier? initiator});

  @override
  $CommunicationIdentifierCopyWith<$Res>? get initiator;
}

/// @nodoc
class __$$ChatMessageContentImplCopyWithImpl<$Res>
    extends _$ChatMessageContentCopyWithImpl<$Res, _$ChatMessageContentImpl>
    implements _$$ChatMessageContentImplCopyWith<$Res> {
  __$$ChatMessageContentImplCopyWithImpl(_$ChatMessageContentImpl _value,
      $Res Function(_$ChatMessageContentImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatMessageContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
    Object? topic = freezed,
    Object? participants = freezed,
    Object? initiator = freezed,
  }) {
    return _then(_$ChatMessageContentImpl(
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      topic: freezed == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String?,
      participants: freezed == participants
          ? _value._participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<ChatParticipant>?,
      initiator: freezed == initiator
          ? _value.initiator
          : initiator // ignore: cast_nullable_to_non_nullable
              as CommunicationIdentifier?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMessageContentImpl implements _ChatMessageContent {
  const _$ChatMessageContentImpl(
      {this.message,
      this.topic,
      @JsonKey(name: 'participants', readValue: readValueListObjects)
      final List<ChatParticipant>? participants,
      @JsonKey(name: 'initiator', readValue: readValueObject) this.initiator})
      : _participants = participants;

  factory _$ChatMessageContentImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageContentImplFromJson(json);

  @override
  final String? message;
  @override
  final String? topic;
  final List<ChatParticipant>? _participants;
  @override
  @JsonKey(name: 'participants', readValue: readValueListObjects)
  List<ChatParticipant>? get participants {
    final value = _participants;
    if (value == null) return null;
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'initiator', readValue: readValueObject)
  final CommunicationIdentifier? initiator;

  @override
  String toString() {
    return 'ChatMessageContent(message: $message, topic: $topic, participants: $participants, initiator: $initiator)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageContentImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.topic, topic) || other.topic == topic) &&
            const DeepCollectionEquality()
                .equals(other._participants, _participants) &&
            (identical(other.initiator, initiator) ||
                other.initiator == initiator));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message, topic,
      const DeepCollectionEquality().hash(_participants), initiator);

  /// Create a copy of ChatMessageContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageContentImplCopyWith<_$ChatMessageContentImpl> get copyWith =>
      __$$ChatMessageContentImplCopyWithImpl<_$ChatMessageContentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageContentImplToJson(
      this,
    );
  }
}

abstract class _ChatMessageContent implements ChatMessageContent {
  const factory _ChatMessageContent(
      {final String? message,
      final String? topic,
      @JsonKey(name: 'participants', readValue: readValueListObjects)
      final List<ChatParticipant>? participants,
      @JsonKey(name: 'initiator', readValue: readValueObject)
      final CommunicationIdentifier? initiator}) = _$ChatMessageContentImpl;

  factory _ChatMessageContent.fromJson(Map<String, dynamic> json) =
      _$ChatMessageContentImpl.fromJson;

  @override
  String? get message;
  @override
  String? get topic;
  @override
  @JsonKey(name: 'participants', readValue: readValueListObjects)
  List<ChatParticipant>? get participants;
  @override
  @JsonKey(name: 'initiator', readValue: readValueObject)
  CommunicationIdentifier? get initiator;

  /// Create a copy of ChatMessageContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatMessageContentImplCopyWith<_$ChatMessageContentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
