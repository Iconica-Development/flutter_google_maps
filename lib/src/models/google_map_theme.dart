import 'dart:convert';

/// Styling object for the Google maps Style
///
/// Contains a List of features with stylers applied to them
/// Full documentation on all the possible style:
/// https://developers.google.com/maps/documentation/javascript/style-reference
/// ```dart
///  GoogleMapTheme(
///          themes: [
///            GoogleMapThemeFeature(
///              featureType: 'poi',
///              stylers: [
///                {'visibility': 'off'},
///              ],
///            ),
///           ],
///  ),
/// ```
class GoogleMapTheme {
  GoogleMapTheme({
    required this.themes,
  });
  final List<GoogleMapThemeFeature> themes;

  String getJson() => jsonEncode(themes.map((e) => e.toJson()).toList());
}

class GoogleMapThemeFeature {
  GoogleMapThemeFeature({
    required this.stylers,
    this.featureType,
    this.elementType,
  });
  final String? featureType;
  final String? elementType;
  final List<Map<String, String>> stylers;

  Map<String, dynamic> toJson() => {
        if (featureType != null) 'featureType': featureType,
        if (elementType != null) 'elementType': elementType,
        'stylers': stylers,
      };
}

enum GoogleMapThemeFeatureType {
  featureAll,
}
