import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onbook_app/general/models/shop/shop_model_enum.dart';
import 'package:onbook_app/general/models/shop/shop_public_model.dart';

class ShopPublicProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ShopPublicModel? _shop;
  ShopPublicModel? get shop => _shop;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Fetches public shop data by ID
  Future<void> fetchShop(String shopId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final doc = await _firestore.collection('shops').doc(shopId).get();

      if (doc.exists && doc.data() != null) {
        debugPrint('✅ Shop document found for ID: $shopId');
        _shop = ShopPublicModel.fromMap(doc.data()!);
      } else {
        debugPrint('❌ No shop document found for ID: $shopId');
        _shop = null;
      }
    } catch (e) {
      debugPrint('🔥 Error fetching shop for ID $shopId: $e');
      _shop = null;
    } finally {
      _isLoading = false; // ✅ ensures loading always ends
      notifyListeners();
    }
  }

  List<ShopPublicModel> _availableShops = [];
  List<ShopPublicModel> get availableShops => _availableShops;

  Future<void> fetchAllShops() async {
    _isLoading = true;
    notifyListeners();

    try {
      final querySnapshot = await _firestore.collection('shops').get();
      _availableShops = querySnapshot.docs
          .map((doc) => ShopPublicModel.fromMap(doc.data()))
          .where((shop) => shop.status == ShopStatusEnum.approved)
          .toList();
      debugPrint('📦 Fetched ${_availableShops.length} available shops.');
    } catch (e) {
      debugPrint('🔥 Error fetching available shops: $e');
      _availableShops = [];
    } finally {
      _isLoading = false; // ✅ ensures loading always ends
      notifyListeners();
    }
  }

  void clear() {
    _shop = null;
    notifyListeners();
  }

  //   Future<void> fetchAllShops() async {
  //     _isLoading = true;
  //     notifyListeners();

  //     try {
  //       final querySnapshot = await _firestore.collection('shops').get();

  //       _availableShops = querySnapshot.docs
  //           .map((doc) => ShopPublicModel.fromMap(doc.data()))
  //           .where(
  //             (shop) => shop.status == ShopStatusEnum.approved,
  //           ) // show only approved
  //           .toList();

  //       debugPrint('📦 Fetched ${_availableShops.length} available shops.');
  //     } catch (e) {
  //       debugPrint('🔥 Error fetching available shops: $e');
  //       _availableShops = [];
  //     }

  //     _isLoading = false;
  //     notifyListeners();
  //   }
}
