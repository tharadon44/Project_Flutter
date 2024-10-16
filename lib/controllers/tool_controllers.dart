import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:testlab/controllers/auth_service.dart';
import 'package:testlab/models/tool_model.dart';
import 'package:testlab/providers/usar_providers.dart';
import 'package:testlab/varbles.dart';

class toolController {
  final _AuthService = AuthService();

  Future<List<UserTool>> getTools(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;

    try {
      final response = await http.get(
        Uri.parse('$apiURL/api/tools/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${accessToken}", // ใส่ accessToken ใน header
        },
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        // Decode the response and map it to ProductModel objects
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((tool) => UserTool.fromJson(tool)).toList();
      } else if (response.statusCode == 401) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        throw Exception(
            'Refresh token expired. Please login again.'); // เพิ่ม throw Exception
      } else if (response.statusCode == 403) {
        // Refresh token and retry
        await _AuthService.refreshToken(context);
        accessToken = userProvider.accessToken;
        return await getTools(context);
      } else {
        throw Exception(
            'Failed to load tools with status code: ${response.statusCode}');
      } 
    } catch (err) {
      // If the request failed, throw an error
      print(err);
      throw Exception('Failed to load tools');
    }
  }

  Future<http.Response> Inserttool(
      BuildContext context,
      String dateTime,
      String timeIn,
      String timeOut,
      String toolName,
      String userName,
      String phone,
      String objective,
      String adviser) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;
    final Map<String, dynamic> InsertData = {
      "date_time": dateTime,
      "time_in": timeIn,
      "time_out": timeOut,
      "tool_name": toolName,
      "user_name": userName,
      "phone": phone,
      "objective": objective,
      "adviser": adviser,
    };
    try {
      // Make POST request to insert the product
      final response = await http.post(
        Uri.parse("$apiURL/api/tools"), // Replace with the correct API endpoint
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken" // Attach accessToken
        },
        body: jsonEncode(InsertData),
      );

      // Handle successful product insertion
      if (response.statusCode == 201) {
        print("Product inserted successfully!");
        return response; // ส่งคืน response เมื่อเพิ่มสินค้าสำเร็จ
      } else if (response.statusCode == 403) {
        await _AuthService.refreshToken(context);
        accessToken = userProvider.accessToken;

        return await Inserttool(context, dateTime, timeIn, timeOut, toolName,
            userName, phone, objective, adviser);
      } else {
        return response; // ส่งคืน response
      }
    } catch (error) {
      // Catch and print any errors during the request
      throw Exception('Failed to insert product');
    }
  }

  Future<http.Response> updatetool(
      BuildContext context,
      String dateTime,
      String timeIn,
      String timeOut,
      String toolName,
      String userName,
      String phone,
      String objective,
      String adviser,
      String toolID) async {
    // ใช้ toolID ตรงนี้
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;

    final Map<String, dynamic> updateData = {
      "date_time": dateTime,
      "time_in": timeIn,
      "time_out": timeOut,
      "tool_name": toolName,
      "user_name": userName,
      "phone": phone,
      "objective": objective,
      "adviser": adviser,
    };

    try {
      // Make PUT request to update the tool
      final response = await http.put(
        Uri.parse("$apiURL/api/tool/$toolID"), // แก้ไขเป็น toolID
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken" // Attach accessToken
        },
        body: jsonEncode(updateData),
      );
      // Handle successful tool update
      if (response.statusCode == 200) {
        print("tool updated successfully!");
        return response;
      } else if (response.statusCode == 403) {
        // Refresh the accessToken
        await _AuthService.refreshToken(context);
        accessToken = userProvider.accessToken;

        return await updatetool(context, dateTime, timeIn, timeOut, toolName,
            userName, phone, objective, adviser, toolID);
      } else {
        return response;
      }
    } catch (error) {
      throw Exception('Failed to update tool');
    }
  }

  Future<http.Response> deleteTool(BuildContext context, String toolId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;

    try {
      final response = await http.delete(
        Uri.parse("$apiURL/api/tool/$toolId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
      );

      if (response.statusCode == 200) {
        print("Product deleted successfully!");
        return response; // ส่งคืน response
      } else if (response.statusCode == 403) {
        // Refresh the accessToken
        await _AuthService.refreshToken(context);
        accessToken = userProvider.accessToken;

        return await deleteTool(context, toolId);
      } else {
        return response; // ส่งคืน response
      }
    } catch (error) {
      print(error);
      throw Exception('Failed to delete product due to error: $error');
    }
  }
}