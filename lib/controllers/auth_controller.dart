import 'package:app/api/api_handler.dart';
import 'package:app/api/authApi/auth_api_handler.dart';
import 'package:app/api/mainApi/main_api_handler.dart';
import 'package:app/classes/user_class.dart';
import 'package:app/main.dart';
import 'package:app/pages/welcome/start_page.dart';
import 'package:app/provider/user/user_storage.dart';
import 'package:app/store/secure_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthController {
  static Future<bool> isAuthroized() async {
    if (await secured_storage.read(key: "access_token") != null) {
      return true;
    }
    return false;
  }

  static Future<User?> getInfoCurrentUser() async {
    final res = await MainApiHandler.getUsersMe();

    if (res.status) {
      return User.fromJson(res.body['user']);
    }
    return null;
  }

  static Future<bool> logOut() async {
    await secured_storage.delete(key: "access_token");
    await secured_storage.delete(key: "refresh_token");
    final userProvider =
        Provider.of<UserProvider>(navigatorKey.currentContext!, listen: false);
    userProvider.deleteUserNoNotify();
    Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(
        CupertinoPageRoute(builder: (_) => StartPage()), (route) => false);
    return true;
  }
}
