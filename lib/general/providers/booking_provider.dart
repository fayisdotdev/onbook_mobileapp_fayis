import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onbook_app/general/providers/auth_provider.dart';
import 'package:onbook_app/general/models/shop/shop_public_model.dart';
import 'package:onbook_app/general/models/vehicles/vehcles_model.dart';

class BookingProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ShopPublicModel? _shop;
  ShopPublicModel? get shop => _shop;

  /// Store the selected shop for later use in booking
  void setShop(ShopPublicModel shop) {
    _shop = shop;
    notifyListeners();
  }

  /// Save booking data to Firestore under "booked_services"
  Future<bool> createBooking({
    required AuthProvider authProvider,
    required DateTime date,
    required String timeSlot,
    required List<String> services,
    required String notes,
    required VehicleModel vehicle,
  }) async {
    if (!authProvider.isLoggedIn) {
      _errorMessage = "User not logged in";
      notifyListeners();
      return false;
    }
    if (_shop == null) {
      _errorMessage = "No shop selected";
      notifyListeners();
      return false;
    }

    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userData = authProvider.userData!;
      final shopData = _shop!;

      final serviceName =
          "${vehicle.numberPlate} - ${DateFormat('yyyy-MM-dd').format(date)} $timeSlot - $services";

      final bookingData = {
        "serviceName": serviceName,
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
          "notes": notes.trim().isEmpty ? null : notes.trim(),
        },
        "vehicle": vehicle.toMap(),
        "createdAt": FieldValue.serverTimestamp(),
      };

      String sanitizeDocId(String input) {
        String cleaned = input
            .trim()
            .replaceAll(' ', '_')
            .replaceAll('/', '-')
            .replaceAll(':', '-')
            .replaceAll(RegExp(r'[^\w\-]'), '');
        if (cleaned.isEmpty) {
          cleaned = DateTime.now().millisecondsSinceEpoch.toString();
        }
        return cleaned;
      }

      final rawServiceName =
          "${vehicle.numberPlate}_${DateFormat('yyyy-MM-dd').format(date)}_$timeSlot-${services.join('_')}";
      final serviceDocId = sanitizeDocId(rawServiceName);

      final bookingRef = _firestore
          .collection("consumers")
          .doc(userData["docId"])
          .collection("bookings")
          .doc(serviceDocId);

      final existing = await bookingRef.get();
      if (existing.exists) {
        _errorMessage =
            "You already have a booking for this vehicle at this time.";
        _isSaving = false;
        notifyListeners();
        return false;
      }

      await bookingRef.set(bookingData);

      debugPrint("✅ Booking created with ID: $serviceDocId");
      debugPrint("📦 bookingData: $bookingData");

      return true;
    } catch (e) {
      debugPrint("🔥 Error creating booking: $e");
      _errorMessage = "Failed to create booking. Please try again.";
      notifyListeners();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // // Save booking under: consumers/{userDocId}/vehicles/{vehicleId}/bookings
  // await FirebaseFirestore.instance
  //     .collection("consumers")
  //     .doc(userData["docId"])
  //     // .collection("vehicles")
  //     // .doc(vehicle.uid)
  //     .collection("bookings")
  //     .doc(serviceName)
  //     .set(bookingData);
}
