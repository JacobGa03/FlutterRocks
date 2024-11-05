// We are going to abstract away the 'logic' of incrementing the
// counter out of the UI code. This will make all code more readable

import 'package:flutter/material.dart';

// This MUST extend ChangeNotifier so that way we can instruct the UI to change
class CounterModel extends ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    // Update the count
    _count++;
    // Let the listeners know to update the UI
    notifyListeners();
  }
}
