import 'package:construction/common/widgets/CustomDropdownButton.dart';
import 'package:construction/common/widgets/CustomIconButton.dart';
import 'package:construction/common/widgets/CustomTextField.dart';
import 'package:construction/common/widgets/snackbar_helper.dart';
import 'package:construction/models/table.dart';
import 'package:construction/services/table_services.dart';
import 'package:construction/services/userService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTableScreen extends StatefulWidget {
   AddTableScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddTableScreenState createState() => _AddTableScreenState();
}

class _AddTableScreenState extends State<AddTableScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int? _seats;
  String _state = "available";
  bool _isLoading = false;
 UserService userService = UserService();
  final TableService _tableService = TableService();

  _addTable() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        Map<String, dynamic> user = await userService.getCurrentUser();

        if (user['type'] == 'restaurant') {
          String? restaurantId = user['id'];
          await _tableService.addTable(Tables(
              seats: _seats!.toInt(),
              state: _state,
              restaurantId: restaurantId));
        }

        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } catch (e) {
        setState(() {
          _isLoading = false;
          showErrorSnackBar(context, e.toString());
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Table'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              CustomTextField(
                keyboardType: TextInputType.number,
                label: 'Seats',
                iconPrefix: Icons.people,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Please enter the number of seats';
                  }
                  return null;
                },
                onSaved: (value) => _seats = int.parse(value!),
              ),
              const SizedBox(height: 10),
              CustomDropdownButton(
                items: const ['available', 'reserved', 'unavailable'],
                label: 'State',
                iconPrefix: Icons.table_chart,
                validator: (value) {
                  if (value == null) {
                    return 'Please select the state of the table';
                  }
                  return null;
                },
                onChanged: (value) => _state = value,
                onSaved: (value) => _state = value!,
                selectedItem: _state,
              ),
              CustomIconButton(
                icon: Icons.check,
                label: 'Add Table',
                onPressed: _addTable,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
