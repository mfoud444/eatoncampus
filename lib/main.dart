import 'package:construction/admin/screens/HomeScreenAdmin.dart';
import 'package:construction/common/colors.dart';
import 'package:construction/common/screens/auth/LoginScreen.dart';
import 'package:construction/organize/screens/HomeScreenOrgnize.dart';
import 'package:construction/person/screens/HomeScreenPerson.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'common/screens/SplashScreenPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(
          value: FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Constructors',
        theme: ThemeData(
          // ignore: prefer_const_constructors
          appBarTheme: AppBarTheme(
            color: secondaryColor,
          ),
          scaffoldBackgroundColor: appColor,
        ),
        home: SplashScreenPage(),
        routes: {
          '/person': (context) => const HomeScreenPerson(),
          '/admin': (context) => const HomeScreenAdmin(),
          '/orgnize': (context) => const HomeScreenOrgnize(),
          '/login': (context) => const LoginScreen(),
        },
      ),
    );
  }
}
