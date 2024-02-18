import 'dart:convert';

import 'package:get/get.dart';
import 'package:gmstest/http/http_client.dart';
import 'package:gmstest/views/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

final HttpClient _httpClient = HttpClient();

class TrainerController extends GetxController {
  Future<List> getAllTrainer(
      {required branchId, required searchKeyword}) async {
    var response =
        await _httpClient.post(path: 'trainer-list/$branchId', body: {
      'search': searchKeyword,
    });
    var a = jsonDecode(response['body']);
    List body = a['data'] as List;

    return body;
  }

  Future<Map<String, dynamic>> addTrainer(Map<String, dynamic> data) async {
    var response = await _httpClient.post(path: 'add-trainer', body: data);

    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }

  Future<Map<String, dynamic>> editTrainer(
      Map<String, dynamic> data, trainerId) async {
    var response =
        await _httpClient.post(path: 'edit-trainer/$trainerId', body: data);

    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }
}
