import 'dart:convert';

import 'package:get/get.dart';
import 'package:gmstest/http/http_client.dart';
import 'package:gmstest/views/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

final HttpClient _httpClient = HttpClient();

class ExpenseController extends GetxController {
  Future<List> getAllExpenses(
      {required branchId,
      required searchKeyword,
      required startDate,
      required endDate}) async {
    var response = await _httpClient.post(
        path: 'expense-list/$branchId',
        body: {
          'search': searchKeyword,
          'start_date': startDate,
          'end_date': endDate
        });
    var a = jsonDecode(response['body']);
    List body = a['data'] as List;

    return body;
  }

  Future<Map<String, dynamic>> addExpense(Map<String, dynamic> data) async {
    var response = await _httpClient.post(path: 'add-expense', body: data);

    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }

  Future<Map<String, dynamic>> editExpence(
      Map<String, dynamic> data, expenseId) async {
    var response =
        await _httpClient.post(path: 'edit-expense/$expenseId', body: data);

    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }

  Future<Map<String, dynamic>> deleteExpence(
     expenseId) async {
    var response =
        await _httpClient.get(path: 'delete-expense/$expenseId');

    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }
}
