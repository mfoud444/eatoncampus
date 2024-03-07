// ignore: file_names
import 'package:construction/admin/screens/form/LoginFormAdmin.dart';
import 'package:construction/organize/screens/form/SignUpFormOrganize.dart';
import 'package:construction/person/screens/form/SignUpFormPerson.dart';
import 'package:flutter/material.dart';
import 'LoginScreen.dart';
import 'package:construction/common/colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  var _selectedAccountType = 'builder';

  Widget _getForm() {
    switch (_selectedAccountType) {
      case 'builder':
        return const SignUpFormPerson(type: 'builder');
      case 'contractor':
        return const SignUpFormPerson(type: 'contractor');
      case 'admin':
        return const LoginFormAdmin();
      case 'market':
        return const SignUpFormOrganize(type: 'market');
      case 'factory':
        return const SignUpFormOrganize(type: 'factory');
      default:
        return const SignUpFormPerson(type: 'builder');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 250,
                // ignore: prefer_const_constructors
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage(
                      'images/logo.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Sign Up',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: secondaryColor,
                ),
              ),
// Add the dropdown for account types
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Account Type',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        prefixIcon: const Icon(Icons.account_box),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _selectedAccountType,
                        items: <String>[
                          'builder',
                          'contractor',
                          'admin',
                          'market',
                          'factory'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedAccountType = newValue!;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 10),
                    // Show the appropriate form based on the selected account type
                    _getForm(),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Already have an account? ",
                          // ignore: prefer_const_constructors
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: 'Login',
                              style:
                                  DefaultTextStyle.of(context).style.copyWith(
                                        color: secondaryColor,
                                        fontSize: 17,
                                      ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
