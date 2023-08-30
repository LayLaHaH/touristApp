import 'package:flutter/foundation.dart';

class CompanyID extends ChangeNotifier {
  late int _companyId;

  int get companyId => _companyId;

  set companyId(int value) {
    _companyId = value;
    notifyListeners();
  }

  void updateToken(int newCompanyId) {
    _companyId = newCompanyId;
    notifyListeners();
  }
}
