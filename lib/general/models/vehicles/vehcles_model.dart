import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleModel {
  String uid;
  String carModel;
  String numberPlate;
  String ownerName;
  String uploadedBy;
  Timestamp uploadedAt;
  String imageUrl;

  VehicleModel({
    required this.uid,
    required this.carModel,
    required this.numberPlate,
    required this.ownerName,
    required this.uploadedBy,
    required this.uploadedAt,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'carModel': carModel,
      'numberPlate': numberPlate,
      'ownerName': ownerName,
      'uploadedBy': uploadedBy,
      'uploadedAt': uploadedAt,
      'imageUrl': imageUrl,
    };
  }

  factory VehicleModel.fromMap(Map<String, dynamic> map) {
    return VehicleModel(
      uid: map['uid'],
      carModel: map['carModel'],
      numberPlate: map['numberPlate'],
      ownerName: map['ownerName'],
      uploadedBy: map['uploadedBy'],
      uploadedAt: map['uploadedAt'],
      imageUrl: map['imageUrl'],
    );
  }
}
