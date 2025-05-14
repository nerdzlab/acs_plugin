class IdentifierKind {
  static const communicationUser = 'communicationUser';
  static const phoneNumber = 'phoneNumber';
  static const microsoftTeamsUser = 'microsoftTeamsUser';
  static const microsoftTeamsApp = 'microsoftTeamsApp';
  static const unknown = 'unknown';

  final String rawValue;

  IdentifierKind(this.rawValue);

  Map<String, dynamic> toJson() {
    return {'rawValue': rawValue};
  }

  static IdentifierKind fromJson(Map<String, dynamic> json) {
    return IdentifierKind(json['rawValue']);
  }
}
