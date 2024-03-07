class OrderItem {
  final String? foodId;
  final int? quantity;
  final double? price;

  OrderItem({
    this.foodId,
    this.quantity,
    this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      foodId: json['foodId'],
      quantity: json['quantity'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foodId': foodId,
      'quantity': quantity,
      'totalPrice': price,
    };
  }
}