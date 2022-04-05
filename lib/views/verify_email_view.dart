

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../constants/routes.dart';
import '../firebase_options.dart';
import 'dart:developer' as devtools show log;

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Verify email'),
            actions: [
              PopupMenuButton<String>(
                onSelected: (str) async {
                  final shouldLogout = await showLogOutDialog(context);
                  devtools.log(shouldLogout.toString());
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).restorablePushNamedAndRemoveUntil(loginRoute, (route) => false);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {'Log out'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ],
        ),
        body: Column(children: [
          const Text('Please verify your email address:'),
          TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  devtools.log('user.sendEmailVerification();');
                  await user.sendEmailVerification();
                } else {
                  devtools.log('User is null');
                }
              },
              child: const Text('Send email verification'))
        ]));
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(onPressed: () {
            Navigator.of(context).pop(false);
          }, child: const Text('Cancel')),
          TextButton(onPressed: () {
            Navigator.of(context).pop(true);
          }, child: const Text('Log out')),
        ],
      );
    },
  ).then((value) => value ?? false);
}