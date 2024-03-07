class Food {
  String? foodId;
  final String? name;
  final double? price;
  final String? picture;
  final String? category;
  late final String? restaurantId;

  Food({
    this.foodId,
    this.name,
    this.price,
    this.picture,
    this.category,
    this.restaurantId,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      foodId: json['foodId'],
      name: json['name'],
      price: json['price'],
      picture: json['picture'],
      category: json['category'],
      restaurantId: json['restaurantId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foodId': foodId,
      'name': name,
      'price': price,
      'picture': picture,
      'category': category,
      'restaurantId': restaurantId,
    };
  }
}
