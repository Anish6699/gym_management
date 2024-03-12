import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmstest/configs/server_configs.dart';
import 'package:gmstest/widgets/popup.dart';
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
    if (response.statusCode == 500) {
      Get.dialog(GenericDialogBox(
        enableSecondaryButton: false,
        primaryButtonText: 'Ok',
        isLoader: false,
        content: const Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(
            width: 100,
            height: 100,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Something Went Wrong !!',
                    style: TextStyle(color: Colors.red),
                  )
                ],
              ),
            ),
          ),
        ),
        onPrimaryButtonPressed: () {
          Get.back();
        },
      ));
    }

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
    if (response.statusCode == 500) {
      Get.dialog(GenericDialogBox(
        enableSecondaryButton: false,
        primaryButtonText: 'Ok',
        isLoader: false,
        content: const Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(
            width: 100,
            height: 100,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Something Went Wrong !!',
                    style: TextStyle(color: Colors.red),
                  )
                ],
              ),
            ),
          ),
        ),
        onPrimaryButtonPressed: () {
          Get.back();
        },
      ));
    }
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
    if (response.statusCode == 500) {
      Get.dialog(GenericDialogBox(
        enableSecondaryButton: false,
        primaryButtonText: 'Ok',
        isLoader: false,
        content: const Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(
            width: 100,
            height: 100,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Something Went Wrong !!',
                    style: TextStyle(color: Colors.red),
                  )
                ],
              ),
            ),
          ),
        ),
        onPrimaryButtonPressed: () {
          Get.back();
        },
      ));
    }
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
    if (response.statusCode == 500) {
      Get.dialog(GenericDialogBox(
        enableSecondaryButton: false,
        primaryButtonText: 'Ok',
        isLoader: false,
        content: const Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(
            width: 100,
            height: 100,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Something Went Wrong !!',
                    style: TextStyle(color: Colors.red),
                  )
                ],
              ),
            ),
          ),
        ),
        onPrimaryButtonPressed: () {
          Get.back();
        },
      ));
    }
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
