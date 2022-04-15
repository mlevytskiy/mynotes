import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/views/notes/create_update_note_view.dart';

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
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      }
    );
  }
}

// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home'),
//       ),
//       body: FutureBuilder(
//           future: AuthService.firebase().initialize(),
//           builder: (context, snapshot) {
//             switch (snapshot.connectionState) {
//               case ConnectionState.done:
//                 final user = AuthService.firebase().currentUser;
//                 if (user == null) {
//                   navToWidget(context, const LoginView());
//                 } else if (user.isEmailVerified) {
//                   navToWidget(context, const NotesView());
//                 } else {
//                   navToWidget(context, const VerifyEmailView());
//                 }
//                 return const LoginView();
//               default:
//                 return const CircularProgressIndicator();
//             }
//           }),
//     );
//   }
// }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => CounterBloc(),
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Testing bloc'),
            ),
            body: BlocConsumer<CounterBloc, CounterState>(
              listener: (context, state) {
                _controller.clear();
              },
              builder: (context, state) {
                bool isInvalid = (state is CounterStateInvalid);
                final invalidValue = isInvalid ? state.invalidValue : '';
                return Column(
                  children: [
                    Text('Current value => ${state.value}'),
                    Visibility(
                      child: Text('Invalid input: $invalidValue'),
                      visible: isInvalid,
                    ),
                    TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Enter a number here',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            context
                                .read<CounterBloc>()
                                .add(DecrementEvent(_controller.text));
                          },
                          child: const Text('-'),
                        ),
                        TextButton(
                          onPressed: () {
                            context
                                .read<CounterBloc>()
                                .add(IncrementEvent(_controller.text));
                          },
                          child: const Text('+'),
                        ),
                      ],
                    )
                  ],
                );
              },
            ))
    );
  }
}

@immutable
abstract class CounterState {
  final int value;
  const CounterState(this.value);
}

class CounterStateValid extends CounterState {
  const CounterStateValid(int value) : super(value);
}

class CounterStateInvalid extends CounterState {
  final String invalidValue;

  const CounterStateInvalid({
    required this.invalidValue,
    required int previousValue,
  }) : super(previousValue);
}

@immutable
abstract class CounterEvent {
  final String value;
  const CounterEvent(this.value);
}

class IncrementEvent extends CounterEvent {
  const IncrementEvent(String value) : super(value);
}

class DecrementEvent extends CounterEvent {
  const DecrementEvent(String value) : super(value);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterStateValid(0)) {
    on<IncrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer != null) {
        emit(CounterStateValid(state.value + integer));
      } else {
        emit(
          CounterStateInvalid(
            invalidValue: event.value,
            previousValue: state.value,
          ),
        );
      }
    });

    on<DecrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer != null) {
        emit(CounterStateValid(state.value - integer));
      } else {
        emit(
          CounterStateInvalid(
            invalidValue: event.value,
            previousValue: state.value,
          ),
        );
      }
    });
  }
}

// void nav<T>(BuildContext context, Route<T> route) {
//   Future.delayed(const Duration(milliseconds: 500), () {
//       Navigator.of(context).push(route);
//   },
//   );
// }
//
// void navToWidget(BuildContext context, StatefulWidget sfw) {
//   nav(context, MaterialPageRoute(
//     builder: (context) => sfw,
//   ));
// }

