import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/database.dart';
import 'package:hive/hive.dart';
import '../utils/todotile.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  // Define our text editing controller
  TextEditingController tec = TextEditingController();
  // Our DB
  final _myBox = Hive.box('mybox');
  // Reference our local database
  ToDoDatabase db = ToDoDatabase();

  @override
  void initState() {
    // 1st time opening app, then create default data
    if (_myBox.get('TODOLIST') == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  // Check box was tapped
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      // Set the index'th item to
      db.toDoList[index][1] = !db.toDoList[index][1];
      db.updateDataBase();
    });
  }

  void deleteItem(int index) {
    setState(() {
      // Remove the item from the list, at a specific index
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text("ToDo's"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: db.toDoList[index][0],
            taskComplete: db.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteItem(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Add a New ToDo Item"),
                  backgroundColor: Colors.yellow,
                  content: TextField(
                    controller: tec,
                    decoration: const InputDecoration(
                        labelText: 'Enter Item', border: OutlineInputBorder()),
                  ),
                  actions: [
                    Center(
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              db.toDoList.add([tec.text, false]);
                              tec.clear();
                              db.updateDataBase();
                            });
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.yellow[200])),
                          child: const Text('Add')),
                    )
                  ],
                );
              });
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
