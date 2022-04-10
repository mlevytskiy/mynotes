
import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/views/notes/new_note_view.dart';

import 'constants/routes.dart';
import 'views/login_view.dart';
import 'views/notes/notes_view.dart';
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
        loginRoute : (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        newNoteRoute: (context) => const NewNoteView(),
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
          future: AuthService.firebase().initialize(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final user = AuthService.firebase().currentUser;
                if (user == null) {
                  navToWidget(context, const LoginView());
                } else if (user.isEmailVerified) {
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
