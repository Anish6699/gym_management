import 'dart:convert';

import 'package:gmstest/configs/server_configs.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Singleton class to ensure only once http client is working on the application

class HttpClient {
  HttpClient._privateConstructor();

  static final HttpClient _instance = HttpClient._privateConstructor();

  factory HttpClient() {
    return _instance;
  }

  Future<Map<String, dynamic>> get({
    required String path,
  }) async {
    var url = Uri.parse(serverUrl + path);
    var response = await http.get(
      url,
      headers: await _getHeaders(),
    );

    return {
      'statusCode': response.statusCode,
      'body': response.body,
    };
  }

  Future<Map<String, dynamic>> post({
    required String path,
    required dynamic body,
  }) async {
    var url = Uri.parse(serverUrl + path);
    var response = await http.post(
      url,
      body: jsonEncode(body),
      headers: await _getHeaders(),
    );
    return {
      'statusCode': response.statusCode,
      'body': response.body,
    };
  }

  Future<Map<String, dynamic>> put({
    required String path,
    required dynamic body,
  }) async {
    var url = Uri.parse(serverUrl + path);
    var response = await http.put(
      url,
      body: jsonEncode(body),
      headers: await _getHeaders(),
    );
    return {
      'statusCode': response.statusCode,
      'body': response.body,
    };
  }

  Future<Map<String, dynamic>> delete({
    required String path,
  }) async {
    var url = Uri.parse(serverUrl + path);
    var response = await http.delete(
      url,
      headers: await _getHeaders(),
    );
    return {
      'statusCode': response.statusCode,
      'body': response.body,
    };
  }

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString('token');
    return {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
      'Access-Control-Allow-Origin': serverUrl
    };
  }
}
