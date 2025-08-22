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

  void setShop(ShopPublicModel shop) {
    _shop = shop;
    notifyListeners();
  }

  /// Centralized serviceDocId sanitizer
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

  /// Create booking
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

      final rawServiceName =
          "${vehicle.numberPlate}_${DateFormat('yyyy-MM-dd').format(date)}_$timeSlot-${services.join('_')}";
      final serviceDocId = sanitizeDocId(rawServiceName);

      final bookingData = {
        "serviceName": serviceName,
        "serviceDocId": serviceDocId, // 👈 store docId explicitly

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

      final bookingRef = _firestore
          .collection("consumers")
          .doc(userData["docId"])
          .collection("bookings")
          .doc(serviceDocId);

      final shopBookingRef = _firestore
          .collection("shops")
          .doc(shopData.shopId)
          .collection("bookings")
          .doc(serviceDocId);

      // 🔍 Improved duplicate booking check
      final duplicateQuery = await _firestore
          .collection("consumers")
          .doc(userData["docId"])
          .collection("bookings")
          .where("vehicle.numberPlate", isEqualTo: vehicle.numberPlate)
          .where("bookingDetails.date", isEqualTo: Timestamp.fromDate(date))
          .where("bookingDetails.timeSlot", isEqualTo: timeSlot)
          .get();

      final activeDuplicates = duplicateQuery.docs.where((doc) {
        final data = doc.data();
        // 👇 if field missing, treat as active
        if (!data.containsKey("isDeleted")) return true;
        return data["isDeleted"] != true; // false or null = active
      }).toList();

      if (activeDuplicates.isNotEmpty) {
        _errorMessage =
            "You already have a booking for this vehicle at this time.";
        _isSaving = false;
        notifyListeners();
        return false;
      }

      // ✅ Save booking because no duplicate found
      await Future.wait([
        bookingRef.set(bookingData), // Save under consumer
        shopBookingRef.set(bookingData), // Save under shop
      ]);

      debugPrint("✅ Booking created with ID: $serviceDocId");
      _errorMessage = null;
      notifyListeners();

      return true;
    } catch (e) {
      debugPrint("🔥 Error creating booking: $e");
      _errorMessage = "Failed to create booking.";
      notifyListeners();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  /// Fetch bookings for logged-in user
  Future<List<Map<String, dynamic>>> fetchBookings(
    AuthProvider authProvider,
  ) async {
    if (!authProvider.isLoggedIn) {
      _errorMessage = "User not logged in";
      notifyListeners();
      return [];
    }

    try {
      final userData = authProvider.userData!;

      final querySnapshot = await _firestore
          .collection("consumers")
          .doc(userData["docId"])
          .collection("bookings")
          .orderBy("bookingDetails.date", descending: false)
          .get();

      // Explicitly exclude deleted bookings
      final bookings = querySnapshot.docs.map((doc) => doc.data()).where((
        data,
      ) {
        final isDeleted = data["isDeleted"] as bool?;
        return isDeleted == null || isDeleted == false; // only active
      }).toList();

      debugPrint("📥 Fetched ${bookings.length} active bookings for user");

      _errorMessage = null;
      notifyListeners();
      return bookings;
    } catch (e) {
      debugPrint("🔥 Error fetching bookings: $e");
      _errorMessage = "Failed to fetch bookings.";
      notifyListeners();
      return [];
    }
  }

  Future<void> deleteBooking(Map<String, dynamic> booking) async {
    try {
      final bookedBy = booking['bookedBy'];
      final shop = booking['shop'];
      final serviceDocId = booking['serviceDocId']; // 👈 use stored id

      debugPrint(
        "🟡 Deleting from consumers/${bookedBy["docId"]}/bookings/$serviceDocId",
      );
      debugPrint(
        "🟡 Deleting from shops/${shop["shopId"]}/bookings/$serviceDocId",
      );

      // Mark as deleted in both consumer and shop collections
      await Future.wait([
        _firestore
            .collection("consumers")
            .doc(bookedBy["docId"])
            .collection("bookings")
            .doc(serviceDocId)
            .update({"isDeleted": true}),
        _firestore
            .collection("shops")
            .doc(shop["shopId"])
            .collection("bookings")
            .doc(serviceDocId)
            .update({"isDeleted": true}),
      ]);

      debugPrint("🗑️ Booking marked as deleted: $serviceDocId");
    } catch (e) {
      debugPrint("🔥 Error deleting booking: $e");
    }
  }
}
