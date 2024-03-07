import 'package:construction/common/screens/SplashScreenPage.dart';
import 'package:construction/common/widgets/CustomIconButton.dart';
import 'package:construction/common/widgets/CustomTextField.dart';
import 'package:construction/common/widgets/snackbar_helper.dart';
import 'package:construction/services/authService.dart';
import 'package:construction/common/validation_functions.dart';
import 'package:flutter/material.dart';
import 'package:construction/models/organize.dart';
import 'package:construction/services/organizeService.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as Path;
import 'dart:io';

class SignUpFormOrganize extends StatefulWidget {
  final String type;
  const SignUpFormOrganize({
    super.key,
    required this.type,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SignUpFormOrganizeState createState() => _SignUpFormOrganizeState();
}

class _SignUpFormOrganizeState extends State<SignUpFormOrganize> {
  final _formKey = GlobalKey<FormState>();
  late final OrganizeService _restaurantService;

  @override
  void initState() {
    super.initState();
    _restaurantService = OrganizeService(widget.type);
  }

  final AuthService _firebaseService = AuthService();
  late String _name;
  late String _openingTime;
  late double _latitude;
  late double _longitude;
  File? _picture;
  late String _pictureUrl;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  late String _email;
  late String _password;
  late String _confirmPassword;
  bool _obscureText = true;
  bool _obscureTextconfirm = true;

  _selectPicture() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _picture = File(pickedFile!.path);
    });
  }

  _uploadPicture() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String fileName = Path.basename(_picture!.path);
      Reference reference = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = reference.putFile(_picture!);
      TaskSnapshot snapshot = await uploadTask;
      _pictureUrl = await snapshot.ref.getDownloadURL();
    } catch (e) {
      setState(() {
        _isLoading = false;
        showErrorSnackBar(context, e.toString());
      });
    }
  }

  _registrationRestaurant() async {
    String type = widget.type;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_password == _confirmPassword) {
        setState(() {
          //  _errorMessage = "";
          _isLoading = true;
        });
        await _uploadPicture();
        final restaurant = Organize(
          name: _name,
          email: _email,
          password: _password,
          picture: _pictureUrl,
          openingTime: _openingTime,
          latitude: _latitude,
          longitude: _longitude,
        );
        await _firebaseService.signUpOrganize(context, restaurant, type);
        setState(() {
          _isLoading = false;
        });
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SplashScreenPage(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          CustomTextField(
            keyboardType: TextInputType.text,
            iconPrefix: Icons.person,
            label: 'Name',
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
            onSaved: (value) => _name = value!,
          ),

          const SizedBox(height: 10.0),

          CustomTextField(
            keyboardType: TextInputType.text,
            iconPrefix: Icons.punch_clock_outlined,
            label: 'Opening Time',
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter an opening time';
              }
              return null;
            },
            onSaved: (value) => _openingTime = value!,
          ),

          const SizedBox(height: 10),

          const SizedBox(height: 10),
          CustomTextField(
            keyboardType: TextInputType.number,
            iconPrefix: Icons.location_city,
            label: 'Latitude',
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter the latitude';
              }
              return null;
            },
            onSaved: (value) => _latitude = double.parse(value!),
          ),

          const SizedBox(height: 10),

          CustomTextField(
            keyboardType: TextInputType.number,
            iconPrefix: Icons.location_city_outlined,
            label: 'Longitude',
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter the longitude';
              }
              return null;
            },
            onSaved: (value) => _longitude = double.parse(value!),
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
          // ignore: unnecessary_null_comparison
          if (_picture == null)
            CustomIconButton(
              label: 'Select Picture',
              icon: Icons.image,
              onPressed: _selectPicture,
              isLoading: _isLoading,
            )
          else
            Image.file(_picture!),
          const SizedBox(height: 10.0),
          const SizedBox(height: 10.0),

          CustomIconButton(
            label: 'Send',
            icon: Icons.send,
            onPressed: _registrationRestaurant,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}
