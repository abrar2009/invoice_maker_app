import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:invoice_maker/screens/sign_in_screen.dart';

class MenuPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

  MenuPage({super.key});

  Future<void> _signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      await googleSignIn.signOut();
      // Re-initialize Google Sign-In to show the account selection pop-up
      //await googleSignIn.signIn();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const SignInPage()),
            (Route<dynamic> route) => false,
      );
    } catch (error) {
      if (kDebugMode) {
        print('Sign out failed: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //const SizedBox(height: 20),
            Expanded(
                child: ListView(
                  children: <Widget>[
                    //const Divider(thickness: 1),
                    ListTile(
                      iconColor: Colors.black,
                      leading: const Icon(Icons.people),
                      title: const Text('Customer Accounts'),
                      onTap: () {
                        Navigator.of(context).pushNamed('/manage_customers');
                      },
                    ),
                    const Divider(thickness: 1),
                    ListTile(
                      iconColor: Colors.black,
                      leading: const Icon(Icons.inventory),
                      title: const Text('Inventory Management'),
                      onTap: (){
                        Navigator.of(context).pushNamed('/inventory_management');
                      },
                    ),
                    const Divider(thickness: 1),
                    ListTile(
                      iconColor: Colors.red[900],
                      textColor: Colors.red[900],
                      leading: const Icon(Icons.logout),
                      title: const Text('Sign Out'),
                      onTap: (){
                        _signOut(context);
                      },
                    ),
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}