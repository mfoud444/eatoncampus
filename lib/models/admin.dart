class Admin {
final String? name;
final String? email;
 final String? password;
   final bool? isAdmin;


Admin({
this.name,
 this.password,
this.email,
this.isAdmin = true,
 
});
 factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      name: json['full_name'] as String,
      email: json['email'] as String,
    );
  }
Map<String, dynamic> toJson() {
return {
'name': name,
'email': email,
'isAdmin': isAdmin,
};
}
}