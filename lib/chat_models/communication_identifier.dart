import 'package:acs_plugin/chat_models/identifier_kind.dart';

class CommunicationIdentifier {
  final String rawId;
  final IdentifierKind kind;

  CommunicationIdentifier({
    required this.rawId,
    required this.kind,
  });

  Map<String, dynamic> toJson() {
    return {
      'rawId': rawId,
      'kind': kind.toJson(),
    };
  }

  static CommunicationIdentifier fromJson(Map<String, dynamic> json) {
    return CommunicationIdentifier(
      rawId: json['rawId'],
      kind: IdentifierKind.fromJson(json['kind']),
    );
  }
}
