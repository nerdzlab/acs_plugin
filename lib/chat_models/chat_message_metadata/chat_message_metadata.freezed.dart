// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatMessageMetadata _$ChatMessageMetadataFromJson(Map<String, dynamic> json) {
  return _ChatMessageMetadata.fromJson(json);
}

/// @nodoc
mixin _$ChatMessageMetadata {
  @JsonKey(name: 'attachments', readValue: readValueListObjects)
  List<Attachments>? get attachments => throw _privateConstructorUsedError;
  @JsonKey(name: 'repliedTo', readValue: readValueObject)
  RepliedTo? get repliedTo => throw _privateConstructorUsedError;
  @JsonKey(name: 'emojes', readValue: readValueObject)
  Emojes? get emojes => throw _privateConstructorUsedError;
  String? get version => throw _privateConstructorUsedError;
  bool? get isEdited => throw _privateConstructorUsedError;

  /// Serializes this ChatMessageMetadata to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatMessageMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatMessageMetadataCopyWith<ChatMessageMetadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageMetadataCopyWith<$Res> {
  factory $ChatMessageMetadataCopyWith(
          ChatMessageMetadata value, $Res Function(ChatMessageMetadata) then) =
      _$ChatMessageMetadataCopyWithImpl<$Res, ChatMessageMetadata>;
  @useResult
  $Res call(
      {@JsonKey(name: 'attachments', readValue: readValueListObjects)
      List<Attachments>? attachments,
      @JsonKey(name: 'repliedTo', readValue: readValueObject)
      RepliedTo? repliedTo,
      @JsonKey(name: 'emojes', readValue: readValueObject) Emojes? emojes,
      String? version,
      bool? isEdited});

  $RepliedToCopyWith<$Res>? get repliedTo;
  $EmojesCopyWith<$Res>? get emojes;
}

/// @nodoc
class _$ChatMessageMetadataCopyWithImpl<$Res, $Val extends ChatMessageMetadata>
    implements $ChatMessageMetadataCopyWith<$Res> {
  _$ChatMessageMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatMessageMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? attachments = freezed,
    Object? repliedTo = freezed,
    Object? emojes = freezed,
    Object? version = freezed,
    Object? isEdited = freezed,
  }) {
    return _then(_value.copyWith(
      attachments: freezed == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<Attachments>?,
      repliedTo: freezed == repliedTo
          ? _value.repliedTo
          : repliedTo // ignore: cast_nullable_to_non_nullable
              as RepliedTo?,
      emojes: freezed == emojes
          ? _value.emojes
          : emojes // ignore: cast_nullable_to_non_nullable
              as Emojes?,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      isEdited: freezed == isEdited
          ? _value.isEdited
          : isEdited // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }

  /// Create a copy of ChatMessageMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RepliedToCopyWith<$Res>? get repliedTo {
    if (_value.repliedTo == null) {
      return null;
    }

    return $RepliedToCopyWith<$Res>(_value.repliedTo!, (value) {
      return _then(_value.copyWith(repliedTo: value) as $Val);
    });
  }

  /// Create a copy of ChatMessageMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EmojesCopyWith<$Res>? get emojes {
    if (_value.emojes == null) {
      return null;
    }

    return $EmojesCopyWith<$Res>(_value.emojes!, (value) {
      return _then(_value.copyWith(emojes: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChatMessageMetadataImplCopyWith<$Res>
    implements $ChatMessageMetadataCopyWith<$Res> {
  factory _$$ChatMessageMetadataImplCopyWith(_$ChatMessageMetadataImpl value,
          $Res Function(_$ChatMessageMetadataImpl) then) =
      __$$ChatMessageMetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'attachments', readValue: readValueListObjects)
      List<Attachments>? attachments,
      @JsonKey(name: 'repliedTo', readValue: readValueObject)
      RepliedTo? repliedTo,
      @JsonKey(name: 'emojes', readValue: readValueObject) Emojes? emojes,
      String? version,
      bool? isEdited});

  @override
  $RepliedToCopyWith<$Res>? get repliedTo;
  @override
  $EmojesCopyWith<$Res>? get emojes;
}

/// @nodoc
class __$$ChatMessageMetadataImplCopyWithImpl<$Res>
    extends _$ChatMessageMetadataCopyWithImpl<$Res, _$ChatMessageMetadataImpl>
    implements _$$ChatMessageMetadataImplCopyWith<$Res> {
  __$$ChatMessageMetadataImplCopyWithImpl(_$ChatMessageMetadataImpl _value,
      $Res Function(_$ChatMessageMetadataImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatMessageMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? attachments = freezed,
    Object? repliedTo = freezed,
    Object? emojes = freezed,
    Object? version = freezed,
    Object? isEdited = freezed,
  }) {
    return _then(_$ChatMessageMetadataImpl(
      attachments: freezed == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<Attachments>?,
      repliedTo: freezed == repliedTo
          ? _value.repliedTo
          : repliedTo // ignore: cast_nullable_to_non_nullable
              as RepliedTo?,
      emojes: freezed == emojes
          ? _value.emojes
          : emojes // ignore: cast_nullable_to_non_nullable
              as Emojes?,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      isEdited: freezed == isEdited
          ? _value.isEdited
          : isEdited // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMessageMetadataImpl implements _ChatMessageMetadata {
  const _$ChatMessageMetadataImpl(
      {@JsonKey(name: 'attachments', readValue: readValueListObjects)
      final List<Attachments>? attachments,
      @JsonKey(name: 'repliedTo', readValue: readValueObject) this.repliedTo,
      @JsonKey(name: 'emojes', readValue: readValueObject) this.emojes,
      this.version,
      this.isEdited})
      : _attachments = attachments;

  factory _$ChatMessageMetadataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageMetadataImplFromJson(json);

  final List<Attachments>? _attachments;
  @override
  @JsonKey(name: 'attachments', readValue: readValueListObjects)
  List<Attachments>? get attachments {
    final value = _attachments;
    if (value == null) return null;
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'repliedTo', readValue: readValueObject)
  final RepliedTo? repliedTo;
  @override
  @JsonKey(name: 'emojes', readValue: readValueObject)
  final Emojes? emojes;
  @override
  final String? version;
  @override
  final bool? isEdited;

  @override
  String toString() {
    return 'ChatMessageMetadata(attachments: $attachments, repliedTo: $repliedTo, emojes: $emojes, version: $version, isEdited: $isEdited)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageMetadataImpl &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            (identical(other.repliedTo, repliedTo) ||
                other.repliedTo == repliedTo) &&
            (identical(other.emojes, emojes) || other.emojes == emojes) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.isEdited, isEdited) ||
                other.isEdited == isEdited));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_attachments),
      repliedTo,
      emojes,
      version,
      isEdited);

  /// Create a copy of ChatMessageMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageMetadataImplCopyWith<_$ChatMessageMetadataImpl> get copyWith =>
      __$$ChatMessageMetadataImplCopyWithImpl<_$ChatMessageMetadataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageMetadataImplToJson(
      this,
    );
  }
}

abstract class _ChatMessageMetadata implements ChatMessageMetadata {
  const factory _ChatMessageMetadata(
      {@JsonKey(name: 'attachments', readValue: readValueListObjects)
      final List<Attachments>? attachments,
      @JsonKey(name: 'repliedTo', readValue: readValueObject)
      final RepliedTo? repliedTo,
      @JsonKey(name: 'emojes', readValue: readValueObject) final Emojes? emojes,
      final String? version,
      final bool? isEdited}) = _$ChatMessageMetadataImpl;

  factory _ChatMessageMetadata.fromJson(Map<String, dynamic> json) =
      _$ChatMessageMetadataImpl.fromJson;

  @override
  @JsonKey(name: 'attachments', readValue: readValueListObjects)
  List<Attachments>? get attachments;
  @override
  @JsonKey(name: 'repliedTo', readValue: readValueObject)
  RepliedTo? get repliedTo;
  @override
  @JsonKey(name: 'emojes', readValue: readValueObject)
  Emojes? get emojes;
  @override
  String? get version;
  @override
  bool? get isEdited;

  /// Create a copy of ChatMessageMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatMessageMetadataImplCopyWith<_$ChatMessageMetadataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Attachments _$AttachmentsFromJson(Map<String, dynamic> json) {
  return _Attachments.fromJson(json);
}

/// @nodoc
mixin _$Attachments {
  String? get name => throw _privateConstructorUsedError;
  String? get key => throw _privateConstructorUsedError;

  /// Serializes this Attachments to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Attachments
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AttachmentsCopyWith<Attachments> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttachmentsCopyWith<$Res> {
  factory $AttachmentsCopyWith(
          Attachments value, $Res Function(Attachments) then) =
      _$AttachmentsCopyWithImpl<$Res, Attachments>;
  @useResult
  $Res call({String? name, String? key});
}

/// @nodoc
class _$AttachmentsCopyWithImpl<$Res, $Val extends Attachments>
    implements $AttachmentsCopyWith<$Res> {
  _$AttachmentsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Attachments
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? key = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AttachmentsImplCopyWith<$Res>
    implements $AttachmentsCopyWith<$Res> {
  factory _$$AttachmentsImplCopyWith(
          _$AttachmentsImpl value, $Res Function(_$AttachmentsImpl) then) =
      __$$AttachmentsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? name, String? key});
}

/// @nodoc
class __$$AttachmentsImplCopyWithImpl<$Res>
    extends _$AttachmentsCopyWithImpl<$Res, _$AttachmentsImpl>
    implements _$$AttachmentsImplCopyWith<$Res> {
  __$$AttachmentsImplCopyWithImpl(
      _$AttachmentsImpl _value, $Res Function(_$AttachmentsImpl) _then)
      : super(_value, _then);

  /// Create a copy of Attachments
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? key = freezed,
  }) {
    return _then(_$AttachmentsImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AttachmentsImpl implements _Attachments {
  const _$AttachmentsImpl({this.name, this.key});

  factory _$AttachmentsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AttachmentsImplFromJson(json);

  @override
  final String? name;
  @override
  final String? key;

  @override
  String toString() {
    return 'Attachments(name: $name, key: $key)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttachmentsImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.key, key) || other.key == key));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, key);

  /// Create a copy of Attachments
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AttachmentsImplCopyWith<_$AttachmentsImpl> get copyWith =>
      __$$AttachmentsImplCopyWithImpl<_$AttachmentsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AttachmentsImplToJson(
      this,
    );
  }
}

abstract class _Attachments implements Attachments {
  const factory _Attachments({final String? name, final String? key}) =
      _$AttachmentsImpl;

  factory _Attachments.fromJson(Map<String, dynamic> json) =
      _$AttachmentsImpl.fromJson;

  @override
  String? get name;
  @override
  String? get key;

  /// Create a copy of Attachments
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AttachmentsImplCopyWith<_$AttachmentsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RepliedTo _$RepliedToFromJson(Map<String, dynamic> json) {
  return _RepliedTo.fromJson(json);
}

/// @nodoc
mixin _$RepliedTo {
  String? get id => throw _privateConstructorUsedError;
  String? get text => throw _privateConstructorUsedError;

  /// Serializes this RepliedTo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RepliedTo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RepliedToCopyWith<RepliedTo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RepliedToCopyWith<$Res> {
  factory $RepliedToCopyWith(RepliedTo value, $Res Function(RepliedTo) then) =
      _$RepliedToCopyWithImpl<$Res, RepliedTo>;
  @useResult
  $Res call({String? id, String? text});
}

/// @nodoc
class _$RepliedToCopyWithImpl<$Res, $Val extends RepliedTo>
    implements $RepliedToCopyWith<$Res> {
  _$RepliedToCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RepliedTo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? text = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RepliedToImplCopyWith<$Res>
    implements $RepliedToCopyWith<$Res> {
  factory _$$RepliedToImplCopyWith(
          _$RepliedToImpl value, $Res Function(_$RepliedToImpl) then) =
      __$$RepliedToImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? id, String? text});
}

/// @nodoc
class __$$RepliedToImplCopyWithImpl<$Res>
    extends _$RepliedToCopyWithImpl<$Res, _$RepliedToImpl>
    implements _$$RepliedToImplCopyWith<$Res> {
  __$$RepliedToImplCopyWithImpl(
      _$RepliedToImpl _value, $Res Function(_$RepliedToImpl) _then)
      : super(_value, _then);

  /// Create a copy of RepliedTo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? text = freezed,
  }) {
    return _then(_$RepliedToImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RepliedToImpl implements _RepliedTo {
  const _$RepliedToImpl({this.id, this.text});

  factory _$RepliedToImpl.fromJson(Map<String, dynamic> json) =>
      _$$RepliedToImplFromJson(json);

  @override
  final String? id;
  @override
  final String? text;

  @override
  String toString() {
    return 'RepliedTo(id: $id, text: $text)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RepliedToImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, text);

  /// Create a copy of RepliedTo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RepliedToImplCopyWith<_$RepliedToImpl> get copyWith =>
      __$$RepliedToImplCopyWithImpl<_$RepliedToImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RepliedToImplToJson(
      this,
    );
  }
}

abstract class _RepliedTo implements RepliedTo {
  const factory _RepliedTo({final String? id, final String? text}) =
      _$RepliedToImpl;

  factory _RepliedTo.fromJson(Map<String, dynamic> json) =
      _$RepliedToImpl.fromJson;

  @override
  String? get id;
  @override
  String? get text;

  /// Create a copy of RepliedTo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RepliedToImplCopyWith<_$RepliedToImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Emojes _$EmojesFromJson(Map<String, dynamic> json) {
  return _Emojes.fromJson(json);
}

/// @nodoc
mixin _$Emojes {
  List<String>? get like => throw _privateConstructorUsedError;

  /// Serializes this Emojes to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Emojes
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmojesCopyWith<Emojes> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmojesCopyWith<$Res> {
  factory $EmojesCopyWith(Emojes value, $Res Function(Emojes) then) =
      _$EmojesCopyWithImpl<$Res, Emojes>;
  @useResult
  $Res call({List<String>? like});
}

/// @nodoc
class _$EmojesCopyWithImpl<$Res, $Val extends Emojes>
    implements $EmojesCopyWith<$Res> {
  _$EmojesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Emojes
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? like = freezed,
  }) {
    return _then(_value.copyWith(
      like: freezed == like
          ? _value.like
          : like // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmojesImplCopyWith<$Res> implements $EmojesCopyWith<$Res> {
  factory _$$EmojesImplCopyWith(
          _$EmojesImpl value, $Res Function(_$EmojesImpl) then) =
      __$$EmojesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String>? like});
}

/// @nodoc
class __$$EmojesImplCopyWithImpl<$Res>
    extends _$EmojesCopyWithImpl<$Res, _$EmojesImpl>
    implements _$$EmojesImplCopyWith<$Res> {
  __$$EmojesImplCopyWithImpl(
      _$EmojesImpl _value, $Res Function(_$EmojesImpl) _then)
      : super(_value, _then);

  /// Create a copy of Emojes
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? like = freezed,
  }) {
    return _then(_$EmojesImpl(
      like: freezed == like
          ? _value._like
          : like // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EmojesImpl implements _Emojes {
  const _$EmojesImpl({final List<String>? like}) : _like = like;

  factory _$EmojesImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmojesImplFromJson(json);

  final List<String>? _like;
  @override
  List<String>? get like {
    final value = _like;
    if (value == null) return null;
    if (_like is EqualUnmodifiableListView) return _like;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Emojes(like: $like)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmojesImpl &&
            const DeepCollectionEquality().equals(other._like, _like));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_like));

  /// Create a copy of Emojes
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmojesImplCopyWith<_$EmojesImpl> get copyWith =>
      __$$EmojesImplCopyWithImpl<_$EmojesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmojesImplToJson(
      this,
    );
  }
}

abstract class _Emojes implements Emojes {
  const factory _Emojes({final List<String>? like}) = _$EmojesImpl;

  factory _Emojes.fromJson(Map<String, dynamic> json) = _$EmojesImpl.fromJson;

  @override
  List<String>? get like;

  /// Create a copy of Emojes
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmojesImplCopyWith<_$EmojesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
