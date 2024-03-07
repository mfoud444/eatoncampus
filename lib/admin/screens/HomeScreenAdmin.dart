
import 'package:construction/admin/screens/Dashboard.dart';
import 'package:construction/admin/screens/ListActivityOrgnize.dart';
import 'package:construction/admin/screens/ListActivityPerson.dart';
import 'package:construction/admin/screens/MyAccountAdminScreen.dart';
import 'package:construction/common/colors.dart';
import 'package:construction/common/screens/SettingsScreen.dart';
import 'package:construction/organize/screens/AddTableScreen.dart';
import 'package:construction/common/screens/ContactUsScreen.dart';
import 'package:construction/common/screens/auth/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:construction/services/authService.dart';

class HomeScreenAdmin extends StatefulWidget {
  const HomeScreenAdmin({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenAdminState createState() => _HomeScreenAdminState();
}

class _HomeScreenAdminState extends State<HomeScreenAdmin> {
  late int _selectedIndex = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // ignore: prefer_final_fields
  static List<Widget> _widgetOptions = <Widget>[
   Dashboard(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      if (index == 0) {
        _scaffoldKey.currentState?.openDrawer();
      } else {
        _selectedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        endDrawerEnableOpenDragGesture: false,
        body: Builder(builder: (context) {
          return Center(
            child: _widgetOptions.elementAt(_selectedIndex - 1),
          );
        }),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: appColor,
          selectedItemColor: secondaryColor,
          unselectedItemColor: Colors.grey,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.menu), // Icon for the navigation drawer
              label: 'Menu',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.food_bank),
              label: 'Dashboard',
            ),
        
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
        drawer: Builder(builder: (context) {
          return Drawer(
            child: Container(
              color: secondaryColor,
              child: ListView(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  // ignore: prefer_const_constructors
                  DrawerHeader(
                    // ignore: prefer_const_constructors
                    decoration: BoxDecoration(
                      // ignore: prefer_const_constructors
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: const AssetImage("images/logo.png"),
                      ),
                    ),
                    padding: const EdgeInsets.all(0),

                    child: null,
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.account_circle,
                            color: Colors.white,
                          ),
                          title: const Text(
                            'My Account',
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            // Navigate to the MyAccount screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MyAccountAdminScreen(),
                              ),
                            );
                          },
                        ),
                              const Divider(
                          thickness: 1,
                          height: 10,
                          color: Colors.grey,
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.shop_2,
                            color: Colors.white,
                          ),
                          title: const Text(
                            'Builders',
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ListActivityPerson(type:'builder'),
                              ),
                            );
                          },
                        ),
                              const Divider(
                          thickness: 1,
                          height: 10,
                          color: Colors.grey,
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.shop_2,
                            color: Colors.white,
                          ),
                          title: const Text(
                            'Contractor',
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ListActivityOrgnize(type:'contractor'),
                              ),
                            );
                          },
                        ),
                        const Divider(
                          thickness: 1,
                          height: 10,
                          color: Colors.grey,
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.shop,
                            color: Colors.white,
                          ),
                          title: const Text(
                            'Markets',
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ListActivityOrgnize(type:'market'),
                              ),
                            );
                          },
                        ),
                 
                              const Divider(
                          thickness: 1,
                          height: 10,
                          color: Colors.grey,
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.shop_2,
                            color: Colors.white,
                          ),
                          title: const Text(
                            'Factories',
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ListActivityOrgnize(type:'factory'),
                              ),
                            );
                          },
                        ),
                   
                        const Divider(
                          thickness: 1,
                          height: 10,
                          color: Colors.grey,
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                          title: const Text(
                            'Contact Us',
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            // Navigate to the ContactUs screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ContactUsScreen(),
                              ),
                            );
                          },
                        ),
                        // const Divider(
                        //   thickness: 1,
                        //   height: 10,
                        //   color: Colors.grey,
                        // ),
                        // ListTile(
                        //   leading: const Icon(
                        //     Icons.settings,
                        //     color: Colors.white,
                        //   ),
                        //   title: const Text(
                        //     'Settings',
                        //     style: TextStyle(color: Colors.white),
                        //   ),
                        //   onTap: () {
                        //     // Navigate to the Settings screen
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => SettingsScreen(),
                        //       ),
                        //     );
                        //   },
                        // ),
                        const Divider(
                          thickness: 1,
                          height: 10,
                          color: Colors.grey,
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.exit_to_app,
                            color: Colors.white,
                          ),
                          title: const Text(
                            'Log Out',
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () async {
                            // Create an instance of the FirebaseService class
                            AuthService firebaseService = AuthService();

                            // Show a Dialog with a CircularProgressIndicator
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              // ignore: prefer_const_constructors
                              builder: (context) => Dialog(
                                child: const CircularProgressIndicator(),
                              ),
                            );

                            await firebaseService.signOut();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                        ),
                        const Divider(
                          thickness: 1,
                          height: 10,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}


