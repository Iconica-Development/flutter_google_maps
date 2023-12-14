import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps/src/models/exceptions.dart';
import 'package:flutter_google_maps/src/models/google_map_theme.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FlutterGoogleMap extends StatefulWidget {
  const FlutterGoogleMap({
    required this.onMapCreated,
    required this.centerPosition,
    this.initialCameraPosition,
    this.cameraTargetBounds,
    this.compassEnabled = false,
    this.rotateGesturesEnabled = false,
    this.scrollGesturesEnabled = false,
    this.zoomControlsEnabled = false,
    this.zoomGesturesEnabled = false,
    this.liteModeEnabled = false,
    this.tiltGesturesEnabled = false,
    this.myLocationEnabled = false,
    this.myLocationButtonEnabled = false,
    this.mapToolbarEnabled = false,
    this.mapType = MapType.normal,
    this.buildingsEnabled = false,
    this.indoorViewEnabled = false,
    this.trafficEnabled = false,
    this.mapStylingTheme,
    this.minMaxZoomPreference,
    this.onTap,
    this.onLongPress,
    this.onCameraMove,
    this.markers = const <Marker>{},
    super.key,
  });

  /// Callback method for when the map is ready to be used.
  ///
  /// Used to receive a [TrackTraceController] for this [FlutterGoogleMap].
  /// this [TrackTraceController] also contains the [GoogleMapController]
  final void Function(GoogleMapController) onMapCreated;

  /// The initial position of the map's camera.
  final LatLng centerPosition;

  /// Override the default initial camera position.
  final CameraPosition? initialCameraPosition;

  final bool compassEnabled;
  final bool rotateGesturesEnabled;
  final bool scrollGesturesEnabled;
  final bool liteModeEnabled;
  final bool tiltGesturesEnabled;
  final bool myLocationEnabled;
  final bool myLocationButtonEnabled;
  final bool zoomControlsEnabled;
  final bool zoomGesturesEnabled;
  final bool mapToolbarEnabled;
  final bool buildingsEnabled;
  final bool indoorViewEnabled;
  final bool trafficEnabled;
  final CameraTargetBounds? cameraTargetBounds;
  final MapType mapType;
  final GoogleMapTheme? mapStylingTheme;
  final MinMaxZoomPreference? minMaxZoomPreference;
  final Set<Marker> markers;

  final ArgumentCallback<LatLng>? onTap;
  final ArgumentCallback<LatLng>? onLongPress;
  final CameraPositionCallback? onCameraMove;

  @override
  State createState() => _FlutterGoogleMapState();
}

class _FlutterGoogleMapState extends State<FlutterGoogleMap> {
  DateTime lastRouteUpdate = DateTime.now();
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) => GoogleMap(
        gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{
          Factory<OneSequenceGestureRecognizer>(
            EagerGestureRecognizer.new,
          ),
        },
        initialCameraPosition: widget.initialCameraPosition ??
            CameraPosition(
              target: widget.centerPosition,
              zoom: 13.0,
              tilt: 0.0,
              bearing: 0.0,
            ),
        minMaxZoomPreference: widget.minMaxZoomPreference ??
            const MinMaxZoomPreference(1.0, 20.0),
        onMapCreated: _onMapCreated,
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        onCameraMove: widget.onCameraMove,
        compassEnabled: widget.compassEnabled,
        rotateGesturesEnabled: widget.rotateGesturesEnabled,
        scrollGesturesEnabled: widget.scrollGesturesEnabled,
        zoomControlsEnabled: widget.zoomControlsEnabled,
        zoomGesturesEnabled: widget.zoomGesturesEnabled,
        liteModeEnabled: widget.liteModeEnabled,
        tiltGesturesEnabled: widget.tiltGesturesEnabled,
        myLocationEnabled: widget.myLocationEnabled,
        myLocationButtonEnabled: widget.myLocationButtonEnabled,
        mapToolbarEnabled: widget.mapToolbarEnabled,
        mapType: widget.mapType,
        buildingsEnabled: widget.buildingsEnabled,
        indoorViewEnabled: widget.indoorViewEnabled,
        trafficEnabled: widget.trafficEnabled,
        markers: widget.markers,
      );

  void _onMapCreated(GoogleMapController ctr) {
    if (mounted) {
      mapController = ctr;
      widget.onMapCreated(ctr);
      if (widget.mapStylingTheme != null) {
        unawaited(
          ctr.setMapStyle(widget.mapStylingTheme!.getJson()).onError(
            (error, stackTrace) async {
              throw GoogleMapsException(error.toString());
            },
          ),
        );
      } else {
        // No theme provided so switching to default
        unawaited(
          ctr.setMapStyle(
            '[{"featureType": "poi","stylers": [{"visibility": "off"}]}]',
          ),
        );
      }
    }
  }
}
