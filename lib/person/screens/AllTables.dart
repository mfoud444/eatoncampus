import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construction/common/colors.dart';
import 'package:construction/common/widgets/CustomIconButton.dart';
import 'package:construction/models/organize.dart';
import 'package:construction/models/table.dart';
import 'package:construction/services/table_services.dart';
import 'package:construction/person/screens/PaymentScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class TableScreen extends StatefulWidget {
  final Organize restaurant;

  TableScreen({required this.restaurant});

  @override
  _TableScreenState createState() => _TableScreenState(restaurant: restaurant);
}

class _TableScreenState extends State<TableScreen> {
  final Organize restaurant;
  bool _isLoading = false;
  _TableScreenState({required this.restaurant});

  List<Tables> _tables = [];

  @override
  void initState() {
    super.initState();
    _getTables();
  }

  Future<void> _getTables() async {
    try {
      final tables = await TableService().getTablesByRestaurant(restaurant.id!);
      setState(() {
        _tables = tables;
      });
    } catch (e) {
      print(e);
    }
  }

  void _showReservationPopup(Tables table) {
    Timestamp _tableReservationTime = Timestamp.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: appColor,
          content: Container(
            height: 400, // set the desired height value
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset("images/table.webp", height: 100, width: 100),
                const SizedBox(height: 10),
                Text('Table with ${table.seats} Seat'),
                const SizedBox(height: 10),
                FormBuilderDateTimePicker(
                  name: 'time',
                  initialValue: Timestamp.now().toDate(),
                  inputType: InputType.time,
                  decoration: const InputDecoration(
                    labelText: 'Time',
                  ),
                  onChanged: (time) {
                    _tableReservationTime = time != null
                        ? Timestamp.fromDate(time)
                        : Timestamp.now();
                  },
                ),
                const SizedBox(height: 10),
                CustomIconButton(
                  label: 'Reserve',
                  icon: Icons.arrow_forward,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentScreen(
                        restaurant: restaurant,
                        table: table,
                        tableReservationTime: _tableReservationTime,
                      ),
                    ),
                  ),
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomIconButton(
        label: 'Continue',
        icon: Icons.arrow_forward,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentScreen(
              restaurant: restaurant,
            ),
          ),
        ),
        isLoading: _isLoading,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: List.generate(_tables.length, (index) {
            final table = _tables[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  // ignore: prefer_const_literals_to_create_immutables
                  boxShadow: [
                    const BoxShadow(
                      color: Colors.white,
                      offset: Offset(5.0, 5.0),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset("images/table.webp", height: 100, width: 100),
                    const SizedBox(height: 8),
                    Text('Table with ${table.seats} Seat'),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: bottonColor,
                      ),
                      onPressed: () => _showReservationPopup(table),
                      child: const Text("Reservation"),

                      // ignore: sort_child_properties_last
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
