class Person {
  String? id;
  final String? fullName;
  final String? email;
  final String? password;
   late bool isActive;

  Person({
    this.id,
    this.fullName,

    this.email,
    this.password,
       this.isActive = false,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
  
      email: json['email'] as String,
          isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'isActive': isActive,
      };
}
