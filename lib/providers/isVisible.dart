import 'package:flutter/foundation.dart';

class IsVisible extends ChangeNotifier {
  late bool _isVisible=false;

  bool get isVisible => _isVisible;

  set isVisible(bool value) {
    _isVisible = value;
    notifyListeners();
  }

  void updateToken(bool newToken) {
    _isVisible = newToken;
    notifyListeners();
  }
}
