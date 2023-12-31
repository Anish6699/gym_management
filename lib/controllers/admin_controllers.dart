import 'dart:convert';

import 'package:get/get.dart';
import 'package:gmstest/http/http_client.dart';
import 'package:gmstest/views/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

final HttpClient _httpClient = HttpClient();

class AdminController extends GetxController {
  Future<List> getAllAdmin() async {
    var response = await _httpClient.get(path: 'admin-list');

    var a = jsonDecode(response['body']);
    List body = a['data'] as List;

    return body;
  }

  Future<List> getAdminAllBranches({required int adminId}) async {
    print(adminId);
    var response = await _httpClient.get(path: 'admin-branch-list/$adminId');

    var a = jsonDecode(response['body']);
    List body = a['data'] as List;

    return body;
  }

  Future<Map<String, dynamic>> addAdmin(Map<String, dynamic> data) async {
    print(data);
    var response = await _httpClient.post(path: 'add-admin', body: data);
    print(response['body']);
    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }

  Future<Map<String, dynamic>> editAdmin(
      Map<String, dynamic> data, adminId) async {
    print(data);
    var response =
        await _httpClient.post(path: 'edit-admin/$adminId', body: data);
    print(response['body']);
    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }

  Future<Map<String, dynamic>> addBranch(Map<String, dynamic> data) async {
    print(data);
    var response = await _httpClient.post(path: 'add-branch', body: data);
    print(response['body']);
    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }

  Future<Map<String, dynamic>> editBranch(
      Map<String, dynamic> data, int branchId) async {
    print(data);
    var response =
        await _httpClient.post(path: 'edit-branch/$branchId', body: data);
    print(response['body']);
    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }
}
