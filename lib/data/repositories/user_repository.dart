import 'package:bookapin/data/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Users>> getAllCustomer() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'Customer')
          .get();

      return snapshot.docs
          .map((doc) => Users.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil data customer');
    }
  }
  Future<void> updateUserActive(
    String userId,
    bool isActive,
  ) async {
    await _firestore.collection('users').doc(userId).update({
      'isActive': isActive,
      'updatedAt': Timestamp.now(),
    });
  }
}
