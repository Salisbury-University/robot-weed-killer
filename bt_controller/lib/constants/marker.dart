import 'package:latlong2/latlong.dart';

/// MapMarker Class
/// This class sets the parameters for custom map markers
/// developed further down the line.
/// Complies with null safety standards and is very general
/// Instance types:
///      image: type(final String?)
///      title: type(final String?)
///      address: type(final String?)
///      location: type(final LatLng?)
///      rating: type(final int?)
class MapMarker {
  // final variables denote single-assignment; aka: IMMUTABLE
  // ? denotes nullable types
  // i.e.: int? a can be null, while int a cannot be null
  // avoids runtime errors when trying to call null class
  final String? image; // contains image asset
  final String? title; // title of the marker
  final String? address; // address of specified location
  final LatLng? location; // location in Latitude, Longitude format
  final int? rating; // rating (num of stars); can be null if no rating

  // Constructor to allow for instantiation outside of class
  MapMarker({
    required this.image,
    required this.title,
    required this.address,
    required this.location,
    required this.rating,
  });
}

/// mapMarkers
/// immutable list containing MapMarker objects
final mapMarkers = [
  MapMarker(
      image: 'assets/images/henson-hall.jpeg',
      title: 'Henson Hall',
      address: '1101 Camden Ave, Salisbury, MD 21801',
      location: LatLng(38.3453688, -75.6058184),
      rating: 4), // Henson Marker
  MapMarker(
      image: 'assets/images/robotics_lab.png',
      title: 'REAL Robotics Lab',
      address: '1412 S Salisbury Blvd Unit 6, Salisbury, MD 21801',
      location: LatLng(38.3397273, -75.6071585),
      rating: 5), // Robotics Lab Marker
  MapMarker(
      image: 'assets/images/tetc.jpeg',
      title: 'Teacher Education and Technology Center',
      address: '1116 S Salisbury Blvd, Salisbury, MD 21801',
      location: LatLng(38.3481614, -75.6038037),
      rating: 4), // TETC Marker
];
