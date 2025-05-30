// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'identifier_kind.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

IdentifierKind _$IdentifierKindFromJson(Map<String, dynamic> json) {
  return _IdentifierKind.fromJson(json);
}

/// @nodoc
mixin _$IdentifierKind {
  String get rawValue => throw _privateConstructorUsedError;

  /// Serializes this IdentifierKind to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IdentifierKind
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IdentifierKindCopyWith<IdentifierKind> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IdentifierKindCopyWith<$Res> {
  factory $IdentifierKindCopyWith(
          IdentifierKind value, $Res Function(IdentifierKind) then) =
      _$IdentifierKindCopyWithImpl<$Res, IdentifierKind>;
  @useResult
  $Res call({String rawValue});
}

/// @nodoc
class _$IdentifierKindCopyWithImpl<$Res, $Val extends IdentifierKind>
    implements $IdentifierKindCopyWith<$Res> {
  _$IdentifierKindCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IdentifierKind
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rawValue = null,
  }) {
    return _then(_value.copyWith(
      rawValue: null == rawValue
          ? _value.rawValue
          : rawValue // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IdentifierKindImplCopyWith<$Res>
    implements $IdentifierKindCopyWith<$Res> {
  factory _$$IdentifierKindImplCopyWith(_$IdentifierKindImpl value,
          $Res Function(_$IdentifierKindImpl) then) =
      __$$IdentifierKindImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String rawValue});
}

/// @nodoc
class __$$IdentifierKindImplCopyWithImpl<$Res>
    extends _$IdentifierKindCopyWithImpl<$Res, _$IdentifierKindImpl>
    implements _$$IdentifierKindImplCopyWith<$Res> {
  __$$IdentifierKindImplCopyWithImpl(
      _$IdentifierKindImpl _value, $Res Function(_$IdentifierKindImpl) _then)
      : super(_value, _then);

  /// Create a copy of IdentifierKind
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rawValue = null,
  }) {
    return _then(_$IdentifierKindImpl(
      rawValue: null == rawValue
          ? _value.rawValue
          : rawValue // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IdentifierKindImpl implements _IdentifierKind {
  const _$IdentifierKindImpl({required this.rawValue});

  factory _$IdentifierKindImpl.fromJson(Map<String, dynamic> json) =>
      _$$IdentifierKindImplFromJson(json);

  @override
  final String rawValue;

  @override
  String toString() {
    return 'IdentifierKind(rawValue: $rawValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IdentifierKindImpl &&
            (identical(other.rawValue, rawValue) ||
                other.rawValue == rawValue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, rawValue);

  /// Create a copy of IdentifierKind
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IdentifierKindImplCopyWith<_$IdentifierKindImpl> get copyWith =>
      __$$IdentifierKindImplCopyWithImpl<_$IdentifierKindImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IdentifierKindImplToJson(
      this,
    );
  }
}

abstract class _IdentifierKind implements IdentifierKind {
  const factory _IdentifierKind({required final String rawValue}) =
      _$IdentifierKindImpl;

  factory _IdentifierKind.fromJson(Map<String, dynamic> json) =
      _$IdentifierKindImpl.fromJson;

  @override
  String get rawValue;

  /// Create a copy of IdentifierKind
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IdentifierKindImplCopyWith<_$IdentifierKindImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
