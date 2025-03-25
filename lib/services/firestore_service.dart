import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch all orders from Firestore
  Future<List<Map<String, dynamic>>> getOrders() async {
    try {
      QuerySnapshot snapshot = await _db.collection('orders').get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data["id"] = doc.id; // Store document ID for future updates
        return data;
      }).toList();
    } catch (e) {
      print("Error fetching orders: $e");
      return [];
    }
  }

  // Update an order's details (e.g., setting delivery address)
  Future<void> updateOrder(String orderId, Map<String, dynamic> updates) async {
    try {
      await _db.collection('orders').doc(orderId).update(updates);
    } catch (e) {
      print("Error updating order: $e");
    }
  }
}
