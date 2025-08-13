import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onbook_app/general/providers/auth_provider.dart';
import 'package:onbook_app/general/providers/shop_provider.dart';
import 'package:onbook_app/general/models/vehicles/vehcles_model.dart';

class BookingProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

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
      final userDocId = userData["docId"];

      // 📅 Format date/time for ID
      final formattedDate = DateFormat('yyyyMMdd').format(date);
      final formattedTime = timeSlot
          .replaceAll(":", "")
          .replaceAll(" ", "")
          .toLowerCase();
      final safeVehicleName =
          vehicle.carModel.replaceAll(" ", "_").toLowerCase();

      // 🆔 Booking document ID
      final bookingId = "${safeVehicleName}_${formattedDate}_${formattedTime}";

      // 📦 Booking data
      final bookingData = {
        "bookedBy": {
          "uid": userData["uid"],
          "docId": userData["docId"],
          "name": userData["name"],
          "email": userData["email"],
          "phone": userData["phone"],
        },
        "shop": {
          "shopId": shopProvider.shop!.shopId,
          "name": shopProvider.shop!.shopName,
          "email": shopProvider.shop!.shopEmail,
          "address": shopProvider.shop!.address1,
          "city": shopProvider.shop!.city,
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

      // 💾 Save booking to Firestore
      await _firestore
          .collection('consumers')
          .doc(userDocId)
          .collection('bookings')
          .doc(bookingId)
          .set(bookingData);

      debugPrint("✅ Booking saved: $bookingId");
    } catch (e) {
      debugPrint("🔥 Error creating booking: $e");
      rethrow;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
