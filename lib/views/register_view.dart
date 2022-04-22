import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';

import '../firebase_options.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_state.dart';
import '../utilities/generics/post_frame_mixin.dart';
import '../utilities/show_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> with PostFrameMixin {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
    final bloc = BlocProvider.of<AuthBloc>(context);

    var state = bloc.state;
    postFrame(() {
      processAuthState(state);
    });
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void processAuthState(AuthState state) async {
    if (state is AuthStateRegistering) {
      String? errorMessage;
      if (state.exception is WeakPasswordAuthException) {
        errorMessage = 'Weak password';
      } else if (state.exception is EmailAlreadyInUseAuthException) {
        errorMessage = 'Email already in use';
      } else if (state.exception is GenericAuthException) {
        errorMessage = 'Failed to register';
      } else if (state.exception is InvalidEmailAuthException) {
        errorMessage = 'Invalid email';
      }
      if (errorMessage != null) {
        await showErrorDialog(context, errorMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        processAuthState(state);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Register'),
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
                            context
                                .read<AuthBloc>()
                                .add(AuthEventRegister(email, password));
                          },
                          child: const Text('Register')),
                      TextButton(
                          onPressed: () async {
                            context.read<AuthBloc>().add(
                                  const AuthEventLogOut(),
                                );
                          },
                          child: const Text('Already registered? Login here!')),
                    ],
                  ),
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
