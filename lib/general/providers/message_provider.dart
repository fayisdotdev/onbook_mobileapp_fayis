import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onbook_app/general/models/shop/shop_public_model.dart';

class MessageProvider with ChangeNotifier {
  ShopPublicModel? _selectedShop;

  void setSelectedShop(ShopPublicModel shop) {
    _selectedShop = shop;
  }

  /// Get message stream for a specific chat (user's docId + shopId)
  Stream<List<Map<String, dynamic>>> getMessagesStream(String shopId) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw Exception("User not logged in");

    final consumerDocId = currentUser.email!
        .trim()
        .replaceAll(' ', '-')
        .toLowerCase();

    final chatId = _chatId(consumerDocId, shopId);

    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  /// Send a message to Firestore and update chat metadata
  Future<void> sendMessage(String messageText) async {
    if (_selectedShop == null) {
      throw Exception("No shop selected for chat");
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw Exception("User not logged in");

    final consumerDocId = currentUser.email!
        .trim()
        .replaceAll(' ', '-')
        .toLowerCase();

    final consumerDoc = await FirebaseFirestore.instance
        .collection('consumers')
        .doc(consumerDocId)
        .get();

    final senderName = consumerDoc.data()?['name'] ?? 'Unknown';

    final chatId = _chatId(consumerDocId, _selectedShop!.shopId!);

    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();

    // sanitize message (remove illegal characters for Firestore docId)
    final safeMessage = messageText.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');

    // unique custom ID: message + consumerDocId + timestamp
    final customMessageId = "${safeMessage}_${consumerDocId}_$timestamp";

    final messageData = {
      'message': messageText,
      'senderId': consumerDocId,
      'senderName': senderName,
      'timestamp': FieldValue.serverTimestamp(),
    };

    // Save message under chat with custom doc ID
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(customMessageId)
        .set(messageData);

    // Update chat metadata
    await FirebaseFirestore.instance.collection('chats').doc(chatId).set({
      'chatId': chatId,
      'shopId': _selectedShop!.shopId,
      'shopName': _selectedShop!.shopName,
      'shopCity': _selectedShop!.city,
      'shopEmail': _selectedShop!.shopEmail,
      'userDocId': consumerDocId,
      'participants': [consumerDocId, _selectedShop!.shopId],
      'lastMessage': messageText,
      'lastMessageTime': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Create a unique chatId for user and shop
  String _chatId(String userDocId, String shopId) {
    return "${userDocId}_$shopId";
  }

  /// Fetch shop list for chat screen (recent chats + all shops)
  /// Fetch shop list for chat screen (recent chats + all shops)
Future<List<Map<String, dynamic>>> fetchShopsList() async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) return [];

  final userId = currentUser.uid;

  // Step 1: Fetch all shops
  final allShopsDocs = await FirebaseFirestore.instance
      .collection('shops')
      .get();

  List<Map<String, dynamic>> recentShops = [];
  List<Map<String, dynamic>> allShops = [];

  for (var doc in allShopsDocs.docs) {
    final data = doc.data();
    final shopId = doc.id;

    // Step 2: build chatId
    final chatId = _chatId(userId, shopId);

    // Step 3: check if chat exists for this user
    final chatDoc = await FirebaseFirestore.instance
        .collection('shops')
        .doc(shopId)
        .collection('chats')
        .doc(chatId)
        .get();

    if (chatDoc.exists) {
      final chatData = chatDoc.data()!;
      recentShops.add({
        'shopId': shopId,
        'shopName': chatData['shopName'] ?? data['shopName'] ?? '',
        'city': chatData['shopCity'] ?? data['city'] ?? '',
        'email': chatData['shopEmail'] ?? data['email'] ?? '',
        'lastMessageTime': (chatData['lastMessageTime'] != null)
            ? (chatData['lastMessageTime'] as Timestamp).toDate()
            : null,
      });
    }

    // Add shop to allShops as fallback
    allShops.add({
      'shopId': shopId,
      'shopName': data['shopName'] ?? '',
      'city': data['city'] ?? '',
      'email': data['email'] ?? '',
      'lastMessageTime': null,
    });
  }

  // Step 4: Merge lists (recent chats first, then others)
  final recentIds = recentShops.map((e) => e['shopId']).toSet();
  final newShops = allShops
      .where((shop) => !recentIds.contains(shop['shopId']))
      .toList();

  return [...recentShops, ...newShops];
}

}
