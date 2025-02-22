class OrderStorage {
  static final OrderStorage _instance = OrderStorage._internal();
  factory OrderStorage() => _instance;

  OrderStorage._internal();

  List<Map<String, String>> orders = [];

  void addOrder(String foodItem, String name, String phone, String address) {
    orders.add({
      "foodItem": foodItem,
      "name": name,
      "phone": phone,
      "address": address,
    });
  }
}

final orderStorage = OrderStorage();