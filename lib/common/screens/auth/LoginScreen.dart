// ignore: file_names
import 'package:flutter/material.dart';
import 'SignUpScreen.dart';
import 'package:construction/common/colors.dart';
import 'package:construction/organize/screens/form/LoginFormOrganize.dart';
import 'package:construction/person/screens/form/LoginFormPerson.dart';
import 'package:construction/admin/screens/form/LoginFormAdmin.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _selectedAccountType = 'builder';
  // ignore: unused_field
  Widget _getForm() {
       switch (_selectedAccountType) {
      case 'builder':
        return const LoginFormPerson(type: 'builder');
      case 'contractor':
        return const LoginFormPerson(type: 'contractor');
      case 'admin':
        return const LoginFormAdmin();
      case 'market':
        return const LoginFormOrganize(type: 'market');
      case 'factory':
        return const LoginFormOrganize(type: 'factory');
      default:
        return const LoginFormPerson(type: 'builder');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Add the image icon
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
                'Login',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 30,
                  color: secondaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                
                    _getForm(),

                    const SizedBox(height: 10),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            // ignore: prefer_const_constructors
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign Up',
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

























// // ignore: file_names
// import 'package:construction/common/component/CustomIconButton.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:construction/common/validation_functions.dart';
// import 'package:construction/common/firebase_service.dart';
// import '../../../student/screens/HomeScreen.dart';
// import 'RegistrationScreen.dart';
// import 'package:construction/common/colors.dart';
// import 'package:construction/common/component/snackbar_helper.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   // ignore: unused_field
//   final _auth = FirebaseAuth.instance;
//   late String _universityId;
//   late String _password;
//   String _errorMessage = '';
//   bool _obscureText = true;
//   bool _isLoading = false;

//   _loginUser() async {

//  if (_formKey.currentState?.validate() ?? false) {
//                             _formKey.currentState?.save();
//                             setState(() {
//                               _errorMessage = "";
//                               _isLoading = true;
//                             });
//                             try {
//                               // await FirebaseService()
//                               //     .signIn(_universityId, _password);
//                               // ignore: use_build_context_synchronously
//                               Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => const HomeScreen(),
//                                 ),
//                               );
//                             } on FirebaseAuthException catch (e) {
//                               setState(() {
//                                 _isLoading = false;
//                                 showErrorSnackBar(
//                                     context, e.message.toString());
//                               });
//                             } on Exception catch (e) {
//                               setState(() {
//                                 _isLoading = false;
//                                 showErrorSnackBar(context, e.toString());
//                               });
//                             }
//                           }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // Add the image icon
//       body: SafeArea(
//         child: SingleChildScrollView(
//           reverse: true,
//           child: Column(
//             children: [
//               Container(
//                 width: double.infinity,
//                 height: 250,
//                 // ignore: prefer_const_constructors
//                 decoration: BoxDecoration(
//                   image: const DecorationImage(
//                     image: AssetImage(
//                       'images/logo.png',
//                     ),
//                     fit: BoxFit.cover,
//                   ),
//                   borderRadius: const BorderRadius.only(
//                     bottomLeft: Radius.circular(50),
//                     bottomRight: Radius.circular(50),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'Login',
//                 textAlign: TextAlign.left,
//                 style: TextStyle(
//                   fontSize: 30,
//                   color: secondaryColor,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 10),

//                       const SizedBox(height: 10),
//                       // ignore: unnecessary_null_comparison
//                       TextFormField(
//                         keyboardType: TextInputType.number,
//                         // ignore: prefer_const_constructors
//                         decoration: InputDecoration(
//                           prefixIcon: const Icon(Icons.school),
//                           labelText: 'University ID',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           filled: true,
//                           fillColor: Colors.grey[200],
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter your university ID';
//                           }
//                           if (!isUniversityIdValid(value)) {
//                             return 'University ID starts with the number 4';
//                           }
//                           if (!isUniversityIdValidLength(value)) {
//                             return 'Please the university ID has a length of 8';
//                           }
//                           return null;
//                         },

//                         onSaved: (value) => _universityId = value!,
//                       ),
//                       const SizedBox(height: 10),
//                       TextFormField(
//                         decoration: InputDecoration(
//                           prefixIcon: const Icon(Icons.lock),
//                           labelText: 'Password',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           filled: true,
//                           fillColor: Colors.grey[200],
//                           suffixIcon: IconButton(
//                             icon: Icon(_obscureText
//                                 ? Icons.visibility_off
//                                 : Icons.visibility),
//                             onPressed: () {
//                               setState(() {
//                                 _obscureText = !_obscureText;
//                               });
//                             },
//                           ),
//                         ),
//                         obscureText: _obscureText,
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter a password';
//                           }
//                           if (!isPasswordValid(value)) {
//                             return 'Your password must be at least 6 characters';
//                           }
//                           return null;
//                         },
//                         onSaved: (value) => _password = value!,
//                       ),

//                       const SizedBox(height: 10),             
//                       CustomIconButton(
//                         label: 'Login',
//                         icon: Icons.arrow_forward,
//                         onPressed:_loginUser,
//                         isLoading: _isLoading,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Positioned(
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 child: TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const SignUpScreen(),
//                       ),
//                     );
//                   },
//                   child: RichText(
//                     text: TextSpan(
//                       text: "Don't have an account? ",
//                       // ignore: prefer_const_constructors
//                       style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                       children: [
//                         TextSpan(
//                           text: 'Sign Up',
//                           style: DefaultTextStyle.of(context).style.copyWith(
//                                 color: secondaryColor,
//                                 fontSize: 17,
//                               ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
