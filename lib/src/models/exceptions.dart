class GoogleMapsException implements Exception {
  GoogleMapsException(this.message);

  /// The unhandled [error] object.
  final String message;

  @override
  String toString() => 'Error occurred in Flutter_google_maps package:\n'
      '$message';
}
