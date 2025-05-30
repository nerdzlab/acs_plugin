// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'communication_identifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CommunicationIdentifier _$CommunicationIdentifierFromJson(
    Map<String, dynamic> json) {
  return _CommunicationIdentifier.fromJson(json);
}

/// @nodoc
mixin _$CommunicationIdentifier {
  String get rawId => throw _privateConstructorUsedError;
  @JsonKey(name: 'kind', readValue: readValueObject)
  IdentifierKind get kind => throw _privateConstructorUsedError;

  /// Serializes this CommunicationIdentifier to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommunicationIdentifier
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommunicationIdentifierCopyWith<CommunicationIdentifier> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommunicationIdentifierCopyWith<$Res> {
  factory $CommunicationIdentifierCopyWith(CommunicationIdentifier value,
          $Res Function(CommunicationIdentifier) then) =
      _$CommunicationIdentifierCopyWithImpl<$Res, CommunicationIdentifier>;
  @useResult
  $Res call(
      {String rawId,
      @JsonKey(name: 'kind', readValue: readValueObject) IdentifierKind kind});

  $IdentifierKindCopyWith<$Res> get kind;
}

/// @nodoc
class _$CommunicationIdentifierCopyWithImpl<$Res,
        $Val extends CommunicationIdentifier>
    implements $CommunicationIdentifierCopyWith<$Res> {
  _$CommunicationIdentifierCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommunicationIdentifier
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rawId = null,
    Object? kind = null,
  }) {
    return _then(_value.copyWith(
      rawId: null == rawId
          ? _value.rawId
          : rawId // ignore: cast_nullable_to_non_nullable
              as String,
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as IdentifierKind,
    ) as $Val);
  }

  /// Create a copy of CommunicationIdentifier
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $IdentifierKindCopyWith<$Res> get kind {
    return $IdentifierKindCopyWith<$Res>(_value.kind, (value) {
      return _then(_value.copyWith(kind: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CommunicationIdentifierImplCopyWith<$Res>
    implements $CommunicationIdentifierCopyWith<$Res> {
  factory _$$CommunicationIdentifierImplCopyWith(
          _$CommunicationIdentifierImpl value,
          $Res Function(_$CommunicationIdentifierImpl) then) =
      __$$CommunicationIdentifierImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String rawId,
      @JsonKey(name: 'kind', readValue: readValueObject) IdentifierKind kind});

  @override
  $IdentifierKindCopyWith<$Res> get kind;
}

/// @nodoc
class __$$CommunicationIdentifierImplCopyWithImpl<$Res>
    extends _$CommunicationIdentifierCopyWithImpl<$Res,
        _$CommunicationIdentifierImpl>
    implements _$$CommunicationIdentifierImplCopyWith<$Res> {
  __$$CommunicationIdentifierImplCopyWithImpl(
      _$CommunicationIdentifierImpl _value,
      $Res Function(_$CommunicationIdentifierImpl) _then)
      : super(_value, _then);

  /// Create a copy of CommunicationIdentifier
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rawId = null,
    Object? kind = null,
  }) {
    return _then(_$CommunicationIdentifierImpl(
      rawId: null == rawId
          ? _value.rawId
          : rawId // ignore: cast_nullable_to_non_nullable
              as String,
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as IdentifierKind,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommunicationIdentifierImpl implements _CommunicationIdentifier {
  const _$CommunicationIdentifierImpl(
      {required this.rawId,
      @JsonKey(name: 'kind', readValue: readValueObject) required this.kind});

  factory _$CommunicationIdentifierImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommunicationIdentifierImplFromJson(json);

  @override
  final String rawId;
  @override
  @JsonKey(name: 'kind', readValue: readValueObject)
  final IdentifierKind kind;

  @override
  String toString() {
    return 'CommunicationIdentifier(rawId: $rawId, kind: $kind)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommunicationIdentifierImpl &&
            (identical(other.rawId, rawId) || other.rawId == rawId) &&
            (identical(other.kind, kind) || other.kind == kind));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, rawId, kind);

  /// Create a copy of CommunicationIdentifier
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommunicationIdentifierImplCopyWith<_$CommunicationIdentifierImpl>
      get copyWith => __$$CommunicationIdentifierImplCopyWithImpl<
          _$CommunicationIdentifierImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommunicationIdentifierImplToJson(
      this,
    );
  }
}

abstract class _CommunicationIdentifier implements CommunicationIdentifier {
  const factory _CommunicationIdentifier(
      {required final String rawId,
      @JsonKey(name: 'kind', readValue: readValueObject)
      required final IdentifierKind kind}) = _$CommunicationIdentifierImpl;

  factory _CommunicationIdentifier.fromJson(Map<String, dynamic> json) =
      _$CommunicationIdentifierImpl.fromJson;

  @override
  String get rawId;
  @override
  @JsonKey(name: 'kind', readValue: readValueObject)
  IdentifierKind get kind;

  /// Create a copy of CommunicationIdentifier
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommunicationIdentifierImplCopyWith<_$CommunicationIdentifierImpl>
      get copyWith => throw _privateConstructorUsedError;
}
