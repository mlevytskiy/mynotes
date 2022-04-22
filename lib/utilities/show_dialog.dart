import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionBuilder,
}) {
  final options = optionBuilder();
  return showDialog<T>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: options.keys.map((optionTitle) {
          final T value = options[optionTitle];
          return TextButton(
              onPressed: () {
                if (value != null) {
                  Navigator.of(context).pop(value);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text(optionTitle));
        }).toList(),
      );
    },
  );
}

Future<bool> showDeleteDialog(BuildContext context, String noteText) {
  return showGenericDialog<bool>(
      context: context,
      title: 'Delete note',
      content: 'Are you sure you want to delete this note?\n$noteText',
      optionBuilder: () => {
            'Cancel': false,
            'Delete': true,
          }).then((value) => value ?? false);
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
      context: context,
      title: 'Sign out',
      content: 'Are you sure you want to sign out?',
      optionBuilder: () => {
            'Cancel': false,
            'Log out': true,
          }).then((value) => value ?? false);
}

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
      context: context,
      title: 'An error occurred',
      content: text,
      optionBuilder: () => {'OK': null});
}

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Sharing',
    content: 'You cannot share an empty note!',
    optionBuilder: () => {
      'OK': null,
    },
  );
}

typedef CloseDialog = void Function();

CloseDialog showLoadingDialog({
  required BuildContext context,
  required String text,
}) {
  final dialog = AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(
          height: 10.0,
        ),
        Text(text),
      ],
    ),
  );

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => dialog,
  );

  return () => Navigator.of(context).pop();
}
