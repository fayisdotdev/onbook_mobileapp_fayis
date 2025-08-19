import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onbook_app/general/models/vehicles/vehcles_model.dart';

class VehicleProvider with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;

  /// Fetch all vehicles for a user
  Future<List<VehicleModel>> fetchVehicles(String userDocId) async {
    final snapshot = await _firestore
        .collection('consumers')
        .doc(userDocId)
        .collection('vehicles')
        .get();

    return snapshot.docs
        .map((doc) => VehicleModel.fromMap(doc.data()))
        .toList();
  }

  /// Add a new vehicle
  Future<void> addVehicle(VehicleModel vehicle, String userDocId) async {
    await _firestore
        .collection('consumers')
        .doc(userDocId)
        .collection('vehicles')
        .doc(vehicle.uid)
        .set(vehicle.toMap());
    notifyListeners();
  }

  /// Update an existing vehicle
  Future<void> updateVehicle(VehicleModel vehicle, String userDocId) async {
    await _firestore
        .collection('consumers')
        .doc(userDocId)
        .collection('vehicles')
        .doc(vehicle.uid)
        .update(vehicle.toMap());
    notifyListeners();
  }

  /// Delete a vehicle
  Future<void> deleteVehicle(String vehicleId, String userDocId) async {
    await _firestore
        .collection('consumers')
        .doc(userDocId)
        .collection('vehicles')
        .doc(vehicleId)
        .delete();
    notifyListeners();
  }
}
