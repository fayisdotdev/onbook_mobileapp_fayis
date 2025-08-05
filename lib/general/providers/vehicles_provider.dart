import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onbook_app/general/models/vehicles/vehcles_model.dart';

class VehicleProvider with ChangeNotifier {
  // final _firestore = FirebaseFirestore.instance;

  Future<List<VehicleModel>> fetchVehicles(String userDocId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('consumers')
        .doc(userDocId)
        .collection('vehicles')
        .get();

    return snapshot.docs
        .map((doc) => VehicleModel.fromMap(doc.data()))
        .toList();
  }

  Future<void> addVehicle(VehicleModel vehicle, String userDocId) async {
    await FirebaseFirestore.instance
        .collection('consumers')
        .doc(userDocId)
        .collection('vehicles')
        .doc(vehicle.uid)
        .set(vehicle.toMap());
  }
}
