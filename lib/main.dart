import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/views/forgot_password_view.dart';
import 'package:mynotes/views/notes/create_update_note_view.dart';
import 'package:mynotes/views/register_view.dart';

import 'constants/routes.dart';
import 'helpers/loading/loading_screen.dart';
import 'services/auth/bloc/auth_bloc.dart';
import 'services/auth/firebase_auth_provider.dart';
import 'views/login_view.dart';
import 'views/notes/notes_view.dart';
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
        home: BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(FirebaseAuthProvider()),
          child: const HomePage(),
        ),
        //   home: const NotesView(),
        routes: {
          createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
        });
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state.isLoading) {
        LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment');
      } else {
        LoadingScreen().hide();
      }
    }, builder: (context, state) {
      print("state=$state");
      if (state is AuthStateLoggedOut) {
        if (state.exception is GenericAuthException) {
          final GenericAuthException exc =
              state.exception as GenericAuthException;
          print("exception67=${exc.exception?.toString()}");
        } else {
          print("exception=${state.exception?.toString()}");
        }
      }
      if (state is AuthStateLoggedIn) {
        return const NotesView();
      } else if (state is AuthStateNeedVerification) {
        return const VerifyEmailView();
      } else if (state is AuthStateLoggedOut) {
        return const LoginView();
      } else if (state is AuthStateForgotPassword) {
        return const ForgotPasswordView();
      } else if (state is AuthStateRegistering) {
        return const RegisterView();
      } else {
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      }
    });
  }
}
