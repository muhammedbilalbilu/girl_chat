import 'package:flutter/widgets.dart';
import 'package:girl_chat/models/user.dart';
import 'package:girl_chat/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  Useradd? _user;
  final AuthMethods _authMethods = AuthMethods();

  Useradd get getUser => _user!;

  Future<void> refreshUser() async {
    Useradd user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
