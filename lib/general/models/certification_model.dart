import 'package:flutter/material.dart';

class CertificationModel {
  String? certificationName;
  String? certificationNumber;
  CertificationModel({
    this.certificationName,
    this.certificationNumber,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'certificationName': certificationName,
      'certificationNumber': certificationNumber,
    };
  }

  factory CertificationModel.fromMap(Map<String, dynamic> map) {
    return CertificationModel(
      certificationName: map['certificationName'] != null
          ? map['certificationName'] as String
          : null,
      certificationNumber: map['certificationNumber'] != null
          ? map['certificationNumber'] as String
          : null,
    );
  }
}

class CertificationControllerModel {
  TextEditingController certificationNameController;
  TextEditingController certificationNumberController;
  CertificationControllerModel({
    required this.certificationNameController,
    required this.certificationNumberController,
  });
}
