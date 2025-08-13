import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onbook_app/general/providers/auth_provider.dart';
import 'package:onbook_app/general/providers/shop_provider.dart';
import 'package:onbook_app/general/models/vehicles/vehcles_model.dart';

class BookingProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  /// Save booking data to Firestore under "booked_services"
  Future<void> createBooking({
    required AuthProvider authProvider,
    required ShopPublicProvider shopProvider,
    required DateTime date,
    required String timeSlot,
    required List<String> services,
    required String notes,
    required VehicleModel vehicle,
  }) async {
    if (!authProvider.isLoggedIn) {
      throw Exception("User not logged in");
    }
    if (shopProvider.shop == null) {
      throw Exception("No shop selected");
    }

    _isSaving = true;
    notifyListeners();

    try {
      final userData = authProvider.userData!;
      final shopData = shopProvider.shop!;

      final bookingData = {
        "bookedBy": {
          "uid": userData["uid"],
          "docId": userData["docId"],
          "name": userData["name"],
          "email": userData["email"],
          "phone": userData["phone"],
        },
        "shop": {
          "shopId": shopData.shopId,
          "name": shopData.shopName,
          "email": shopData.shopEmail,
          "address": shopData.address1,
          "city": shopData.city,
        },
        "bookingDetails": {
          "date": Timestamp.fromDate(date),
          "timeSlot": timeSlot,
          "services": services,
          "notes": notes,
        },
        "vehicle": vehicle.toMap(),
        "createdAt": FieldValue.serverTimestamp(),
      };

      // Add new document in booked_services collection
      await _firestore.collection("booked_services").add(bookingData);
    } catch (e) {
      debugPrint("🔥 Error creating booking: $e");
      rethrow;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
