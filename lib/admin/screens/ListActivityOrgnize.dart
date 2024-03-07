import 'package:construction/models/organize.dart';
import 'package:construction/services/organizeService.dart';
import 'package:flutter/material.dart';

class ListActivityOrgnize extends StatefulWidget {
  final String type;
  const ListActivityOrgnize({
    super.key,
    required this.type,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ListActivityOrgnizeState createState() => _ListActivityOrgnizeState();
}

class _ListActivityOrgnizeState extends State<ListActivityOrgnize> {
  late final OrganizeService _orgnizeService;
  late final String type;
  @override
  void initState() {
    super.initState();
    type = widget.type;
    _orgnizeService = OrganizeService(widget.type);
  }

  void _updateIsActive(Organize orgnize, bool value) {
    setState(() {
      orgnize.isActive = value;
    });
    _orgnizeService.updateOrganizeState(orgnize);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'List  $type',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder(
        future: _orgnizeService.getAllOrganizes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final orgnizesData = snapshot.data;
          return ListView.builder(
            itemCount: orgnizesData!.length,
            itemBuilder: (context, index) {
              final orgnizes = orgnizesData[index];
              return Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 223, 197, 221),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(orgnizes.picture!),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        orgnizes.name!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'OpeningTime: ${orgnizes.openingTime}',
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        'Address: ${orgnizes.latitude} , ${orgnizes.longitude}',
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                  trailing: Switch(
                    value: orgnizes.isActive,
                    onChanged: (value) => _updateIsActive(orgnizes, value),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
