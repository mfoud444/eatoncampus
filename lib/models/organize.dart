class Organize {
  String? id;
  final String? name;
  final String? picture;
  final String? openingTime;
  final String? password;
  final String? email;
  final double? latitude;
  final double? longitude;
  late bool isActive;

  Organize({
    this.id,
    this.name,
    this.email,
    this.password,
    this.picture,
    this.openingTime,
    this.latitude,
    this.longitude,
    this.isActive = false,
  });

  factory Organize.fromJson(Map<String, dynamic> json) {
    return Organize(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      picture: json['picture'],
      openingTime: json['openingTime'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'picture': picture,
      'openingTime': openingTime,
      'latitude': latitude,
      'longitude': longitude,
      'isActive': isActive,
    };
  }
}
