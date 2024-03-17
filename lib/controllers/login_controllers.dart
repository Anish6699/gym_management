import 'dart:convert';

import 'package:get/get.dart';
import 'package:gmstest/http/http_client.dart';
import 'package:gmstest/views/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

final HttpClient _httpClient = HttpClient();

class LoginController extends GetxController {
  Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    var response = await _httpClient.post(path: 'user-login', body: data);

    var body = json.decode(response['body']) as Map<String, dynamic>;
  

    return body;
  }

  logout() async {
    // var response = await _httpClient.get(path: 'logout');
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed(LoginPage.routeName);
  }

  Future<Map<String, dynamic>> sendNotifications(
      Map<String, dynamic> data) async {
    var response = await _httpClient.post(path: 'send-mail', body: data);

    // var body = json.decode(response['body']) as String;

    return response;
  }

  Future<Map<String, dynamic>> forgetPassword(Map<String, dynamic> data) async {
    var response = await _httpClient.post(path: 'forget-password', body: data);

    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }
}
