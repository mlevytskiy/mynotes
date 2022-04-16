import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/routes.dart';
import '../firebase_options.dart';
import 'dart:developer' as devtools show log;

import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_event.dart';
import '../utilities/show_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Center(
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _email,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          const InputDecoration(hintText: 'Enter your email'),
                    ),
                    TextField(
                      controller: _password,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                          hintText: 'Enter your password'),
                    ),
                    TextButton(
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;

                          try {
                            context.read<AuthBloc>().add(AuthEventLogIn(email, password));
                          }

                          on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              await showErrorDialog(context, "User not found");
                            } else if (e.code == 'wrong-password') {
                              await showErrorDialog(
                                  context, "Wrong credentials");
                            } else {
                              await showErrorDialog(context,
                                  "firebase auth exception happened ${e.code}");
                            }
                          } catch (e) {
                            await showErrorDialog(
                                context, "Something bad happened $e");
                          }
                        },
                        child: const Text('Login')),
                    TextButton(
                        onPressed: () async {
                          Navigator.of(context)
                              .restorablePushNamedAndRemoveUntil(
                                  registerRoute, (route) => false);
                        },
                        child:
                            const Text('Not registered yet? Register here!')),
                  ],
                ),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
