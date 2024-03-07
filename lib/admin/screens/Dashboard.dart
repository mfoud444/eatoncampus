import 'package:construction/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:construction/services/organizeService.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late final OrganizeService _organizeService;

  @override
  void initState() {
    super.initState();
    _organizeService = OrganizeService('builder');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder<Map<String, int>>(
        future: _organizeService.getOrganizeCounts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data = snapshot.data!;
          return ListView(
            children: [
              _buildCountTile('Builder', Icons.work, data['builder'] ?? 0),
              _buildCountTile(
                  'Contractor', Icons.construction, data['contractor'] ?? 0),
              _buildCountTile(
                  'Admin', Icons.admin_panel_settings, data['admin'] ?? 0),
              _buildCountTile(
                  'Market', Icons.shopping_cart, data['market'] ?? 0),
              _buildCountTile('Factory', Icons.factory, data['factory'] ?? 0),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCountTile(String type, IconData icon, int count) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 223, 197, 221),
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: secondaryColor,
        ),
        title: Text(
          type,
          style: const TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: secondaryColor,
            fontFamily: 'Times new roman',
          ),
        ),
        subtitle: Text(
          '$count',
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: primaryColor,
            fontFamily: 'Times new roman',
          ),
        ),
      ),
    );
  }
}
