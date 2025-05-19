// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message_read_receipt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatMessageReadReceipt _$ChatMessageReadReceiptFromJson(
    Map<String, dynamic> json) {
  return _ChatMessageReadReceipt.fromJson(json);
}

/// @nodoc
mixin _$ChatMessageReadReceipt {
  @JsonKey(name: 'sender', readValue: readValueObject)
  CommunicationIdentifier? get sender => throw _privateConstructorUsedError;
  String get chatMessageId => throw _privateConstructorUsedError;
  String get readOn => throw _privateConstructorUsedError;

  /// Serializes this ChatMessageReadReceipt to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatMessageReadReceipt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatMessageReadReceiptCopyWith<ChatMessageReadReceipt> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageReadReceiptCopyWith<$Res> {
  factory $ChatMessageReadReceiptCopyWith(ChatMessageReadReceipt value,
          $Res Function(ChatMessageReadReceipt) then) =
      _$ChatMessageReadReceiptCopyWithImpl<$Res, ChatMessageReadReceipt>;
  @useResult
  $Res call(
      {@JsonKey(name: 'sender', readValue: readValueObject)
      CommunicationIdentifier? sender,
      String chatMessageId,
      String readOn});

  $CommunicationIdentifierCopyWith<$Res>? get sender;
}

/// @nodoc
class _$ChatMessageReadReceiptCopyWithImpl<$Res,
        $Val extends ChatMessageReadReceipt>
    implements $ChatMessageReadReceiptCopyWith<$Res> {
  _$ChatMessageReadReceiptCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatMessageReadReceipt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sender = freezed,
    Object? chatMessageId = null,
    Object? readOn = null,
  }) {
    return _then(_value.copyWith(
      sender: freezed == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as CommunicationIdentifier?,
      chatMessageId: null == chatMessageId
          ? _value.chatMessageId
          : chatMessageId // ignore: cast_nullable_to_non_nullable
              as String,
      readOn: null == readOn
          ? _value.readOn
          : readOn // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of ChatMessageReadReceipt
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
}

/// @nodoc
abstract class _$$ChatMessageReadReceiptImplCopyWith<$Res>
    implements $ChatMessageReadReceiptCopyWith<$Res> {
  factory _$$ChatMessageReadReceiptImplCopyWith(
          _$ChatMessageReadReceiptImpl value,
          $Res Function(_$ChatMessageReadReceiptImpl) then) =
      __$$ChatMessageReadReceiptImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'sender', readValue: readValueObject)
      CommunicationIdentifier? sender,
      String chatMessageId,
      String readOn});

  @override
  $CommunicationIdentifierCopyWith<$Res>? get sender;
}

/// @nodoc
class __$$ChatMessageReadReceiptImplCopyWithImpl<$Res>
    extends _$ChatMessageReadReceiptCopyWithImpl<$Res,
        _$ChatMessageReadReceiptImpl>
    implements _$$ChatMessageReadReceiptImplCopyWith<$Res> {
  __$$ChatMessageReadReceiptImplCopyWithImpl(
      _$ChatMessageReadReceiptImpl _value,
      $Res Function(_$ChatMessageReadReceiptImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatMessageReadReceipt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sender = freezed,
    Object? chatMessageId = null,
    Object? readOn = null,
  }) {
    return _then(_$ChatMessageReadReceiptImpl(
      sender: freezed == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as CommunicationIdentifier?,
      chatMessageId: null == chatMessageId
          ? _value.chatMessageId
          : chatMessageId // ignore: cast_nullable_to_non_nullable
              as String,
      readOn: null == readOn
          ? _value.readOn
          : readOn // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMessageReadReceiptImpl implements _ChatMessageReadReceipt {
  const _$ChatMessageReadReceiptImpl(
      {@JsonKey(name: 'sender', readValue: readValueObject) this.sender,
      required this.chatMessageId,
      required this.readOn});

  factory _$ChatMessageReadReceiptImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageReadReceiptImplFromJson(json);

  @override
  @JsonKey(name: 'sender', readValue: readValueObject)
  final CommunicationIdentifier? sender;
  @override
  final String chatMessageId;
  @override
  final String readOn;

  @override
  String toString() {
    return 'ChatMessageReadReceipt(sender: $sender, chatMessageId: $chatMessageId, readOn: $readOn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageReadReceiptImpl &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.chatMessageId, chatMessageId) ||
                other.chatMessageId == chatMessageId) &&
            (identical(other.readOn, readOn) || other.readOn == readOn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sender, chatMessageId, readOn);

  /// Create a copy of ChatMessageReadReceipt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageReadReceiptImplCopyWith<_$ChatMessageReadReceiptImpl>
      get copyWith => __$$ChatMessageReadReceiptImplCopyWithImpl<
          _$ChatMessageReadReceiptImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageReadReceiptImplToJson(
      this,
    );
  }
}

abstract class _ChatMessageReadReceipt implements ChatMessageReadReceipt {
  const factory _ChatMessageReadReceipt(
      {@JsonKey(name: 'sender', readValue: readValueObject)
      final CommunicationIdentifier? sender,
      required final String chatMessageId,
      required final String readOn}) = _$ChatMessageReadReceiptImpl;

  factory _ChatMessageReadReceipt.fromJson(Map<String, dynamic> json) =
      _$ChatMessageReadReceiptImpl.fromJson;

  @override
  @JsonKey(name: 'sender', readValue: readValueObject)
  CommunicationIdentifier? get sender;
  @override
  String get chatMessageId;
  @override
  String get readOn;

  /// Create a copy of ChatMessageReadReceipt
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatMessageReadReceiptImplCopyWith<_$ChatMessageReadReceiptImpl>
      get copyWith => throw _privateConstructorUsedError;
}
