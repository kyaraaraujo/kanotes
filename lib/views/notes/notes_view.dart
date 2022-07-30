import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:kanotes/extensions/buildcontext/loc.dart';
import 'package:kanotes/services/auth/auth_service.dart';
import 'package:kanotes/services/auth/bloc/auth_bloc.dart';
import 'package:kanotes/services/auth/bloc/auth_event.dart';
import 'package:kanotes/services/cloud/cloud_note.dart';
import 'package:kanotes/services/cloud/firebase_cloud_storage.dart';

import '../../constants/routes.dart';
import '../../enums/menu_action.dart';
import '../../utilities/dialogs/logout_dialog.dart';
import 'notes_list_view.dart';

extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength => map((event) => event.length);
}

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<int>(
          stream: _notesService.allNotes(ownerUserId: userId).getLength,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final noteCount = snapshot.data ?? 0;
              final text = context.loc.notes_title(noteCount);
              return Text(text);
            } else {
              return const Text('');
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            },
          ),
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final shouldLogout = await showLogOutDialog(context);
                // added 'mounted' to remove the BuildContext warning about async gaps
                if (shouldLogout && mounted) {
                  context.read<AuthBloc>().add(
                        const AuthEventLogOut(),
                      );
                }
                break;
              default:
            }
          }, itemBuilder: (context) {
            return [
              PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text(context.loc.logout_button),
              ),
            ];
          })
        ],
      ),
      body: StreamBuilder(
        stream: _notesService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                return NotesListView(
                  notes: allNotes,
                  onDeleteNote: (note) async {
                    await _notesService.deleteNote(documentId: note.documentId);
                  },
                  onTap: (note) {
                    Navigator.of(context).pushNamed(
                      createOrUpdateNoteRoute,
                      arguments: note,
                    );
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
