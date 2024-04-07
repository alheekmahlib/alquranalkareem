part of 'locations.dart';

class LocationException implements Exception {
  final String message;

  LocationException(this.message);

  @override
  String toString() => 'LocationServiceException: $message';
}
