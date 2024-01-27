import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User extends ChangeNotifier {
  var _user = {
    'name': '',
    'id': '',
    'userType': '',
  };

  User() {
    initializeUser();
  }

  Future<void> initializeUser() async {
    var user = await getPreferences();
    setUser = user;
  }

  set setUser(var user) {
    setPreferences(user);
    _user = user;
    notifyListeners();
  }

  void removeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();

    _user = {
      'name': '',
      'id': '',
      'userType': '',
    };
    notifyListeners();
  }

  Future<Map<String, String>> getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('name') ?? '',
      'id': prefs.getString('id') ?? '',
      'userType': prefs.getString('userType') ?? '',
    };
  }

  void setPreferences(var user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', user['name']);
    await prefs.setString('id', user['id']);
    await prefs.setString('userType', user['userType']);
  }

  get getUser => _user;
}
