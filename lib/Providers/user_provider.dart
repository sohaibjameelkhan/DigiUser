

import 'package:flutter/material.dart';

import '../Models/user_model.dart';

class UserProviderCart extends ChangeNotifier {
  UserModel _userModel = UserModel();

  void saveUserData(UserModel userModel) {
    _userModel = userModel;
    notifyListeners();
  }

  UserModel get getUserData => _userModel;
}
