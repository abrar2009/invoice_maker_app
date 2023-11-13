import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:invoice_maker/screens/home_screen.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

  late Stream<String> dynamicTextStream;
  late StreamController<String> dynamicTextController;

  @override
  void initState(){
    super.initState();
    dynamicTextController = StreamController<String>();
    dynamicTextStream = dynamicTextController.stream;
    startTextChanging();
    checkUserSignInStatus();
  }

  void startTextChanging() {
    const texts = ["Welcome!", "Log in.", "Get started."]; // Add more texts as needed
    int currentIndex = 0;
    const Duration changeDuration = Duration(seconds: 2);

    Timer.periodic(changeDuration, (timer) {
      dynamicTextController.sink.add(texts[currentIndex]);
      currentIndex = (currentIndex + 1) % texts.length;
    });
  }

  void checkUserSignInStatus() async{
    // Check if the User is already signed in
    final User? user = _auth.currentUser;

    if(user != null){
      Future.delayed(Duration.zero, (){
      navigateToHomeScreen();
      });
    }
  }

  @override
  void dispose(){
    dynamicTextController.close();
    super.dispose();
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleSignInAuthentication =
      await googleSignInAccount?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken,
      );
      final UserCredential authResult = await _auth.signInWithCredential(credential);
      final User? user = authResult.user;
      if (kDebugMode) {
        print('Signed in with Google: ${user?.displayName}');
      }
      if(user != null){
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (error) {
      if (kDebugMode) {
        print('Google sign-in failed: $error');
      }
    }
  }

  void navigateToHomeScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: StreamBuilder<String>(
              stream: dynamicTextStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return FittedBox(
                    child: Text(
                      snapshot.data!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 40,
                      ),
                    ),
                  );
                } else {
                  return const Text('Loading...');
                }
              },
            ),
          ),
            const SizedBox(height: 80,),
            FittedBox(
              child: Text(
                'A 1 Auto Solutions.',
                style: TextStyle(
                  color: Colors.red[900],
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        const SizedBox(height: 100,),
            Container(
              width: 320,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: (){
                  _signInWithGoogle(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.transparent),
                  elevation: MaterialStateProperty.all(0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/google.png',
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 45),
                    const Text(
                        'Sign In with Google',
                        style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}