import 'package:flutter/material.dart';

class User extends ChangeNotifier {
  var _user = {
    'name': '',
    'id': '',
  };

  set setUser(var user) {
    _user = user;
    notifyListeners();
  }

  void removeUser() {
    _user = {
      'name': '',
      'id': '',
    };
    notifyListeners();
  }

  get getUser => _user;
}
