import 'package:hive/hive.dart';

class ToDoDatabase {
  // Reference our box that will hold the todo data
  final _mybox = Hive.box('mybox');
  // Holds our todo items
  List toDoList = [];

  // If this is the first time every opening this app
  void createInitialData() {
    toDoList = [
      ["ToDos", false],
      ["are Fun", false],
    ];
  }

  // Load data from the database
  void loadData() {
    toDoList = _mybox.get('TODOLIST');
  }

  // Update the database
  void updateDataBase() {
    _mybox.put('TODOLIST', toDoList);
  }
}
