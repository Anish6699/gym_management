import 'dart:convert';

import 'package:get/get.dart';
import 'package:gmstest/http/http_client.dart';
import 'package:gmstest/views/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

final HttpClient _httpClient = HttpClient();

class MemberController extends GetxController {
  Future<List> getAllMembers(
      {required branchId,
      required searchKeyword,
      required statusId,
      required startDate,
      required endDate}) async {
    var response = await _httpClient.post(path: 'get-member/$branchId', body: {
      'search': searchKeyword,
      'status': statusId == -1 ? null : statusId,
      'start_date': startDate,
      'end_date': endDate
    });
    var a = jsonDecode(response['body']);
    List body = a['data'] as List;

    return body;
  }

  Future<Map<String, dynamic>> addMember(Map<String, dynamic> data) async {
    var response = await _httpClient.post(path: 'add-member', body: data);

    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }

  Future<Map<String, dynamic>> addBulkMembers(
      Map<String, dynamic> data, branchId) async {
    var response = await _httpClient.post(
        path: 'member-upload-files/$branchId', body: data);

    var body = json.decode(response['body']) as Map<String, dynamic>;
    return body;
  }

  Future<Map<String, dynamic>> editMember(
      Map<String, dynamic> data, branchId) async {
    var response =
        await _httpClient.post(path: 'edit-member/$branchId', body: data);

    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }

  Future<Map<String, dynamic>> getSingleMember(memberId) async {
    var response = await _httpClient.get(path: 'member-profile/$memberId');

    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }

  Future<Map<String, dynamic>> addMemberPlan(
      Map<String, dynamic> data, int memberId) async {
    var response =
        await _httpClient.post(path: 'add-member-plan/$memberId', body: data);

    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }

  Future<Map<String, dynamic>> payPending(
      Map<String, dynamic> data, int memberId) async {
    var response = await _httpClient.post(
        path: 'pay-member-pending/$memberId', body: data);

    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }

  Future<Map<String, dynamic>> deleteMember(memberId) async {
    var response = await _httpClient.get(path: 'delete-member/$memberId');

    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }

  Future<Map<String, dynamic>> editMemberProfileImage(
      Map<String, dynamic> data, memberId) async {
    var response = await _httpClient.post(
        path: 'edit-profile-image/$memberId', body: data);

    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }
  //////////////////////////////////////Visitors////////////////////////////////////////

  Future<List> getAllVisitors(
      {required branchId,
      required searchKeyword,
      required startDate,
      required endDate}) async {
    var response = await _httpClient.post(
        path: 'visitor-list/$branchId',
        body: {
          'search': searchKeyword,
          'start_date': startDate,
          'end_date': endDate
        });

    var a = jsonDecode(response['body']);

    List body = a['data'] as List;

    return body;
  }

  Future<Map<String, dynamic>> addVisitor(Map<String, dynamic> data) async {
    var response = await _httpClient.post(path: 'add-visitor', body: data);

    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }

  Future<Map<String, dynamic>> editVisitor(
      Map<String, dynamic> data, visitorId) async {
    var response =
        await _httpClient.post(path: 'edit-visitor/$visitorId', body: data);

    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }

  Future<Map<String, dynamic>> deleteVisitor(visitorId) async {
    var response = await _httpClient.get(path: 'delete-member/$visitorId');

    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }
}
