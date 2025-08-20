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
  Future<List<Map<String, dynamic>>> fetchShopsList() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return [];

    final consumerDocId = currentUser.email!
        .trim()
        .replaceAll(' ', '-')
        .toLowerCase();

    // Fetch recent chats
    final recentChatDocs = await FirebaseFirestore.instance
        .collection('chats')
        .where('participants', arrayContains: consumerDocId)
        .orderBy('lastMessageTime', descending: true)
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

    // Fetch all shops
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
