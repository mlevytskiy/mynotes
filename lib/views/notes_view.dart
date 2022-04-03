

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';
import 'dart:developer' as devtools show log;

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (str) async {
              final shouldLogout = await showLogOutDialog(context);
              devtools.log(shouldLogout.toString());
              if (shouldLogout) {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).restorablePushNamedAndRemoveUntil('/login/', (route) => false);
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
        ]
      ),
    );
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

