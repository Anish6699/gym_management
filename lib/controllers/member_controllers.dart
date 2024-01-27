import 'dart:convert';

import 'package:get/get.dart';
import 'package:gmstest/http/http_client.dart';
import 'package:gmstest/views/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

final HttpClient _httpClient = HttpClient();

class MemberController extends GetxController {
  Future<List> getAllMembers({required branchId}) async {
    var response = await _httpClient.get(path: 'get-member/$branchId');
    var a = jsonDecode(response['body']);
    List body = a['data'] as List;

    return body;
  }

  Future<Map<String, dynamic>> addMember(Map<String, dynamic> data) async {
    print(data);
    print('addding memberrrrrrrrr');
    var response = await _httpClient.post(path: 'add-member', body: data);
    print(response['body']);
    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }

  Future<Map<String, dynamic>> editMember(
      Map<String, dynamic> data, branchId) async {
    print(data);
    var response =
        await _httpClient.post(path: 'edit-member/$branchId', body: data);
    print(response['body']);
    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }

  Future<Map<String, dynamic>> getSingleMember(memberId) async {
    var response = await _httpClient.get(path: 'member-profile/$memberId');
    print(response['body']);
    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }

  //////////////////////////////////////Visitors////////////////////////////////////////
  ///
  ///
  Future<List> getAllVisitors({required branchId}) async {
    print('b i d');
    print(branchId);
    var response = await _httpClient.get(path: 'visitor-list/$branchId');
    print(response);
    var a = jsonDecode(response['body']);
    print(a);
    List body = a['data'] as List;

    return body;
  }

  Future<Map<String, dynamic>> addVisitor(Map<String, dynamic> data) async {
    print(data);
    print('addding memberrrrrrrrr');
    var response = await _httpClient.post(path: 'add-visitor', body: data);
    print(response['body']);
    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }

  Future<Map<String, dynamic>> editVisitor(
      Map<String, dynamic> data, branchId) async {
    print(data);
    var response =
        await _httpClient.post(path: 'edit-visitor/$branchId', body: data);
    print(response['body']);
    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }
}
