import 'dart:convert';
import 'dart:io';

import 'package:app/api/api_handler.dart';
import 'package:app/api/authApi/classes/data_provider.dart';
import 'package:app/api/authApi/classes/user_code_id.dart';
import 'package:app/classes/user_class.dart';
import 'package:app/main.dart';
import 'package:app/provider/user/user_storage.dart';
import 'package:app/store/secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class MainApiHandler {
  static const serverURL = "https://misha.enotgpt.ru";

  static Uri CustomURL(url) {
    return Uri.parse(serverURL + url);
  }

  static Future<DataProvider> getUsersMe() async {
    final userProvider =
        Provider.of<UserProvider>(navigatorKey.currentContext!, listen: false);

    final url = CustomURL('/users/me');

    final header = await CustomApiHandler.headerAuth();

    final response = await CustomApiHandler.getRequest(url, header);
    if (response.statusCode == 200) {
      final data = CustomApiHandler.jsonResponse(response);

      userProvider.setUser(User.fromJson(data['user']));

      return DataProvider(true, data, "Аккаунт найден");
    } else {
      userProvider.noUser();
      return DataProvider(false, {}, "Произошла ошибка");
    }
  }

  static Future<DataProvider> operationAll() async {
    final url = CustomURL('/operation_roles/get');

    final header = await CustomApiHandler.headerAuth(needed: true);

    final response = await CustomApiHandler.getRequest(url, header);

    if (response.statusCode == 200) {
      final data = CustomApiHandler.jsonResponse(response);

      return DataProvider(true, data, "Получили список операций");
    } else {
      return DataProvider(false, {}, "Произошла ошибка");
    }
  }

  static Future<DataProvider> reserveTicket(data) async {
    final userProvider =
        Provider.of<UserProvider>(navigatorKey.currentContext!, listen: false);

    final url = CustomURL('/reserved/add');

    final header = await CustomApiHandler.headerAuth(needed: true);
    header['Authorization'] =
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwicm9sZXMiOlsiYWRtaW4iLCJ1c2VyIl0sImV4cCI6MTczOTgzNTkxMH0.Sf3bIxFPwNcuhUMIzqzI4D0sMXIOLsWF9NHpfmgJqT8';

    final response =
        await CustomApiHandler.postRequest(url, header, jsonEncode(data));
    if (response.statusCode == 200) {
      final data = CustomApiHandler.jsonResponse(response);
      var r = await secured_storage.read(key: "current_tickets");
      r ??= jsonEncode({"tickets": []});
      var res = json.decode(utf8.decode(utf8.encode(r)));

      res['tickets'].add(data);
      print(res);
      await secured_storage.write(
          key: "current_tickets", value: jsonEncode(res));

      return DataProvider(true, data, "Аккаунт найден");
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return DataProvider(false, {}, "Произошла ошибка");
    }
  }
}
