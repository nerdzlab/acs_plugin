// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) {
  return _ChatMessage.fromJson(json);
}

/// @nodoc
mixin _$ChatMessage {
  String get id => throw _privateConstructorUsedError;
  String get sequenceId => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  ChatMessageType get type => throw _privateConstructorUsedError;
  String get createdOn => throw _privateConstructorUsedError;
  @JsonKey(name: 'content', readValue: readValueObject)
  ChatMessageContent? get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'sender', readValue: readValueObject)
  CommunicationIdentifier? get sender => throw _privateConstructorUsedError;
  String? get senderDisplayName => throw _privateConstructorUsedError;
  String? get editedOn => throw _privateConstructorUsedError;
  String? get deletedOn => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this ChatMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatMessageCopyWith<ChatMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageCopyWith<$Res> {
  factory $ChatMessageCopyWith(
          ChatMessage value, $Res Function(ChatMessage) then) =
      _$ChatMessageCopyWithImpl<$Res, ChatMessage>;
  @useResult
  $Res call(
      {String id,
      String sequenceId,
      String version,
      ChatMessageType type,
      String createdOn,
      @JsonKey(name: 'content', readValue: readValueObject)
      ChatMessageContent? content,
      @JsonKey(name: 'sender', readValue: readValueObject)
      CommunicationIdentifier? sender,
      String? senderDisplayName,
      String? editedOn,
      String? deletedOn,
      Map<String, dynamic>? metadata});

  $ChatMessageContentCopyWith<$Res>? get content;
  $CommunicationIdentifierCopyWith<$Res>? get sender;
}

/// @nodoc
class _$ChatMessageCopyWithImpl<$Res, $Val extends ChatMessage>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sequenceId = null,
    Object? version = null,
    Object? type = null,
    Object? createdOn = null,
    Object? content = freezed,
    Object? sender = freezed,
    Object? senderDisplayName = freezed,
    Object? editedOn = freezed,
    Object? deletedOn = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sequenceId: null == sequenceId
          ? _value.sequenceId
          : sequenceId // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ChatMessageType,
      createdOn: null == createdOn
          ? _value.createdOn
          : createdOn // ignore: cast_nullable_to_non_nullable
              as String,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as ChatMessageContent?,
      sender: freezed == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as CommunicationIdentifier?,
      senderDisplayName: freezed == senderDisplayName
          ? _value.senderDisplayName
          : senderDisplayName // ignore: cast_nullable_to_non_nullable
              as String?,
      editedOn: freezed == editedOn
          ? _value.editedOn
          : editedOn // ignore: cast_nullable_to_non_nullable
              as String?,
      deletedOn: freezed == deletedOn
          ? _value.deletedOn
          : deletedOn // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatMessageContentCopyWith<$Res>? get content {
    if (_value.content == null) {
      return null;
    }

    return $ChatMessageContentCopyWith<$Res>(_value.content!, (value) {
      return _then(_value.copyWith(content: value) as $Val);
    });
  }

  /// Create a copy of ChatMessage
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
abstract class _$$ChatMessageImplCopyWith<$Res>
    implements $ChatMessageCopyWith<$Res> {
  factory _$$ChatMessageImplCopyWith(
          _$ChatMessageImpl value, $Res Function(_$ChatMessageImpl) then) =
      __$$ChatMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String sequenceId,
      String version,
      ChatMessageType type,
      String createdOn,
      @JsonKey(name: 'content', readValue: readValueObject)
      ChatMessageContent? content,
      @JsonKey(name: 'sender', readValue: readValueObject)
      CommunicationIdentifier? sender,
      String? senderDisplayName,
      String? editedOn,
      String? deletedOn,
      Map<String, dynamic>? metadata});

  @override
  $ChatMessageContentCopyWith<$Res>? get content;
  @override
  $CommunicationIdentifierCopyWith<$Res>? get sender;
}

/// @nodoc
class __$$ChatMessageImplCopyWithImpl<$Res>
    extends _$ChatMessageCopyWithImpl<$Res, _$ChatMessageImpl>
    implements _$$ChatMessageImplCopyWith<$Res> {
  __$$ChatMessageImplCopyWithImpl(
      _$ChatMessageImpl _value, $Res Function(_$ChatMessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sequenceId = null,
    Object? version = null,
    Object? type = null,
    Object? createdOn = null,
    Object? content = freezed,
    Object? sender = freezed,
    Object? senderDisplayName = freezed,
    Object? editedOn = freezed,
    Object? deletedOn = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$ChatMessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sequenceId: null == sequenceId
          ? _value.sequenceId
          : sequenceId // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ChatMessageType,
      createdOn: null == createdOn
          ? _value.createdOn
          : createdOn // ignore: cast_nullable_to_non_nullable
              as String,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as ChatMessageContent?,
      sender: freezed == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as CommunicationIdentifier?,
      senderDisplayName: freezed == senderDisplayName
          ? _value.senderDisplayName
          : senderDisplayName // ignore: cast_nullable_to_non_nullable
              as String?,
      editedOn: freezed == editedOn
          ? _value.editedOn
          : editedOn // ignore: cast_nullable_to_non_nullable
              as String?,
      deletedOn: freezed == deletedOn
          ? _value.deletedOn
          : deletedOn // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMessageImpl implements _ChatMessage {
  const _$ChatMessageImpl(
      {required this.id,
      required this.sequenceId,
      required this.version,
      required this.type,
      required this.createdOn,
      @JsonKey(name: 'content', readValue: readValueObject) this.content,
      @JsonKey(name: 'sender', readValue: readValueObject) this.sender,
      this.senderDisplayName,
      this.editedOn,
      this.deletedOn,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$ChatMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageImplFromJson(json);

  @override
  final String id;
  @override
  final String sequenceId;
  @override
  final String version;
  @override
  final ChatMessageType type;
  @override
  final String createdOn;
  @override
  @JsonKey(name: 'content', readValue: readValueObject)
  final ChatMessageContent? content;
  @override
  @JsonKey(name: 'sender', readValue: readValueObject)
  final CommunicationIdentifier? sender;
  @override
  final String? senderDisplayName;
  @override
  final String? editedOn;
  @override
  final String? deletedOn;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ChatMessage(id: $id, sequenceId: $sequenceId, version: $version, type: $type, createdOn: $createdOn, content: $content, sender: $sender, senderDisplayName: $senderDisplayName, editedOn: $editedOn, deletedOn: $deletedOn, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sequenceId, sequenceId) ||
                other.sequenceId == sequenceId) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.createdOn, createdOn) ||
                other.createdOn == createdOn) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.senderDisplayName, senderDisplayName) ||
                other.senderDisplayName == senderDisplayName) &&
            (identical(other.editedOn, editedOn) ||
                other.editedOn == editedOn) &&
            (identical(other.deletedOn, deletedOn) ||
                other.deletedOn == deletedOn) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      sequenceId,
      version,
      type,
      createdOn,
      content,
      sender,
      senderDisplayName,
      editedOn,
      deletedOn,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      __$$ChatMessageImplCopyWithImpl<_$ChatMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageImplToJson(
      this,
    );
  }
}

abstract class _ChatMessage implements ChatMessage {
  const factory _ChatMessage(
      {required final String id,
      required final String sequenceId,
      required final String version,
      required final ChatMessageType type,
      required final String createdOn,
      @JsonKey(name: 'content', readValue: readValueObject)
      final ChatMessageContent? content,
      @JsonKey(name: 'sender', readValue: readValueObject)
      final CommunicationIdentifier? sender,
      final String? senderDisplayName,
      final String? editedOn,
      final String? deletedOn,
      final Map<String, dynamic>? metadata}) = _$ChatMessageImpl;

  factory _ChatMessage.fromJson(Map<String, dynamic> json) =
      _$ChatMessageImpl.fromJson;

  @override
  String get id;
  @override
  String get sequenceId;
  @override
  String get version;
  @override
  ChatMessageType get type;
  @override
  String get createdOn;
  @override
  @JsonKey(name: 'content', readValue: readValueObject)
  ChatMessageContent? get content;
  @override
  @JsonKey(name: 'sender', readValue: readValueObject)
  CommunicationIdentifier? get sender;
  @override
  String? get senderDisplayName;
  @override
  String? get editedOn;
  @override
  String? get deletedOn;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
