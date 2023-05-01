import 'dart:math';
import 'package:fellowship/src/configs/configs.dart';
import 'package:fellowship/src/data/models/models.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserRepository extends ChangeNotifier {
  // var _localUser = UserModel(firstName: '', lastName: '', birthDate: DateTime.now());
  var _loginCount = 0;
  var _natureImage = natureImages[0];

  // UserModel get getUser => _localUser;
  int get getLoginCount => _loginCount;
  String get getNatureImage => _natureImage;


  Future<void> _updateLoginCount() async {
    final box = Hive.box('wefellowship');

    _loginCount++;
    await box.put('login_count', _loginCount);
    notifyListeners();
  }

  Future<void> updateNatureImage() async {
    final box = Hive.box('elisha');

    _natureImage = natureImages[Random().nextInt(10)];
    await box.put('nature_image', _natureImage);
    notifyListeners();
  }

  void loadUser() async {
    final box = Hive.box('elisha');

    /// Removes user from device.
    // box.delete('user');

    // String user = box.get(
    //   'user',
    //   defaultValue: LocalUser(
    //     firstName: '',
    //     lastName: '',
    //     birthDate: DateTime.now(),
    //   ).toJson(),
    // );

    int loginCount = box.get('login_count', defaultValue: 0);
    String natureImage = box.get('nature_image', defaultValue: natureImages[0]);

    // _localUser = LocalUser.fromJson(user);
    _natureImage = natureImage;

    // if (user == '' || [_localUser.firstName, _localUser.lastName].contains('')) {
    //   _loginCount = 0;
    // } else {
    //   _loginCount = loginCount;
    //   _localUser = LocalUser.fromJson(user);
    // }

    await _updateLoginCount();
  }
}
