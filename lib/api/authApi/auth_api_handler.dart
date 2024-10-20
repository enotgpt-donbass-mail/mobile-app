import 'dart:convert';
import 'dart:io';

import 'package:app/api/api_handler.dart';
import 'package:app/api/authApi/classes/data_provider.dart';
import 'package:app/api/authApi/classes/user_code_id.dart';
import 'package:app/classes/user_class.dart';
import 'package:app/main.dart';
import 'package:app/provider/user/user_storage.dart';
import 'package:app/store/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AuthApiServer {
  static const serverURL = "https://auth.enotgpt.ru";

  static Uri CustomURL(url) {
    return Uri.parse(serverURL + url);
  }

  static Future<UserCodeId> getCodeByEmail(email) async {
    final url = CustomURL('/api/auth/get_code_by_email');
    final header = await CustomApiHandler.headerAuth();
    final body = jsonEncode({'email': email});

    final response = await CustomApiHandler.postRequest(url, header, body);

    if (response.statusCode == 200) {
      final data = CustomApiHandler.jsonResponse(response);
      return UserCodeId(true, data['code_id'], "Аккаунт найден");
    } else if (response.statusCode == 404) {
      return UserCodeId(false, 0, "Аккаунт не найден");
    } else {
      return UserCodeId(false, 0, "Произошла ошибка");
    }
  }

  static Future<DataProvider> confirmCodeByEmail(
      email, code_id, code, typeAuth) async {
    final url = typeAuth == 0
        ? CustomURL('/api/auth/confirm_email')
        : CustomURL('/api/registration_confirm_email');
    final header = await CustomApiHandler.headerAuth();
    final body = jsonEncode({"code_id": code_id, "code": code, "email": email});

    final response = await CustomApiHandler.postRequest(url, header, body);

    if (response.statusCode == 200) {
      final data = CustomApiHandler.jsonResponse(response);
      secured_storage.write(key: "access_token", value: data['access_token']);
      secured_storage.write(key: "refresh_token", value: data['refresh_token']);
      return DataProvider(true, data, "Авторизован");
    } else if (response.statusCode == 401) {
      return DataProvider(false, {}, "Код неверен");
    } else {
      return DataProvider(false, {}, "Произошла ошибка");
    }
  }

  static Future<UserCodeId> registerUserByEmail(
      first_name, last_name, middle_name, birth_date, gender, email) async {
    final url = CustomURL('/api/registration_by_email');
    final header = await CustomApiHandler.headerAuth();
    final body = jsonEncode({
      'first_name': first_name,
      'last_name': last_name,
      'middle_name': middle_name,
      'birth_date': birth_date,
      'gender': gender,
      'email': email
    });

    final response = await CustomApiHandler.postRequest(url, header, body);

    if (response.statusCode == 200) {
      final data = CustomApiHandler.jsonResponse(response);
      return UserCodeId(true, data['code_id'], "Аккаунт почти зареган");
    } else if (response.statusCode == 404) {
      return UserCodeId(false, 0, "Аккаунт не зареган");
    } else {
      return UserCodeId(false, 0, "Произошла ошибка");
    }
  }

  static Future<UserCodeId> qrCodeApprove(token) async {
    final url = CustomURL('/api/qr_code/auth/' + token);
    final header = await CustomApiHandler.headerAuth();

    final response = await CustomApiHandler.getRequest(url, header);

    if (response.statusCode == 200) {
      final data = CustomApiHandler.jsonResponse(response);
      return UserCodeId(true, 0, "Вошли в аккаунт");
    } else if (response.statusCode == 404) {
      return UserCodeId(false, 0, "Неверный QR-код");
    } else {
      return UserCodeId(false, 0, "Произошла ошибка");
    }
  }
}
