import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  Map<String, dynamic>? userData;

  bool isLoading = true;

AuthProvider() {
  // 🔥 Mark loading at the very beginning
  isLoading = true;
  notifyListeners();

  _auth.authStateChanges().listen((user) async {
    _user = user;
    if (_user != null) {
      await _fetchUserData();
    } else {
      userData = null;
    }
    // ✅ Done loading
    isLoading = false;
    notifyListeners();
  });
}


  User? get user => _user;
  bool get isLoggedIn => _user != null;

  Future<void> signOut() async {
    await _auth.signOut();
    userData = null;
    notifyListeners();
  }

  // ✅ Signup Method
  Future<void> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user?.uid;
      final docId = '${name.trim()}-${email.trim()}-${phone.trim()}'
          .replaceAll(' ', '-')
          .toLowerCase();

      final data = {
        'uid': uid,
        'name': name.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
        'role': 'consumer',
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('consumers').doc(docId).set(data);
      userData = data;

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // ✅ Login Method
  Future<void> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if user exists in consumers collection
      final query = await _firestore
          .collection('consumers')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        await _auth.signOut();
        throw Exception('No user account found for this email.');
      }

      userData = query.docs.first.data();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // ✅ Load consumer user data from Firestore
  Future<void> _fetchUserData() async {
    if (_user == null) return;

    final query = await _firestore
        .collection('consumers')
        .where('email', isEqualTo: _user!.email)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      userData = query.docs.first.data();
    } else {
      userData = null;
    }
  }
}
