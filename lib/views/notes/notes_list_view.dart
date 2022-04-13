import 'package:flutter/material.dart';

import '../../services/crud/notes_service.dart';
import '../../utilities/show_dialog.dart';

typedef NoteCallback = void Function(DatabaseNote note);

class NotesListView extends StatelessWidget {
  final List<DatabaseNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;

  const NotesListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        print("index=$index, text=${notes[index].text}");
        return ListTile(
          onTap: () {
            onTap(notes[index]);
          },
          title: Text(
            notes[index].text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              final shouldDelete =
                  await showDeleteDialog(context, notes[index].text);
              if (shouldDelete) {
                onDeleteNote(notes[index]);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
