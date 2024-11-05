import 'package:isar/isar.dart';
// Needed to generate the file
// run: 'dart run build_runner build'
part "note.g.dart";

@Collection()
class Note {
  // Each note has an id
  Id id = Isar.autoIncrement;
  // The actual note, will be init later
  late String note;
}
