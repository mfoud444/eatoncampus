
class Tables {
 String? tableId;
  final int seats;
  final String state;
  final String? restaurantId;

  Tables({
    this.tableId,
    required this.seats,
    required this.state,
    this.restaurantId,
  });

  factory Tables.fromJson(Map<String, dynamic> json) {
    return Tables(
      tableId: json['tableId'],
      seats: json['seats'],
      state: json['state'],
      restaurantId: json['restaurantId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tableId': tableId,
      'seats': seats,
      'state': state,
      'restaurantId': restaurantId,
    };
  }

 
}
