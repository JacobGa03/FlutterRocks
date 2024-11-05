// TODO: There is some problem with this, the build.gradle file is causing this to not even compile the app
import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/note.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase extends ChangeNotifier {
  static late Isar isar;

  // Init the database
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([NoteSchema], directory: dir.path);
  }

  final List<Note> currNotes = [];

  Future<void> addNote(String text) async {
    final newNote = Note()..note = text;
    await isar.writeTxn(() => isar.notes.put(newNote));
    notifyListeners();
  }

  Future<void> readNote() async {
    // Grab all the notes
    List<Note> fetchedNotes = await isar.notes.where().findAll();
    currNotes.clear();
    currNotes.addAll(fetchedNotes);
    notifyListeners();
  }

  Future<void> updateNode(int id, String newNote) async {
    final existingNote = await isar.notes.get(id);
    if (existingNote != null) {
      existingNote.note = newNote;
      // Write to the database
      await isar.writeTxn(() => isar.notes.put(existingNote));
      // Get back all of the notes
      await readNote();
      notifyListeners();
    }

    Future<void> deleteNote(int id) async {
      // Delete the note from the DB
      await isar.writeTxn(() => isar.notes.delete(id));
      // Re-fetch all the notes
      await readNote();
      notifyListeners();
    }
  }
}
