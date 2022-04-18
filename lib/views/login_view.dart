import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/generics/post_frame_mixin.dart';

import '../constants/routes.dart';
import '../firebase_options.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_event.dart';
import '../utilities/show_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with PostFrameMixin {
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

  void processAuthState(AuthState state) async {
    print("listener state=$state");
    if (state is AuthStateLoggedOut) {
      if (state.exception is UserNotFoundAuthException) {
        await showErrorDialog(context, 'User not found');
      } else if (state.exception is WrongPasswordAuthException) {
        await showErrorDialog(context, 'Wrong credentials');
      } else if (state.exception is GenericAuthException) {
        await showErrorDialog(context, 'Authentication error');
      }
    }
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
                    BlocListener<AuthBloc, AuthState>(
                      listenWhen: (previousState, currentState) {
                        print("previousState=$previousState ");
                        return true;
                      },
                      listener: (context, state) {
                        processAuthState(state);
                      },
                      child: TextButton(
                          onPressed: () async {
                            final email = _email.text;
                            final password = _password.text;
                            context
                                .read<AuthBloc>()
                                .add(AuthEventLogIn(email, password));
                          },
                          child: const Text('Login')),
                    ),
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
