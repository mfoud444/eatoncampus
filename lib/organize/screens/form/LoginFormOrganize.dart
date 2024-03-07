// ignore: file_names
import 'package:construction/common/screens/SplashScreenPage.dart';
import 'package:construction/common/widgets/CustomIconButton.dart';
import 'package:construction/services/authService.dart';
import 'package:construction/common/widgets/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:construction/common/validation_functions.dart';
import 'package:construction/common/widgets/snackbar_helper.dart';

class LoginFormOrganize extends StatefulWidget {
     final String type;
  const LoginFormOrganize({super.key,required this.type,});

  @override
  // ignore: library_private_types_in_public_api
  _LoginFormOrganizeState createState() => _LoginFormOrganizeState();
}

class _LoginFormOrganizeState extends State<LoginFormOrganize> {
  final _formKey = GlobalKey<FormState>();
  // ignore: unused_field
  final _auth = FirebaseAuth.instance;
  late String _password;
  late String _email;
  String _errorMessage = '';
  bool _obscureText = true;
  bool _isLoading = false;

  _loginStudent() async {
          String type = widget.type;
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() {
        _errorMessage = "";
        _isLoading = true;
      });
      try {
        await AuthService().signInOrganize(context, _email, _password, type);

        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SplashScreenPage(),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return
        // Add the image icon
        Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),
              // ignore: unnecessary_null_comparison
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
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                obscureText: _obscureText,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (!isPasswordValid(value)) {
                    return 'Your password must be at least 6 characters';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),

              const SizedBox(height: 10),
              CustomIconButton(
                label: 'Login',
                icon: Icons.arrow_forward,
                onPressed: _loginStudent,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
