import 'package:flutter/material.dart';
import 'package:invoice_maker/screens/inventory_management.dart';
import 'package:invoice_maker/screens/manage_customers.dart';
import 'package:invoice_maker/screens/sign_in_screen.dart';
import 'screens/home_screen.dart';
import 'screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    MaterialColor customSwatch = const MaterialColor(
      0xFFB71C1C,
      <int, Color>{
        50: Color(0xFFE0E0E0),
        100: Color(0xFFC0C0C0),
        200: Color(0xFFA0A0A0),
        300: Color(0xFF808080),
        400: Color(0xFF606060),
        500: Color(0xFF404040),
        600: Color(0xFF202020),
        700: Color(0xFF101010),
        800: Color(0xFF080808),
        900: Color(0xFF040404),
      },
    );
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: customSwatch,
        hintColor: Colors.grey,
      ),
      debugShowCheckedModeBanner: false,
      title: 'A 1 Auto Solutions.',
      initialRoute: '/welcome_screen',
      routes: {
        '/welcome_screen': (context) => const WelcomeScreen(),
        '/sign-in': (context) => const SignInPage(),
        '/home': (context) => const HomeScreen(),
        '/manage_customers': (context) => const ManageCustomersPage(),
        '/inventory_management': (context) => const InventoryManagementPage()
      },
    );
  }
}



