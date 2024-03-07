import 'package:construction/common/colors.dart';
import 'package:construction/common/validation_functions.dart';
import 'package:flutter/material.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us"),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,

                  // ignore: prefer_const_constructors
                  decoration: InputDecoration(
                    labelText: "Name",
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your name";
                    }
                    return null;
                  },
                  // Add a rounded border to the TextFormField
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  validator: (value) {
                          if (value != null && !isEmailValid(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _subjectController,
                  decoration: InputDecoration(
                    labelText: "Subject",
                    prefixIcon: const Icon(Icons.subject),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a subject";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    labelText: "Message",
                    prefixIcon: const Icon(Icons.messenger),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a message";
                    }
                    return null;
                  },
                  maxLines: 4,
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: bottonColor,
                      minimumSize: const Size.fromHeight(50)),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      setState(() {
                        _isLoading = true;
                      });
                    }
                  },
                  label: const Text('Send'),
                  icon: _isLoading
                      ? Container(
                          width: 24,
                          height: 24,
                          padding: const EdgeInsets.all(2.0),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Icon(Icons.send),
                  // ignore: sort_child_properties_last
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
