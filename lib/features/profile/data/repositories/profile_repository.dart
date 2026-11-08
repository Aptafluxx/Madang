import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:madang/core/errors/auth_exceptions.dart';

class ProfileRepository {
  ProfileRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  static const int minNameLength = 2;
  static const int maxNameLength = 40;

  Future<String> updateName(String value) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const AuthException('Please sign in again.');
    }

    final name = value.trim();
    if (name.length < minNameLength || name.length > maxNameLength) {
      throw const AuthException('Name must be 2 to 40 characters.');
    }

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({'name': name})
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw FirebaseException(
              plugin: 'cloud_firestore',
              code: 'unavailable',
            ),
          );
    } on FirebaseException catch (e) {
      throw AuthException(switch (e.code) {
        'permission-denied' => 'You do not have permission to do that.',
        'unavailable' =>
          'Network error. Please check your internet connection.',
        'not-found' => 'Profile not found. Please log out and sign in again.',
        _ => 'Could not update your profile. Please try again.',
      });
    }

    try {
      await user.updateDisplayName(name);
    } catch (_) {}

    return name;
  }
}
