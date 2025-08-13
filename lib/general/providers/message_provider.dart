import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onbook_app/general/models/shop/shop_public_model.dart';

class MessageProvider with ChangeNotifier {
  ShopPublicModel? _selectedShop;

  void setSelectedShop(ShopPublicModel shop) {
    _selectedShop = shop;
  }

  /// Get message stream for a specific shop
  Stream<List<Map<String, dynamic>>> getMessagesStream(String shopId) {
    if (shopId.isEmpty) {
      throw Exception("shopId cannot be empty");
    }

    return FirebaseFirestore.instance
        .collection('shops')
        .doc(shopId)
        .collection('chats')
        .doc(_chatId(shopId))
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  /// Send a message to Firestore
  Future<void> sendMessage(String messageText) async {
    if (_selectedShop == null) {
      throw Exception("No shop selected for chat");
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw Exception("User not logged in");

    // Build docId the same way AuthProvider does
    final consumerDocId = currentUser.email!
        .trim()
        .replaceAll(' ', '-')
        .toLowerCase();

    // Fetch the consumer doc to get the name
    final consumerDoc = await FirebaseFirestore.instance
        .collection('consumers')
        .doc(consumerDocId)
        .get();

    final senderName = consumerDoc.data()?['name'] ?? 'Unknown';

    final chatId = _chatId(_selectedShop!.shopId!);

    final messageData = {
      'message': messageText,
      'senderId': consumerDocId, // matching your Firestore doc ID style
      'senderName': senderName, // store the actual name
      'timestamp': FieldValue.serverTimestamp(),
    };

    // Save message under shop chat
    await FirebaseFirestore.instance
        .collection('shops')
        .doc(_selectedShop!.shopId!)
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(messageData);

    // Store chat metadata
    await FirebaseFirestore.instance
        .collection('shops')
        .doc(_selectedShop!.shopId!)
        .collection('chats')
        .doc(chatId)
        .set({
          'shopId': _selectedShop!.shopId,
          'shopName': _selectedShop!.shopName,
          'shopCity': _selectedShop!.city,
          'shopEmail': _selectedShop!.shopEmail,
          'participants': [consumerDocId, _selectedShop!.shopId],
        }, SetOptions(merge: true));
  }

  /// Create a unique chatId for user and shop
  String _chatId(String shopId) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw Exception("User not logged in");
    return "${currentUser.uid}_$shopId";
  }

  /// Fetch shop list for chat screen
  Future<List<Map<String, dynamic>>> fetchShopsList() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return [];

    final userId = currentUser.uid;

    // Fetch chats with timestamps
    final recentChatDocs = await FirebaseFirestore.instance
        .collection('chats')
        .where('participants', arrayContains: userId)
        .get();

    final recentShops = recentChatDocs.docs.map((doc) {
      final data = doc.data();
      return {
        'shopId': data['shopId'] ?? '',
        'shopName': data['shopName'] ?? '',
        'city': data['shopCity'] ?? '',
        'email': data['shopEmail'] ?? '',
        'lastMessageTime': (data['lastMessageTime'] != null)
            ? (data['lastMessageTime'] as Timestamp).toDate()
            : null,
      };
    }).toList();

    final allShopsDocs = await FirebaseFirestore.instance
        .collection('shops')
        .get();

    final allShops = allShopsDocs.docs.map((doc) {
      final data = doc.data();
      return {
        'shopId': doc.id,
        'shopName': data['shopName'] ?? '',
        'city': data['city'] ?? '',
        'email': data['email'] ?? '',
        'lastMessageTime': null,
      };
    }).toList();

    final recentIds = recentShops.map((e) => e['shopId']).toSet();
    final newShops = allShops
        .where((shop) => !recentIds.contains(shop['shopId']))
        .toList();

    return [...recentShops, ...newShops];
  }
}
