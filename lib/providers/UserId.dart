import 'package:flutter/foundation.dart';

class UserID extends ChangeNotifier {
  late String userID;

  String get _UserId => userID;

  set _UserId(String value) {
    userID = value;
    notifyListeners();
  }

  void updateToken(String newId) {
    userID = newId;
    notifyListeners();
  }
}
