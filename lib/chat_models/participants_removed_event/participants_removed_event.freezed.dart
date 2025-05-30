// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participants_removed_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ParticipantsRemovedEvent _$ParticipantsRemovedEventFromJson(
    Map<String, dynamic> json) {
  return _ParticipantsRemovedEvent.fromJson(json);
}

/// @nodoc
mixin _$ParticipantsRemovedEvent {
  String get threadId => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  String get removedOn => throw _privateConstructorUsedError;
  @JsonKey(name: 'participantsAdded', readValue: readValueListObjects)
  List<SignalingChatParticipant> get participantsRemoved =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'removedBy', readValue: readValueObject)
  SignalingChatParticipant get removedBy => throw _privateConstructorUsedError;

  /// Serializes this ParticipantsRemovedEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ParticipantsRemovedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ParticipantsRemovedEventCopyWith<ParticipantsRemovedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParticipantsRemovedEventCopyWith<$Res> {
  factory $ParticipantsRemovedEventCopyWith(ParticipantsRemovedEvent value,
          $Res Function(ParticipantsRemovedEvent) then) =
      _$ParticipantsRemovedEventCopyWithImpl<$Res, ParticipantsRemovedEvent>;
  @useResult
  $Res call(
      {String threadId,
      String version,
      String removedOn,
      @JsonKey(name: 'participantsAdded', readValue: readValueListObjects)
      List<SignalingChatParticipant> participantsRemoved,
      @JsonKey(name: 'removedBy', readValue: readValueObject)
      SignalingChatParticipant removedBy});

  $SignalingChatParticipantCopyWith<$Res> get removedBy;
}

/// @nodoc
class _$ParticipantsRemovedEventCopyWithImpl<$Res,
        $Val extends ParticipantsRemovedEvent>
    implements $ParticipantsRemovedEventCopyWith<$Res> {
  _$ParticipantsRemovedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ParticipantsRemovedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? threadId = null,
    Object? version = null,
    Object? removedOn = null,
    Object? participantsRemoved = null,
    Object? removedBy = null,
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
      removedOn: null == removedOn
          ? _value.removedOn
          : removedOn // ignore: cast_nullable_to_non_nullable
              as String,
      participantsRemoved: null == participantsRemoved
          ? _value.participantsRemoved
          : participantsRemoved // ignore: cast_nullable_to_non_nullable
              as List<SignalingChatParticipant>,
      removedBy: null == removedBy
          ? _value.removedBy
          : removedBy // ignore: cast_nullable_to_non_nullable
              as SignalingChatParticipant,
    ) as $Val);
  }

  /// Create a copy of ParticipantsRemovedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SignalingChatParticipantCopyWith<$Res> get removedBy {
    return $SignalingChatParticipantCopyWith<$Res>(_value.removedBy, (value) {
      return _then(_value.copyWith(removedBy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ParticipantsRemovedEventImplCopyWith<$Res>
    implements $ParticipantsRemovedEventCopyWith<$Res> {
  factory _$$ParticipantsRemovedEventImplCopyWith(
          _$ParticipantsRemovedEventImpl value,
          $Res Function(_$ParticipantsRemovedEventImpl) then) =
      __$$ParticipantsRemovedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String threadId,
      String version,
      String removedOn,
      @JsonKey(name: 'participantsAdded', readValue: readValueListObjects)
      List<SignalingChatParticipant> participantsRemoved,
      @JsonKey(name: 'removedBy', readValue: readValueObject)
      SignalingChatParticipant removedBy});

  @override
  $SignalingChatParticipantCopyWith<$Res> get removedBy;
}

/// @nodoc
class __$$ParticipantsRemovedEventImplCopyWithImpl<$Res>
    extends _$ParticipantsRemovedEventCopyWithImpl<$Res,
        _$ParticipantsRemovedEventImpl>
    implements _$$ParticipantsRemovedEventImplCopyWith<$Res> {
  __$$ParticipantsRemovedEventImplCopyWithImpl(
      _$ParticipantsRemovedEventImpl _value,
      $Res Function(_$ParticipantsRemovedEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of ParticipantsRemovedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? threadId = null,
    Object? version = null,
    Object? removedOn = null,
    Object? participantsRemoved = null,
    Object? removedBy = null,
  }) {
    return _then(_$ParticipantsRemovedEventImpl(
      threadId: null == threadId
          ? _value.threadId
          : threadId // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      removedOn: null == removedOn
          ? _value.removedOn
          : removedOn // ignore: cast_nullable_to_non_nullable
              as String,
      participantsRemoved: null == participantsRemoved
          ? _value._participantsRemoved
          : participantsRemoved // ignore: cast_nullable_to_non_nullable
              as List<SignalingChatParticipant>,
      removedBy: null == removedBy
          ? _value.removedBy
          : removedBy // ignore: cast_nullable_to_non_nullable
              as SignalingChatParticipant,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ParticipantsRemovedEventImpl implements _ParticipantsRemovedEvent {
  const _$ParticipantsRemovedEventImpl(
      {required this.threadId,
      required this.version,
      required this.removedOn,
      @JsonKey(name: 'participantsAdded', readValue: readValueListObjects)
      required final List<SignalingChatParticipant> participantsRemoved,
      @JsonKey(name: 'removedBy', readValue: readValueObject)
      required this.removedBy})
      : _participantsRemoved = participantsRemoved;

  factory _$ParticipantsRemovedEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$ParticipantsRemovedEventImplFromJson(json);

  @override
  final String threadId;
  @override
  final String version;
  @override
  final String removedOn;
  final List<SignalingChatParticipant> _participantsRemoved;
  @override
  @JsonKey(name: 'participantsAdded', readValue: readValueListObjects)
  List<SignalingChatParticipant> get participantsRemoved {
    if (_participantsRemoved is EqualUnmodifiableListView)
      return _participantsRemoved;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participantsRemoved);
  }

  @override
  @JsonKey(name: 'removedBy', readValue: readValueObject)
  final SignalingChatParticipant removedBy;

  @override
  String toString() {
    return 'ParticipantsRemovedEvent(threadId: $threadId, version: $version, removedOn: $removedOn, participantsRemoved: $participantsRemoved, removedBy: $removedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParticipantsRemovedEventImpl &&
            (identical(other.threadId, threadId) ||
                other.threadId == threadId) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.removedOn, removedOn) ||
                other.removedOn == removedOn) &&
            const DeepCollectionEquality()
                .equals(other._participantsRemoved, _participantsRemoved) &&
            (identical(other.removedBy, removedBy) ||
                other.removedBy == removedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, threadId, version, removedOn,
      const DeepCollectionEquality().hash(_participantsRemoved), removedBy);

  /// Create a copy of ParticipantsRemovedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ParticipantsRemovedEventImplCopyWith<_$ParticipantsRemovedEventImpl>
      get copyWith => __$$ParticipantsRemovedEventImplCopyWithImpl<
          _$ParticipantsRemovedEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ParticipantsRemovedEventImplToJson(
      this,
    );
  }
}

abstract class _ParticipantsRemovedEvent implements ParticipantsRemovedEvent {
  const factory _ParticipantsRemovedEvent(
          {required final String threadId,
          required final String version,
          required final String removedOn,
          @JsonKey(name: 'participantsAdded', readValue: readValueListObjects)
          required final List<SignalingChatParticipant> participantsRemoved,
          @JsonKey(name: 'removedBy', readValue: readValueObject)
          required final SignalingChatParticipant removedBy}) =
      _$ParticipantsRemovedEventImpl;

  factory _ParticipantsRemovedEvent.fromJson(Map<String, dynamic> json) =
      _$ParticipantsRemovedEventImpl.fromJson;

  @override
  String get threadId;
  @override
  String get version;
  @override
  String get removedOn;
  @override
  @JsonKey(name: 'participantsAdded', readValue: readValueListObjects)
  List<SignalingChatParticipant> get participantsRemoved;
  @override
  @JsonKey(name: 'removedBy', readValue: readValueObject)
  SignalingChatParticipant get removedBy;

  /// Create a copy of ParticipantsRemovedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ParticipantsRemovedEventImplCopyWith<_$ParticipantsRemovedEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}
