import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'views/login_view.dart';
import 'views/notes_view.dart';
import 'views/register_view.dart';
import 'dart:developer' as devtools show log;

import 'views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const RegisterView(),
      home: const HomePage(),
      //   home: const NotesView(),
      routes: {
        '/login/' : (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
        '/notes/': (context) => const NotesView()
      }
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: FutureBuilder(
          future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final user = FirebaseAuth.instance.currentUser;
                devtools.log("user email verified=${user?.emailVerified}");
                if (user == null) {
                  navToWidget(context, const LoginView());
                } else if (user.emailVerified) {
                  navToWidget(context, const NotesView());
                } else {
                  navToWidget(context, const VerifyEmailView());
                }
                return const LoginView();
              default:
                return const CircularProgressIndicator();
            }
          }),
    );
  }
}

void nav<T>(BuildContext context, Route<T> route) {
  Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.of(context).push(route);
  },
  );
}

void navToWidget(BuildContext context, StatefulWidget sfw) {
  nav(context, MaterialPageRoute(
    builder: (context) => sfw,
  ));
}
