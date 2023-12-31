import 'dart:convert';

import 'package:get/get.dart';
import 'package:gmstest/http/http_client.dart';
import 'package:gmstest/views/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

final HttpClient _httpClient = HttpClient();

class LoginController extends GetxController {
  Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    print(data);
    var response = await _httpClient.post(path: 'user-login', body: data);
    print(response['body']);
    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }

  logout() async {
    var response = await _httpClient.get(path: 'logout');
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed(LoginPage.routeName);
  }
}
