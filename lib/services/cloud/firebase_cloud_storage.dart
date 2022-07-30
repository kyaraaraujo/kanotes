import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanotes/services/cloud/cloud_note.dart';
import 'package:kanotes/services/cloud/cloud_storage_constants.dart';
import 'package:kanotes/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  // as singleton (in dart)
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();

  FirebaseCloudStorage._sharedInstance();

  factory FirebaseCloudStorage() => _shared;

  // communicatons with firebase firestore (DB)
  final notes = FirebaseFirestore.instance.collection('notes');

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });

    final fetchedNote = await document.get();
    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      text: '',
    );
  }

// Those are only for users notes's owners
  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) => notes
      .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
      .snapshots()
      .map((event) => event.docs.map((doc) => CloudNote.fromSnapshot(doc)));

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> deleteNote({
    required String documentId,
  }) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }
}
