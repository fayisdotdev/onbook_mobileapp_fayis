import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onbook_app/general/models/shop/shop_public_model.dart';

class MessageProvider with ChangeNotifier {
  ShopPublicModel? _selectedShop;

  void setSelectedShop(ShopPublicModel shop) {
    _selectedShop = shop;
  }

  /// Create a unique chatId for user and shop
  String _chatId(String userDocId, String shopId) {
    return "${userDocId}_$shopId";
  }

  /// Stream messages for a chat
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

  /// Send message and update in `chats`, `shops/{shopId}/chats`, `consumers/{consumerId}/chats`
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
    final safeMessage = messageText.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    final customMessageId = "${safeMessage}_${consumerDocId}_$timestamp";

    final messageData = {
      'message': messageText,
      'senderId': consumerDocId,
      'senderType': 'consumer',
      'senderName': senderName,
      'timestamp': FieldValue.serverTimestamp(),
      'seenBy': [consumerDocId],
    };

    final chatMeta = {
      'chatId': chatId,
      'shopId': _selectedShop!.shopId,
      'shopName': _selectedShop!.shopName,
      'shopCity': _selectedShop!.city,
      'shopEmail': _selectedShop!.shopEmail,
      'consumerId': consumerDocId,
      'participants': [consumerDocId, _selectedShop!.shopId],
      'lastMessage': messageText,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'lastMessageSenderId': consumerDocId, // 👈 add this
      'lastMessageSenderName': senderName, // 👈 add this
    };

    final batch = FirebaseFirestore.instance.batch();

    // Save message in global chat
    final globalMsgRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(customMessageId);
    batch.set(globalMsgRef, messageData);

    // Update global chat metadata
    final globalChatRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId);
    batch.set(globalChatRef, chatMeta, SetOptions(merge: true));

    // Mirror under shop
    final shopChatRef = FirebaseFirestore.instance
        .collection('shops')
        .doc(_selectedShop!.shopId)
        .collection('chats')
        .doc(chatId);
    batch.set(shopChatRef, chatMeta, SetOptions(merge: true));

    // Mirror under consumer
    final consumerChatRef = FirebaseFirestore.instance
        .collection('consumers')
        .doc(consumerDocId)
        .collection('chats')
        .doc(chatId);
    batch.set(consumerChatRef, chatMeta, SetOptions(merge: true));

    await batch.commit();
  }

  /// Fetch shops list with recent chats (merged view)
  Stream<List<Map<String, dynamic>>> fetchShopsList() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Stream.empty();
    }

    final consumerDocId = currentUser.email!
        .trim()
        .replaceAll(' ', '-')
        .toLowerCase();

    final shopsStream = FirebaseFirestore.instance
        .collection('shops')
        .snapshots();

    return shopsStream.asyncMap((shopsSnapshot) async {
      final allShops = shopsSnapshot.docs.map((doc) {
        final shopData = doc.data();
        return {
          'shopId': doc.id,
          'shopName': shopData['shopName'] ?? '',
          'city': shopData['city'] ?? '',
          'email': shopData['email'] ?? '',
          'lastMessage': null,
          'lastMessageTime': null,
        };
      }).toList();

      final chatDocs = await FirebaseFirestore.instance
          .collection('consumers')
          .doc(consumerDocId)
          .collection('chats')
          .get();

      final recentShops = <Map<String, dynamic>>[];

      for (var chatDoc in chatDocs.docs) {
        final chatData = chatDoc.data();
        recentShops.add({
          'shopId': chatData['shopId'],
          'shopName': chatData['shopName'] ?? '',
          'city': chatData['shopCity'] ?? '',
          'email': chatData['shopEmail'] ?? '',
          'lastMessage': chatData['lastMessage'] ?? '',
          'lastMessageTime': (chatData['lastMessageTime'] != null)
              ? (chatData['lastMessageTime'] as Timestamp).toDate()
              : null,
        });
      }

      final recentIds = recentShops.map((e) => e['shopId']).toSet();
      final newShops = allShops
          .where((shop) => !recentIds.contains(shop['shopId']))
          .toList();

      recentShops.sort((a, b) {
        final aTime = a['lastMessageTime'] as DateTime?;
        final bTime = b['lastMessageTime'] as DateTime?;
        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1;
        if (bTime == null) return -1;
        return bTime.compareTo(aTime);
      });

      return [...recentShops, ...newShops];
    });
  }
}
