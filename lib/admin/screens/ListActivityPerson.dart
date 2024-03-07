import 'package:construction/models/person.dart';
import 'package:construction/services/personService.dart';
import 'package:flutter/material.dart';

class ListActivityPerson extends StatefulWidget {
  final String type;
  const ListActivityPerson({
    super.key,
    required this.type,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ListActivityPersonState createState() => _ListActivityPersonState();
}

class _ListActivityPersonState extends State<ListActivityPerson> {
  late final PersonService _personService;
  late final String type;
  @override
  void initState() {
    super.initState();
    type = widget.type;
    _personService = PersonService(widget.type);
  }

  void _updateIsActive(Person person, bool value) {
    setState(() {
      person.isActive = value;
    });
    _personService.updatepersonState(person);
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
        future: _personService.getAllpersons(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final personesData = snapshot.data;
          return ListView.builder(
            itemCount: personesData!.length,
            itemBuilder: (context, index) {
              final person = personesData[index];
              return Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 223, 197, 221),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                  backgroundImage: AssetImage('images/person.png'),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        person.fullName!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Email: ${person.email}',
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
               
                    ],
                  ),
                  trailing: Switch(
                    value: person.isActive,
                    onChanged: (value) => _updateIsActive(person, value),
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
