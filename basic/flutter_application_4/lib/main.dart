import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/note_database.dart';
import 'package:flutter_application_4/pages/notes_page.dart';
import 'package:provider/provider.dart';

void main() async {
  // Init note DB
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.init();
  // Run the app
  runApp(ChangeNotifierProvider(
      create: (context) => NoteDatabase(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotesPage(),
    );
  }
}
