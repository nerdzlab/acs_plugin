class ACSPluginError {
  final String code;
  final String? message;
  final dynamic details;

  ACSPluginError({
    required this.code,
    this.message,
    this.details,
  });

  @override
  String toString() =>
      'ACSPluginError(code: $code, message: $message, details: $details)';
}
