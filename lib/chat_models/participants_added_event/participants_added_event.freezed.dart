// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participants_added_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ParticipantsAddedEvent _$ParticipantsAddedEventFromJson(
    Map<String, dynamic> json) {
  return _ParticipantsAddedEvent.fromJson(json);
}

/// @nodoc
mixin _$ParticipantsAddedEvent {
  String get threadId => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  String get addedOn => throw _privateConstructorUsedError;
  @JsonKey(name: 'participantsAdded', readValue: readValueListObjects)
  List<SignalingChatParticipant> get participantsAdded =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'addedBy', readValue: readValueObject)
  SignalingChatParticipant get addedBy => throw _privateConstructorUsedError;

  /// Serializes this ParticipantsAddedEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ParticipantsAddedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ParticipantsAddedEventCopyWith<ParticipantsAddedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParticipantsAddedEventCopyWith<$Res> {
  factory $ParticipantsAddedEventCopyWith(ParticipantsAddedEvent value,
          $Res Function(ParticipantsAddedEvent) then) =
      _$ParticipantsAddedEventCopyWithImpl<$Res, ParticipantsAddedEvent>;
  @useResult
  $Res call(
      {String threadId,
      String version,
      String addedOn,
      @JsonKey(name: 'participantsAdded', readValue: readValueListObjects)
      List<SignalingChatParticipant> participantsAdded,
      @JsonKey(name: 'addedBy', readValue: readValueObject)
      SignalingChatParticipant addedBy});

  $SignalingChatParticipantCopyWith<$Res> get addedBy;
}

/// @nodoc
class _$ParticipantsAddedEventCopyWithImpl<$Res,
        $Val extends ParticipantsAddedEvent>
    implements $ParticipantsAddedEventCopyWith<$Res> {
  _$ParticipantsAddedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ParticipantsAddedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? threadId = null,
    Object? version = null,
    Object? addedOn = null,
    Object? participantsAdded = null,
    Object? addedBy = null,
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
      addedOn: null == addedOn
          ? _value.addedOn
          : addedOn // ignore: cast_nullable_to_non_nullable
              as String,
      participantsAdded: null == participantsAdded
          ? _value.participantsAdded
          : participantsAdded // ignore: cast_nullable_to_non_nullable
              as List<SignalingChatParticipant>,
      addedBy: null == addedBy
          ? _value.addedBy
          : addedBy // ignore: cast_nullable_to_non_nullable
              as SignalingChatParticipant,
    ) as $Val);
  }

  /// Create a copy of ParticipantsAddedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SignalingChatParticipantCopyWith<$Res> get addedBy {
    return $SignalingChatParticipantCopyWith<$Res>(_value.addedBy, (value) {
      return _then(_value.copyWith(addedBy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ParticipantsAddedEventImplCopyWith<$Res>
    implements $ParticipantsAddedEventCopyWith<$Res> {
  factory _$$ParticipantsAddedEventImplCopyWith(
          _$ParticipantsAddedEventImpl value,
          $Res Function(_$ParticipantsAddedEventImpl) then) =
      __$$ParticipantsAddedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String threadId,
      String version,
      String addedOn,
      @JsonKey(name: 'participantsAdded', readValue: readValueListObjects)
      List<SignalingChatParticipant> participantsAdded,
      @JsonKey(name: 'addedBy', readValue: readValueObject)
      SignalingChatParticipant addedBy});

  @override
  $SignalingChatParticipantCopyWith<$Res> get addedBy;
}

/// @nodoc
class __$$ParticipantsAddedEventImplCopyWithImpl<$Res>
    extends _$ParticipantsAddedEventCopyWithImpl<$Res,
        _$ParticipantsAddedEventImpl>
    implements _$$ParticipantsAddedEventImplCopyWith<$Res> {
  __$$ParticipantsAddedEventImplCopyWithImpl(
      _$ParticipantsAddedEventImpl _value,
      $Res Function(_$ParticipantsAddedEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of ParticipantsAddedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? threadId = null,
    Object? version = null,
    Object? addedOn = null,
    Object? participantsAdded = null,
    Object? addedBy = null,
  }) {
    return _then(_$ParticipantsAddedEventImpl(
      threadId: null == threadId
          ? _value.threadId
          : threadId // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      addedOn: null == addedOn
          ? _value.addedOn
          : addedOn // ignore: cast_nullable_to_non_nullable
              as String,
      participantsAdded: null == participantsAdded
          ? _value._participantsAdded
          : participantsAdded // ignore: cast_nullable_to_non_nullable
              as List<SignalingChatParticipant>,
      addedBy: null == addedBy
          ? _value.addedBy
          : addedBy // ignore: cast_nullable_to_non_nullable
              as SignalingChatParticipant,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ParticipantsAddedEventImpl implements _ParticipantsAddedEvent {
  const _$ParticipantsAddedEventImpl(
      {required this.threadId,
      required this.version,
      required this.addedOn,
      @JsonKey(name: 'participantsAdded', readValue: readValueListObjects)
      required final List<SignalingChatParticipant> participantsAdded,
      @JsonKey(name: 'addedBy', readValue: readValueObject)
      required this.addedBy})
      : _participantsAdded = participantsAdded;

  factory _$ParticipantsAddedEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$ParticipantsAddedEventImplFromJson(json);

  @override
  final String threadId;
  @override
  final String version;
  @override
  final String addedOn;
  final List<SignalingChatParticipant> _participantsAdded;
  @override
  @JsonKey(name: 'participantsAdded', readValue: readValueListObjects)
  List<SignalingChatParticipant> get participantsAdded {
    if (_participantsAdded is EqualUnmodifiableListView)
      return _participantsAdded;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participantsAdded);
  }

  @override
  @JsonKey(name: 'addedBy', readValue: readValueObject)
  final SignalingChatParticipant addedBy;

  @override
  String toString() {
    return 'ParticipantsAddedEvent(threadId: $threadId, version: $version, addedOn: $addedOn, participantsAdded: $participantsAdded, addedBy: $addedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParticipantsAddedEventImpl &&
            (identical(other.threadId, threadId) ||
                other.threadId == threadId) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.addedOn, addedOn) || other.addedOn == addedOn) &&
            const DeepCollectionEquality()
                .equals(other._participantsAdded, _participantsAdded) &&
            (identical(other.addedBy, addedBy) || other.addedBy == addedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, threadId, version, addedOn,
      const DeepCollectionEquality().hash(_participantsAdded), addedBy);

  /// Create a copy of ParticipantsAddedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ParticipantsAddedEventImplCopyWith<_$ParticipantsAddedEventImpl>
      get copyWith => __$$ParticipantsAddedEventImplCopyWithImpl<
          _$ParticipantsAddedEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ParticipantsAddedEventImplToJson(
      this,
    );
  }
}

abstract class _ParticipantsAddedEvent implements ParticipantsAddedEvent {
  const factory _ParticipantsAddedEvent(
          {required final String threadId,
          required final String version,
          required final String addedOn,
          @JsonKey(name: 'participantsAdded', readValue: readValueListObjects)
          required final List<SignalingChatParticipant> participantsAdded,
          @JsonKey(name: 'addedBy', readValue: readValueObject)
          required final SignalingChatParticipant addedBy}) =
      _$ParticipantsAddedEventImpl;

  factory _ParticipantsAddedEvent.fromJson(Map<String, dynamic> json) =
      _$ParticipantsAddedEventImpl.fromJson;

  @override
  String get threadId;
  @override
  String get version;
  @override
  String get addedOn;
  @override
  @JsonKey(name: 'participantsAdded', readValue: readValueListObjects)
  List<SignalingChatParticipant> get participantsAdded;
  @override
  @JsonKey(name: 'addedBy', readValue: readValueObject)
  SignalingChatParticipant get addedBy;

  /// Create a copy of ParticipantsAddedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ParticipantsAddedEventImplCopyWith<_$ParticipantsAddedEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}
