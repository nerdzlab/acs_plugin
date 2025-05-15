enum ChatMessageType {
  text,
  html,
  topicUpdated,
  participantAdded,
  participantRemoved,
  custom;

  static ChatMessageType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'text':
        return ChatMessageType.text;
      case 'html':
        return ChatMessageType.html;
      case 'topicupdated':
        return ChatMessageType.topicUpdated;
      case 'participantadded':
        return ChatMessageType.participantAdded;
      case 'participantremoved':
        return ChatMessageType.participantRemoved;
      default:
        return ChatMessageType.custom;
    }
  }

  String toJson() {
    switch (this) {
      case ChatMessageType.text:
        return 'text';
      case ChatMessageType.html:
        return 'html';
      case ChatMessageType.topicUpdated:
        return 'topicUpdated';
      case ChatMessageType.participantAdded:
        return 'participantAdded';
      case ChatMessageType.participantRemoved:
        return 'participantRemoved';
      case ChatMessageType.custom:
        return 'custom';
    }
  }
}
