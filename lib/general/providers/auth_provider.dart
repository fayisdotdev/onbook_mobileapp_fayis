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

  String? get consumerDocId {
    if (userData == null) return null;
    final email = userData!['email'] ?? '';
    return email.trim().replaceAll(' ', '-').toLowerCase();
  }

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
      final docId = email.trim().replaceAll(' ', '-').toLowerCase();
      final data = {
        'uid': uid,
        'name': name.trim(),
        'email': email.trim(),
        'password': password.trim(),
        'phone': phone.trim(),
        'docId': docId,
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

  Future<String?> changeUserPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _auth.currentUser;

      if (user == null) return "User not logged in.";

      final email = user.email;
      if (email == null) return "No email associated with account.";

      // Reauthenticate the user
      final credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);
      // ⚠️ Only for testing: update the password in Firestore
      final docId = email.trim().replaceAll(' ', '-').toLowerCase();

      await _firestore.collection('consumers').doc(docId).update({
        'password': newPassword.trim(),
      });

      return null; // success
    } on FirebaseAuthException catch (e) {
      return e.message ?? "An error occurred";
    } catch (e) {
      return "Something went wrong";
    }
  }

  Future<String?> updateUserLocation(GeoPoint geoPoint) async {
    try {
      if (userData == null) return 'User data not available';
      final docId = userData!['docId'];
      await _firestore.collection('consumers').doc(docId).update({
        'location': geoPoint,
      });
      userData!['location'] = geoPoint;
      notifyListeners();
      return null;
    } catch (e) {
      return 'Failed to update location';
    }
  }
}
