import 'package:app/classes/user_class.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  bool fetched = false;
  User? user;
  void setUser(user) {
    this.fetched = true;
    this.user = user;
    notifyListeners();
  }

  void deleteUser() {
    fetched = false;
    user = null;
    notifyListeners();
  }

  void deleteUserNoNotify() {
    fetched = false;
    user = null;
  }

  void noUser() {
    fetched = true;
    user = null;
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }
}
