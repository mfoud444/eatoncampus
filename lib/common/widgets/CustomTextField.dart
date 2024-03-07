// ignore: file_names
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final IconData iconPrefix;
   final IconData? iconSuffix;
  final TextInputType keyboardType; // add the keyboardType argument
  final FormFieldValidator<String> validator;
  final FormFieldSetter<String> onSaved; // add the validator argument

  const CustomTextField({
    super.key,
    required this.label,
    required this.iconPrefix,
    this.iconSuffix,
    required this.keyboardType,
    required this.validator,
    required this.onSaved, // use the validator argument // default value is TextInputType.text
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.keyboardType, // use the keyboardType argument
      decoration: InputDecoration(
        prefixIcon: Icon(widget.iconPrefix),
        suffixIcon: Icon(widget.iconSuffix),
        labelText: widget.label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      validator: widget.validator,
      onSaved: widget.onSaved, // use the validator argument
    );
  }
}
