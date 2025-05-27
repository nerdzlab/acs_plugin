// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'signaling_chat_participant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SignalingChatParticipant _$SignalingChatParticipantFromJson(
    Map<String, dynamic> json) {
  return _SignalingChatParticipant.fromJson(json);
}

/// @nodoc
mixin _$SignalingChatParticipant {
  @JsonKey(name: 'id', readValue: readValueObject)
  CommunicationIdentifier? get id => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  String? get shareHistoryTime => throw _privateConstructorUsedError;

  /// Serializes this SignalingChatParticipant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SignalingChatParticipant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SignalingChatParticipantCopyWith<SignalingChatParticipant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignalingChatParticipantCopyWith<$Res> {
  factory $SignalingChatParticipantCopyWith(SignalingChatParticipant value,
          $Res Function(SignalingChatParticipant) then) =
      _$SignalingChatParticipantCopyWithImpl<$Res, SignalingChatParticipant>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id', readValue: readValueObject)
      CommunicationIdentifier? id,
      String? displayName,
      String? shareHistoryTime});

  $CommunicationIdentifierCopyWith<$Res>? get id;
}

/// @nodoc
class _$SignalingChatParticipantCopyWithImpl<$Res,
        $Val extends SignalingChatParticipant>
    implements $SignalingChatParticipantCopyWith<$Res> {
  _$SignalingChatParticipantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SignalingChatParticipant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? displayName = freezed,
    Object? shareHistoryTime = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as CommunicationIdentifier?,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      shareHistoryTime: freezed == shareHistoryTime
          ? _value.shareHistoryTime
          : shareHistoryTime // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of SignalingChatParticipant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CommunicationIdentifierCopyWith<$Res>? get id {
    if (_value.id == null) {
      return null;
    }

    return $CommunicationIdentifierCopyWith<$Res>(_value.id!, (value) {
      return _then(_value.copyWith(id: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SignalingChatParticipantImplCopyWith<$Res>
    implements $SignalingChatParticipantCopyWith<$Res> {
  factory _$$SignalingChatParticipantImplCopyWith(
          _$SignalingChatParticipantImpl value,
          $Res Function(_$SignalingChatParticipantImpl) then) =
      __$$SignalingChatParticipantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id', readValue: readValueObject)
      CommunicationIdentifier? id,
      String? displayName,
      String? shareHistoryTime});

  @override
  $CommunicationIdentifierCopyWith<$Res>? get id;
}

/// @nodoc
class __$$SignalingChatParticipantImplCopyWithImpl<$Res>
    extends _$SignalingChatParticipantCopyWithImpl<$Res,
        _$SignalingChatParticipantImpl>
    implements _$$SignalingChatParticipantImplCopyWith<$Res> {
  __$$SignalingChatParticipantImplCopyWithImpl(
      _$SignalingChatParticipantImpl _value,
      $Res Function(_$SignalingChatParticipantImpl) _then)
      : super(_value, _then);

  /// Create a copy of SignalingChatParticipant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? displayName = freezed,
    Object? shareHistoryTime = freezed,
  }) {
    return _then(_$SignalingChatParticipantImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as CommunicationIdentifier?,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      shareHistoryTime: freezed == shareHistoryTime
          ? _value.shareHistoryTime
          : shareHistoryTime // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SignalingChatParticipantImpl implements _SignalingChatParticipant {
  const _$SignalingChatParticipantImpl(
      {@JsonKey(name: 'id', readValue: readValueObject) this.id,
      this.displayName,
      this.shareHistoryTime});

  factory _$SignalingChatParticipantImpl.fromJson(Map<String, dynamic> json) =>
      _$$SignalingChatParticipantImplFromJson(json);

  @override
  @JsonKey(name: 'id', readValue: readValueObject)
  final CommunicationIdentifier? id;
  @override
  final String? displayName;
  @override
  final String? shareHistoryTime;

  @override
  String toString() {
    return 'SignalingChatParticipant(id: $id, displayName: $displayName, shareHistoryTime: $shareHistoryTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignalingChatParticipantImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.shareHistoryTime, shareHistoryTime) ||
                other.shareHistoryTime == shareHistoryTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, displayName, shareHistoryTime);

  /// Create a copy of SignalingChatParticipant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SignalingChatParticipantImplCopyWith<_$SignalingChatParticipantImpl>
      get copyWith => __$$SignalingChatParticipantImplCopyWithImpl<
          _$SignalingChatParticipantImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SignalingChatParticipantImplToJson(
      this,
    );
  }
}

abstract class _SignalingChatParticipant implements SignalingChatParticipant {
  const factory _SignalingChatParticipant(
      {@JsonKey(name: 'id', readValue: readValueObject)
      final CommunicationIdentifier? id,
      final String? displayName,
      final String? shareHistoryTime}) = _$SignalingChatParticipantImpl;

  factory _SignalingChatParticipant.fromJson(Map<String, dynamic> json) =
      _$SignalingChatParticipantImpl.fromJson;

  @override
  @JsonKey(name: 'id', readValue: readValueObject)
  CommunicationIdentifier? get id;
  @override
  String? get displayName;
  @override
  String? get shareHistoryTime;

  /// Create a copy of SignalingChatParticipant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SignalingChatParticipantImplCopyWith<_$SignalingChatParticipantImpl>
      get copyWith => throw _privateConstructorUsedError;
}
