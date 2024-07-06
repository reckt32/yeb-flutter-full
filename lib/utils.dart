import 'package:flutter/material.dart';

// return relative size (eg. x = 0.5 ==> 50% percent of screen width)
double relx(BuildContext context, double x) {
  return MediaQuery.of(context).size.width * x;
}

// return relative size (eg. x = 0.5 ==> 50% percent of screen height)
double rely(BuildContext context, double y) {
  return MediaQuery.of(context).size.height * y;
}

// provider class
class AppState with ChangeNotifier {
  // list of size 8 bool list to hold completion status of each state
  List<bool> isCompleted = [];
  AppState() {
    for (int i = 0; i < 8; i++) {
      isCompleted.add(false);
    }
    isCompleted[0] = true;
  }

  bool markCompleted(int state) {
    // state cannot be marked if previous state is incomplete
    if (state >= 1 && !isCompleted[state - 1]) return false;

    isCompleted[state] = true;
    notifyListeners();
    return true;
  }

  void markNotCompleted(int state) {
    // state cannot be marked if previous state is incomplete

    isCompleted[state] = false;
    notifyListeners();
  }
}
