import 'package:acs_plugin/chat_models/event_type.dart';

final class Event {
  final EventType type;
  final dynamic payload;

  Event({required this.type, this.payload});

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      type: eventTypeFromString(map['event'] as String),
      payload: map['payload'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'event': type.name,
      if (payload != null) 'payload': payload,
    };
  }
}

EventType eventTypeFromString(String name) {
  return EventType.values.firstWhere(
    (e) => e.name == name,
    orElse: () => EventType.unknown,
  );
}
