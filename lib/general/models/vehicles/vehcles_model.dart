import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleModel {
  String uid;
  String numberPlate; // np
  String vin;
  String year;
  String make;
  String carModel; // retained original name
  String ownerName;
  String color;
  String uploadedBy;
  Timestamp uploadedAt;
  String imageUrl;

  VehicleModel({
    required this.uid,
    required this.numberPlate,
    required this.vin,
    required this.year,
    required this.make,
    required this.carModel,
    required this.ownerName,
    required this.color,
    required this.uploadedBy,
    required this.uploadedAt,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'numberPlate': numberPlate,
      'vin': vin,
      'year': year,
      'make': make,
      'carModel': carModel,
      'ownerName': ownerName,
      'color': color,
      'uploadedBy': uploadedBy,
      'uploadedAt': uploadedAt,
      'imageUrl': imageUrl,
    };
  }

  factory VehicleModel.fromMap(Map<String, dynamic> map) {
    return VehicleModel(
      uid: map['uid'],
      numberPlate: map['numberPlate'] ?? '',
      vin: map['vin'] ?? '',
      year: map['year'] ?? '',
      make: map['make'] ?? '',
      carModel: map['carModel'] ?? '',
      ownerName: map['ownerName'] ?? '',
      color: map['color'] ?? '',
      uploadedBy: map['uploadedBy'] ?? '',
      uploadedAt: map['uploadedAt'] ?? Timestamp.now(),
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}
