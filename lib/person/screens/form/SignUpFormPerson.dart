import 'package:construction/common/widgets/CustomIconButton.dart';
import 'package:construction/common/widgets/CustomTextField.dart';
import 'package:construction/common/widgets/snackbar_helper.dart';
import 'package:construction/services/authService.dart';
import 'package:construction/person/screens/HomeScreenPerson.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:construction/common/validation_functions.dart';
import 'package:construction/models/person.dart';

class SignUpFormPerson extends StatefulWidget {
  final String type;
  const SignUpFormPerson({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignUpFormPersonState createState() => _SignUpFormPersonState();
}

class _SignUpFormPersonState extends State<SignUpFormPerson> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _firebaseService = AuthService();
  // ignore: unused_field
  String? _fullName;
  // ignore: unused_field

  late String _email;
  late String _password;
  late String _confirmPassword;
  bool _obscureText = true;
  bool _obscureTextconfirm = true;
  bool _isLoading = false;

  _registrationUser() async {
    String type = widget.type;
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      if (_password == _confirmPassword) {
        setState(() {
          //  _errorMessage = "";
          _isLoading = true;
        });
        try {
          final student = Person(
            fullName: _fullName,
            email: _email,
            password: _password,
          );

          final authResult =
              await _firebaseService.signUpPerson(context, student, type);

          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreenPerson(),
            ),
          );
        } on FirebaseAuthException catch (e) {
          setState(() {
            _isLoading = false;
            showErrorSnackBar(context, e.message.toString());
          });
        } on Exception catch (e) {
          setState(() {
            _isLoading = false;
            showErrorSnackBar(context, e.toString());
          });
        }
      } else {
        showErrorSnackBar(context, 'Passwords do not match');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // ignore: prefer_const_constructors
          CustomTextField(
            keyboardType: TextInputType.text,
            label: 'Full Name',
            iconPrefix: Icons.person,
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
            onSaved: (value) => _fullName = value,
          ),

          const SizedBox(height: 10),
          CustomTextField(
            keyboardType: TextInputType.emailAddress,
            iconPrefix: Icons.email,
            label: 'Email',
            validator: (value) {
              if (value != null && !isEmailValid(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
            onSaved: (value) => _email = value!,
          ),
          const SizedBox(height: 10),

          TextFormField(
            // ignore: prefer_const_constructors
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: _obscureText
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility),
              ),
              labelText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
            obscureText: _obscureText,
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Please enter a password';
              }
              return null;
            },
            onSaved: (value) => _password = value!,
          ),

          const SizedBox(height: 10),
          TextFormField(
            // ignore: prefer_const_constructors
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureTextconfirm = !_obscureTextconfirm;
                  });
                },
                child: _obscureTextconfirm
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility),
              ),
              labelText: 'Confirm Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
            obscureText: _obscureTextconfirm,
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Please confirm your password';
              }
              return null;
            },
            onSaved: (value) => _confirmPassword = value!,
          ),
          const SizedBox(height: 10),

          CustomIconButton(
            label: 'Sign Up',
            icon: Icons.person_add,
            onPressed: _registrationUser,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}
