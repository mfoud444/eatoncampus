bool isPasswordValid(String password) {
  return password.length >= 6;
}

bool doPasswordsMatch(String password, String confirmPassword) {
  return password == confirmPassword;
}

bool isEmailValid(String email) {
  final RegExp regex = RegExp(r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');
  return regex.hasMatch(email);
}

