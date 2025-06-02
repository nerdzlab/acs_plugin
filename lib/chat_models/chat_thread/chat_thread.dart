import 'package:acs_plugin/chat_models/chat_message_metadata/chat_message_metadata.dart';
import 'package:acs_plugin/chat_models/communication_identifier/communication_identifier.dart';
import 'package:acs_plugin/chat_models/chat_message_type/chat_message_type.dart';
import 'package:acs_plugin/chat_models/utilities/map_helpers.dart';
import '../chat_message_content/chat_message_content.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_thread.freezed.dart';
part 'chat_thread.g.dart';

@freezed
class ChatThread with _$ChatThread {
  const factory ChatThread({
    required String id,
    required String topic,
    String? deletedOn,
    String? lastMessageReceivedOn,
  }) = _ChatThread;

  factory ChatThread.fromJson(Map<String, dynamic> json) =>
      _$ChatThreadFromJson(json);
}
