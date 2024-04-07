part of 'locations.dart';

class LocationHelper {
  static final LocationHelper instance = LocationHelper._();

  factory LocationHelper() {
    return instance;
  }
  LocationHelper._();
  Future<bool> checkPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          log("message",
              error: LocationException('Location permissions are denied.'));
          throw LocationException('Location permissions are denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw LocationException('Location permissions are permanently denied.');
      }
      return true;
    } catch (e) {
      log('Error checking location permission: $e',
          name: LocationHelper.instance.toString());
      return false;
    }
  }

  Future<void> getPositionDetails() async {
    if (await checkPermission()) {
      var currentPosition = await Geolocator.getCurrentPosition();
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          currentPosition.latitude,
          currentPosition.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks.first;
          Location().updateLocation(
            city: placemark.locality ?? 'UNKNOWN',
            country: placemark.country ?? 'UNKNOWN',
            position: currentPosition,
          );
        }
      } catch (e) {
        log('Error updating location details: $e',
            name: LocationHelper.instance.toString());
      }
    }
  }

  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// the [openAppSettings] and the [openLocationSettings] are required due to
  /// package documentation (https://pub.dev/packages/geolocator#settings)
  /// Opens the application settings.
  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  Future<bool> isAppSettingsOpens() async {
    return await Geolocator.openAppSettings();
  }

  /// Enable Location (gps) service
  Future<bool> isLocationSettingsOpens() async {
    return await Geolocator.openLocationSettings();
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }
}
