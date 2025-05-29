// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_thread_deleted_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatThreadDeletedEvent _$ChatThreadDeletedEventFromJson(
    Map<String, dynamic> json) {
  return _ChatThreadDeletedEvent.fromJson(json);
}

/// @nodoc
mixin _$ChatThreadDeletedEvent {
  String get threadId => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  String get deletedOn => throw _privateConstructorUsedError;
  @JsonKey(name: 'deletedBy', readValue: readValueObject)
  SignalingChatParticipant get deletedBy => throw _privateConstructorUsedError;

  /// Serializes this ChatThreadDeletedEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatThreadDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatThreadDeletedEventCopyWith<ChatThreadDeletedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatThreadDeletedEventCopyWith<$Res> {
  factory $ChatThreadDeletedEventCopyWith(ChatThreadDeletedEvent value,
          $Res Function(ChatThreadDeletedEvent) then) =
      _$ChatThreadDeletedEventCopyWithImpl<$Res, ChatThreadDeletedEvent>;
  @useResult
  $Res call(
      {String threadId,
      String version,
      String deletedOn,
      @JsonKey(name: 'deletedBy', readValue: readValueObject)
      SignalingChatParticipant deletedBy});

  $SignalingChatParticipantCopyWith<$Res> get deletedBy;
}

/// @nodoc
class _$ChatThreadDeletedEventCopyWithImpl<$Res,
        $Val extends ChatThreadDeletedEvent>
    implements $ChatThreadDeletedEventCopyWith<$Res> {
  _$ChatThreadDeletedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatThreadDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? threadId = null,
    Object? version = null,
    Object? deletedOn = null,
    Object? deletedBy = null,
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
      deletedOn: null == deletedOn
          ? _value.deletedOn
          : deletedOn // ignore: cast_nullable_to_non_nullable
              as String,
      deletedBy: null == deletedBy
          ? _value.deletedBy
          : deletedBy // ignore: cast_nullable_to_non_nullable
              as SignalingChatParticipant,
    ) as $Val);
  }

  /// Create a copy of ChatThreadDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SignalingChatParticipantCopyWith<$Res> get deletedBy {
    return $SignalingChatParticipantCopyWith<$Res>(_value.deletedBy, (value) {
      return _then(_value.copyWith(deletedBy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChatThreadDeletedEventImplCopyWith<$Res>
    implements $ChatThreadDeletedEventCopyWith<$Res> {
  factory _$$ChatThreadDeletedEventImplCopyWith(
          _$ChatThreadDeletedEventImpl value,
          $Res Function(_$ChatThreadDeletedEventImpl) then) =
      __$$ChatThreadDeletedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String threadId,
      String version,
      String deletedOn,
      @JsonKey(name: 'deletedBy', readValue: readValueObject)
      SignalingChatParticipant deletedBy});

  @override
  $SignalingChatParticipantCopyWith<$Res> get deletedBy;
}

/// @nodoc
class __$$ChatThreadDeletedEventImplCopyWithImpl<$Res>
    extends _$ChatThreadDeletedEventCopyWithImpl<$Res,
        _$ChatThreadDeletedEventImpl>
    implements _$$ChatThreadDeletedEventImplCopyWith<$Res> {
  __$$ChatThreadDeletedEventImplCopyWithImpl(
      _$ChatThreadDeletedEventImpl _value,
      $Res Function(_$ChatThreadDeletedEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatThreadDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? threadId = null,
    Object? version = null,
    Object? deletedOn = null,
    Object? deletedBy = null,
  }) {
    return _then(_$ChatThreadDeletedEventImpl(
      threadId: null == threadId
          ? _value.threadId
          : threadId // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      deletedOn: null == deletedOn
          ? _value.deletedOn
          : deletedOn // ignore: cast_nullable_to_non_nullable
              as String,
      deletedBy: null == deletedBy
          ? _value.deletedBy
          : deletedBy // ignore: cast_nullable_to_non_nullable
              as SignalingChatParticipant,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatThreadDeletedEventImpl implements _ChatThreadDeletedEvent {
  const _$ChatThreadDeletedEventImpl(
      {required this.threadId,
      required this.version,
      required this.deletedOn,
      @JsonKey(name: 'deletedBy', readValue: readValueObject)
      required this.deletedBy});

  factory _$ChatThreadDeletedEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatThreadDeletedEventImplFromJson(json);

  @override
  final String threadId;
  @override
  final String version;
  @override
  final String deletedOn;
  @override
  @JsonKey(name: 'deletedBy', readValue: readValueObject)
  final SignalingChatParticipant deletedBy;

  @override
  String toString() {
    return 'ChatThreadDeletedEvent(threadId: $threadId, version: $version, deletedOn: $deletedOn, deletedBy: $deletedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatThreadDeletedEventImpl &&
            (identical(other.threadId, threadId) ||
                other.threadId == threadId) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.deletedOn, deletedOn) ||
                other.deletedOn == deletedOn) &&
            (identical(other.deletedBy, deletedBy) ||
                other.deletedBy == deletedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, threadId, version, deletedOn, deletedBy);

  /// Create a copy of ChatThreadDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatThreadDeletedEventImplCopyWith<_$ChatThreadDeletedEventImpl>
      get copyWith => __$$ChatThreadDeletedEventImplCopyWithImpl<
          _$ChatThreadDeletedEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatThreadDeletedEventImplToJson(
      this,
    );
  }
}

abstract class _ChatThreadDeletedEvent implements ChatThreadDeletedEvent {
  const factory _ChatThreadDeletedEvent(
          {required final String threadId,
          required final String version,
          required final String deletedOn,
          @JsonKey(name: 'deletedBy', readValue: readValueObject)
          required final SignalingChatParticipant deletedBy}) =
      _$ChatThreadDeletedEventImpl;

  factory _ChatThreadDeletedEvent.fromJson(Map<String, dynamic> json) =
      _$ChatThreadDeletedEventImpl.fromJson;

  @override
  String get threadId;
  @override
  String get version;
  @override
  String get deletedOn;
  @override
  @JsonKey(name: 'deletedBy', readValue: readValueObject)
  SignalingChatParticipant get deletedBy;

  /// Create a copy of ChatThreadDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatThreadDeletedEventImplCopyWith<_$ChatThreadDeletedEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}
