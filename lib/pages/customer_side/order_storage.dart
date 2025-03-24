/* Defines format of orders, also populates orders. */

import 'package:intl/intl.dart';

class OrderStorage {
  static final OrderStorage _instance = OrderStorage._internal();
  factory OrderStorage() => _instance;

  OrderStorage._internal();

  List<Map<String, String>> orders = [];

  void addOrder(List<String> foodItems, String restaurant, String address, DateTime orderTime, String price) {
    // defines valid timestamp. Any date and time older than this cannot be selected for delivery
    DateTime window = DateTime.now().subtract(Duration(minutes: 30));
    DateTime todayAtMidnight = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    String formattedTime;
    bool isDeliverable = false; // whether or not an order can be delivered

    // if order is new, show time it was ordered. else just show date
    if (orderTime.isAfter(window) || orderTime.isAtSameMomentAs(window)) {
      formattedTime = DateFormat('h:mm a').format(orderTime);
      isDeliverable = true;
    } else if (orderTime.isAfter(todayAtMidnight) || orderTime.isAtSameMomentAs(todayAtMidnight)) {
      formattedTime = DateFormat('h:mm a').format(orderTime);
    } else {
      formattedTime = DateFormat('MMM d, yyyy').format(orderTime); // Default value if orderTime is null
    }

    orders.add({
      "foodItems": foodItems.join(" • "),
      "restaurant": restaurant,
      "address": address,
      "orderTime": formattedTime,
      "isDeliverable": isDeliverable.toString(),
      "price": price,
    });
  }
}

final orderStorage = OrderStorage();

void fillOrderStorage() {
  // Add some sample orders
  orderStorage.addOrder(
    ["Chicken Parm", "Cheese Slice"],
    "Baba's Pizza",
    "Campus Center, West Addition",
    DateTime.now().subtract(Duration(minutes: 10)), // 10 minutes ago
    "15.67",
  );

  orderStorage.addOrder(
    ["Burger", "Salad"],
    "Starbucks",
    "Campus Center, West Addition",
    DateTime.now().subtract(Duration(hours: 1)), // 1 hour ago
    "20.21",
  );

  orderStorage.addOrder(
    ["Rice Bowl", "Pita Wrap"],
    "The Halal Shack",
    "Campus Center, East Addition",
    DateTime.now().subtract(Duration(days: 5)), // 5 days ago
    "17.89",
  );
}

void main() {
  // Fill the order storage with sample data
  fillOrderStorage();
}