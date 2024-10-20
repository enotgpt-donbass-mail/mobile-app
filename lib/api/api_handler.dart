import 'dart:convert';
import 'dart:io';

import 'package:app/api/authApi/classes/data_provider.dart';
import 'package:app/api/authApi/classes/user_code_id.dart';
import 'package:app/store/secure_storage.dart';
import 'package:http/http.dart' as http;

class CustomApiHandler {
  static Map<dynamic, dynamic> jsonResponse(response) {
    return json.decode(utf8.decode(response.bodyBytes));
  }

  static Future<Map<String, String>> headerAuth({needed = false}) async {
    var token = await secured_storage.read(key: "access_token");
    if (needed) {
      token ??=
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwicm9sZXMiOlsiYWRtaW4iLCJ1c2VyIl0sImV4cCI6MTczOTgzNTkxMH0.Sf3bIxFPwNcuhUMIzqzI4D0sMXIOLsWF9NHpfmgJqT8";
    } else {}
    token ??= "";
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
  }

  static Future<DataProvider> refreshToken() async {
    final url = Uri.parse('https://auth.enotgpt.ru/api/change_token');
    final header = await headerAuth();
    final body = jsonEncode(
        {"refresh_token": await secured_storage.read(key: "refresh_token")});

    final response = await postRequest(url, header, body);

    if (response.statusCode == 200) {
      final data = jsonResponse(response);
      await secured_storage.write(
          key: 'access_token', value: data['access_token']);
      print('token refreshed');
      return DataProvider(true, data, "Зарешфрешили токен");
    } else {
      return DataProvider(true, {}, "Не удалось зарефрешить");
    }
  }

  static Future<http.Response> getRequest(url, header) async {
    var response = await http.get(url, headers: header);
    if (response.statusCode == 401 &&
        await secured_storage.read(key: "access_token") != null) {
      await refreshToken();
      final newHeader = header;
      var token = await secured_storage.read(key: "access_token");
      token ??= "";
      newHeader['Authorization'] = 'Bearer $token';
      response = await http.get(url, headers: newHeader);
    }
    return response;
  }

  static Future<http.Response> postRequest(url, header, body) async {
    var response = await http.post(url, headers: header, body: body);
    if (response.statusCode == 401 &&
        await secured_storage.read(key: "access_token") != null) {
      await refreshToken();
      final newHeader = header;
      var token = await secured_storage.read(key: "access_token");
      token ??= "";
      newHeader['Authorization'] = 'Bearer $token';
      response = await http.post(url, headers: newHeader, body: body);
    }
    return response;
  }
}
