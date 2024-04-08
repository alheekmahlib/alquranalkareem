part of 'locations.dart';

class Location {
  static final Location instance = Location._();
  String _city = '';
  String _country = '';
  Position? _position;

  factory Location() {
    return instance;
  }

  Location._();

  void updateLocation({
    required String city,
    required String country,
    required Position position,
  }) {
    _city = city;
    _country = country;
    _position = position;
  }

  String get city => _city;
  String get country => _country;
  Position? get position => _position;
}
