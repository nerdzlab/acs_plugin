// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'preloaded_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PreloadedAction _$PreloadedActionFromJson(Map<String, dynamic> json) {
  return _PreloadedAction.fromJson(json);
}

/// @nodoc
mixin _$PreloadedAction {
  PreloadedActionType get type => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'chatPushNotificationReceivedEvent', readValue: readValueObject)
  PushNotificationChatMessageReceivedEvent?
      get chatPushNotificationReceivedEvent =>
          throw _privateConstructorUsedError;

  /// Serializes this PreloadedAction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PreloadedAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PreloadedActionCopyWith<PreloadedAction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PreloadedActionCopyWith<$Res> {
  factory $PreloadedActionCopyWith(
          PreloadedAction value, $Res Function(PreloadedAction) then) =
      _$PreloadedActionCopyWithImpl<$Res, PreloadedAction>;
  @useResult
  $Res call(
      {PreloadedActionType type,
      @JsonKey(
          name: 'chatPushNotificationReceivedEvent', readValue: readValueObject)
      PushNotificationChatMessageReceivedEvent?
          chatPushNotificationReceivedEvent});

  $PushNotificationChatMessageReceivedEventCopyWith<$Res>?
      get chatPushNotificationReceivedEvent;
}

/// @nodoc
class _$PreloadedActionCopyWithImpl<$Res, $Val extends PreloadedAction>
    implements $PreloadedActionCopyWith<$Res> {
  _$PreloadedActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PreloadedAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? chatPushNotificationReceivedEvent = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PreloadedActionType,
      chatPushNotificationReceivedEvent: freezed ==
              chatPushNotificationReceivedEvent
          ? _value.chatPushNotificationReceivedEvent
          : chatPushNotificationReceivedEvent // ignore: cast_nullable_to_non_nullable
              as PushNotificationChatMessageReceivedEvent?,
    ) as $Val);
  }

  /// Create a copy of PreloadedAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PushNotificationChatMessageReceivedEventCopyWith<$Res>?
      get chatPushNotificationReceivedEvent {
    if (_value.chatPushNotificationReceivedEvent == null) {
      return null;
    }

    return $PushNotificationChatMessageReceivedEventCopyWith<$Res>(
        _value.chatPushNotificationReceivedEvent!, (value) {
      return _then(
          _value.copyWith(chatPushNotificationReceivedEvent: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PreloadedActionImplCopyWith<$Res>
    implements $PreloadedActionCopyWith<$Res> {
  factory _$$PreloadedActionImplCopyWith(_$PreloadedActionImpl value,
          $Res Function(_$PreloadedActionImpl) then) =
      __$$PreloadedActionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {PreloadedActionType type,
      @JsonKey(
          name: 'chatPushNotificationReceivedEvent', readValue: readValueObject)
      PushNotificationChatMessageReceivedEvent?
          chatPushNotificationReceivedEvent});

  @override
  $PushNotificationChatMessageReceivedEventCopyWith<$Res>?
      get chatPushNotificationReceivedEvent;
}

/// @nodoc
class __$$PreloadedActionImplCopyWithImpl<$Res>
    extends _$PreloadedActionCopyWithImpl<$Res, _$PreloadedActionImpl>
    implements _$$PreloadedActionImplCopyWith<$Res> {
  __$$PreloadedActionImplCopyWithImpl(
      _$PreloadedActionImpl _value, $Res Function(_$PreloadedActionImpl) _then)
      : super(_value, _then);

  /// Create a copy of PreloadedAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? chatPushNotificationReceivedEvent = freezed,
  }) {
    return _then(_$PreloadedActionImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PreloadedActionType,
      chatPushNotificationReceivedEvent: freezed ==
              chatPushNotificationReceivedEvent
          ? _value.chatPushNotificationReceivedEvent
          : chatPushNotificationReceivedEvent // ignore: cast_nullable_to_non_nullable
              as PushNotificationChatMessageReceivedEvent?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PreloadedActionImpl implements _PreloadedAction {
  const _$PreloadedActionImpl(
      {required this.type,
      @JsonKey(
          name: 'chatPushNotificationReceivedEvent', readValue: readValueObject)
      this.chatPushNotificationReceivedEvent});

  factory _$PreloadedActionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PreloadedActionImplFromJson(json);

  @override
  final PreloadedActionType type;
  @override
  @JsonKey(
      name: 'chatPushNotificationReceivedEvent', readValue: readValueObject)
  final PushNotificationChatMessageReceivedEvent?
      chatPushNotificationReceivedEvent;

  @override
  String toString() {
    return 'PreloadedAction(type: $type, chatPushNotificationReceivedEvent: $chatPushNotificationReceivedEvent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PreloadedActionImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.chatPushNotificationReceivedEvent,
                    chatPushNotificationReceivedEvent) ||
                other.chatPushNotificationReceivedEvent ==
                    chatPushNotificationReceivedEvent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, type, chatPushNotificationReceivedEvent);

  /// Create a copy of PreloadedAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PreloadedActionImplCopyWith<_$PreloadedActionImpl> get copyWith =>
      __$$PreloadedActionImplCopyWithImpl<_$PreloadedActionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PreloadedActionImplToJson(
      this,
    );
  }
}

abstract class _PreloadedAction implements PreloadedAction {
  const factory _PreloadedAction(
      {required final PreloadedActionType type,
      @JsonKey(
          name: 'chatPushNotificationReceivedEvent', readValue: readValueObject)
      final PushNotificationChatMessageReceivedEvent?
          chatPushNotificationReceivedEvent}) = _$PreloadedActionImpl;

  factory _PreloadedAction.fromJson(Map<String, dynamic> json) =
      _$PreloadedActionImpl.fromJson;

  @override
  PreloadedActionType get type;
  @override
  @JsonKey(
      name: 'chatPushNotificationReceivedEvent', readValue: readValueObject)
  PushNotificationChatMessageReceivedEvent?
      get chatPushNotificationReceivedEvent;

  /// Create a copy of PreloadedAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PreloadedActionImplCopyWith<_$PreloadedActionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
