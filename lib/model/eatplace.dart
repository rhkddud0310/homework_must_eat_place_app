import 'dart:typed_data';

class EatPlace {
  // Property
  int? seq;

  String name;
  String phone;
  String lat;
  String lng;

  Uint8List image;

  String estimate;
  String initdate;

  // Constructor
  EatPlace(
      {this.seq,
      required this.name,
      required this.phone,
      required this.lat,
      required this.lng,
      required this.image,
      required this.estimate,
      required this.initdate});

  // Factory
  EatPlace.fromMap(Map<String, dynamic> res)
      : seq = res['seq'],
        name = res['name'],
        phone = res['phone'],
        lat = res['lat'],
        lng = res['lng'],
        image = res['image'],
        estimate = res['estimate'],
        initdate = res['initdate'];
} // End
