import 'dart:convert';

import 'package:get/get.dart';
import 'package:gmstest/configs/server_configs.dart';
import 'package:gmstest/http/http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

final HttpClient _httpClient = HttpClient();

class AdminDashboardController extends GetxController {
  Future<Map<String, dynamic>> getAdminDashboardData(
    Map<String, dynamic> data,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    var a = prefs.getInt('adminId');
    print('aaaaaaaaaaaaaaaaaaaaaa');
    print(a);
    var response =
        await _httpClient.post(path: 'admin-dashboard/$a', body: data);

    var body = json.decode(response['body']) as Map<String, dynamic>;

    print(body);

    return body;
  }
}
