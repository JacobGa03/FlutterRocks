import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoTile extends StatelessWidget {
  // Instance variables for the class
  final String taskName;
  final bool taskComplete;
  // Type of method 'onChanged' needs to work
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;

  // Constructor to be a ToDoTile
  ToDoTile(
      {super.key,
      required this.taskName,
      required this.taskComplete,
      required this.onChanged,
      required this.deleteFunction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Slidable(
        endActionPane: ActionPane(motion: StretchMotion(), children: [
          SlidableAction(
            onPressed: deleteFunction,
            icon: Icons.delete,
            backgroundColor: Colors.red,
          )
        ]),
        child: Container(
          padding: const EdgeInsets.all(6),
          height: 75,
          width: double.infinity,
          decoration: const BoxDecoration(color: Colors.yellow),
          child: Row(
            children: [
              // You can check and uncheck this
              Checkbox(
                value: taskComplete,
                onChanged: onChanged,
                activeColor: const Color.fromARGB(255, 46, 44, 44),
              ),
              // Displays what the name is
              Text(
                taskName,
                style: TextStyle(
                    decoration: taskComplete
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              )
            ],
          ),
        ),
      ),
    );
  }
}
