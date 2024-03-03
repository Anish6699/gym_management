import 'dart:convert';

import 'package:get/get.dart';
import 'package:gmstest/http/http_client.dart';

final HttpClient _httpClient = HttpClient();

class AdminController extends GetxController {
  Future<List> getAllAdmin({required String searchKeyword}) async {
    var response = await _httpClient
        .post(path: 'admin-list', body: {'search': searchKeyword});

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


 Future<List> getAllCategories() async {
 var response = await _httpClient.get(path: 'get-category');

    var a = jsonDecode(response['body']);
    List body = a['data'] as List;
     return body;
}
  Future<Map<String, dynamic>> addAdmin(Map<String, dynamic> data) async {
    var response = await _httpClient.post(path: 'add-admin', body: data);

    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }

  Future<Map<String, dynamic>> editAdmin(
      Map<String, dynamic> data, adminId) async {
    var response =
        await _httpClient.post(path: 'edit-admin/$adminId', body: data);

    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }

  Future<Map<String, dynamic>> addBranch(Map<String, dynamic> data) async {
    var response = await _httpClient.post(path: 'add-branch', body: data);

    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }

  Future<Map<String, dynamic>> editBranch(
      Map<String, dynamic> data, int branchId) async {
    var response =
        await _httpClient.post(path: 'edit-branch/$branchId', body: data);

    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }

  Future<Map<String, dynamic>> addBranchPlan(
      Map<String, dynamic> data, int branchId) async {
    var response =
        await _httpClient.post(path: 'add-branch-plan/$branchId', body: data);

    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }

  Future<Map<String, dynamic>> payPending(
      Map<String, dynamic> data, int branchId) async {
    var response = await _httpClient.post(
        path: 'pay-branch-pending/$branchId', body: data);

    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }

  Future<Map<String, dynamic>> getSingleMember(branchId) async {
    var response = await _httpClient.get(path: 'branch-profile/$branchId');

    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }
}
