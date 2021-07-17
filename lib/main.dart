import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './screens/auth_screen.dart';
import './screens/chat_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlutterChat',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        backgroundColor: Colors.pink,
        accentColor: Colors.deepPurple,
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.pink,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (ctx, firebaseConnect) {
          if (firebaseConnect.connectionState == ConnectionState.waiting)
            return Center(
              child: Text("Loading, show app logo"),
            );
          if (firebaseConnect.hasError)
            return Center(
              child: Text(
                "Something went wrong!",
                style: TextStyle(
                  color: Theme.of(context).errorColor,
                ),
              ),
            );
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(
                    child: Text(
                      "Loading...",
                    ),
                  ),
                );
              }
              if (userSnapshot.hasData) {
                return ChatScreen();
              }
              return AuthScreen();
            },
          );
        },
      ),
    );
  }
}
