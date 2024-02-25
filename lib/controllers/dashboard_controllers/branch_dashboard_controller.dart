import 'dart:convert';

import 'package:get/get.dart';
import 'package:gmstest/http/http_client.dart';
import 'package:gmstest/views/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

final HttpClient _httpClient = HttpClient();

class BranchDashboardController extends GetxController {
 

  Future<Map<String, dynamic>> getBranchDashboardData(Map<String, dynamic> data, branchId) async {
    var response = await _httpClient.post(path: 'branch-dashboard/$branchId', body: data);

    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }

}
