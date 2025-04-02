class OrderManager {
  static final OrderManager _instance = OrderManager._internal();
  String? _orderID;

  factory OrderManager() {
    return _instance;
  }

  OrderManager._internal();

  void setOrderID(String orderID) {
    _orderID = orderID;
  }

  String? getOrderID() {
    if (_orderID != null) {
      return _orderID;
    } else {
      return "-1"; // no order
    }
  }
}
