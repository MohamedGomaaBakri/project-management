import 'dart:convert'; // ضروري جداً عشان utf8
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shehabapp/core/api/api_constants.dart';
import 'package:shehabapp/core/models/attpermitcheck_model.dart';
import 'package:shehabapp/core/models/permissions_list_model.dart';
import 'package:shehabapp/core/models/task_permission_model.dart';
import 'package:shehabapp/core/models/zones_list_model.dart';

class TaskPermissionService {
  // -----------------------
  // 1. Get Permission Details
  // -----------------------
  Future<PermissionModel> getPermissionDetails(int projectId) async {
    try {
      final url =
          '${ApiConstants.baseUrl}${ApiConstants.getPermissionDetails}$projectId';
      log('🔵 Request URL: $url', name: 'TaskPermissionService');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          // هذا الهيدر يطلب من السيرفر الرد بـ UTF-8، لكن أحياناً السيرفر يتجاهله
          "Content-Type":
              "application/vnd.oracle.adf.resourceitem+json; charset=UTF-8",
        },
      );

      log(
        '🔵 Response Status Code: ${response.statusCode}',
        name: 'TaskPermissionService',
      );
      // للتأكد في اللوج، سنطبع النص بعد فك التشفير
      // log('🔵 Response Body: ${response.body}', name: 'TaskPermissionService'); // ❌ القديم

      if (response.statusCode == 200) {
        // ✅ الحل هنا: فك التشفير يدوياً من الـ Bytes
        String decodedBody = utf8.decode(response.bodyBytes);
        log(
          '🔵 Response Body (Decoded): $decodedBody',
          name: 'TaskPermissionService',
        ); // ستظهر العربي صح هنا

        final jsonData = jsonDecode(decodedBody);

        log('✅ Successfully parsed JSON data', name: 'TaskPermissionService');
        return PermissionModel.fromJson(jsonData);
      } else {
        log(
          '❌ Failed with status code: ${response.statusCode}',
          name: 'TaskPermissionService',
        );
        throw Exception(
          'Failed to load permission details - Status: ${response.statusCode}',
        );
      }
    } catch (e, stackTrace) {
      log('💥 Exception occurred: $e', name: 'TaskPermissionService');
      log('💥 Stack trace: $stackTrace', name: 'TaskPermissionService');
      throw Exception('Failed to load permission details: $e');
    }
  }

  // -----------------------
  // 2. Get Permission List
  // -----------------------
  Future<PermissionListModel> getPermissionList() async {
    try {
      final url = '${ApiConstants.baseUrl}${ApiConstants.getPermissionList}';
      log('🔵 Request URL: $url', name: 'TaskPermissionService');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type":
              "application/vnd.oracle.adf.resourceitem+json; charset=UTF-8",
        },
      );

      log(
        '🔵 Response Status Code: ${response.statusCode}',
        name: 'TaskPermissionService',
      );

      if (response.statusCode == 200) {
        // ✅ الحل هنا
        String decodedBody = utf8.decode(response.bodyBytes);

        final jsonData = jsonDecode(decodedBody);
        log('✅ Successfully parsed JSON data', name: 'TaskPermissionService');
        return PermissionListModel.fromJson(jsonData);
      } else {
        log(
          '❌ Failed with status code: ${response.statusCode}',
          name: 'TaskPermissionService',
        );
        throw Exception(
          'Failed to load permission details - Status: ${response.statusCode}',
        );
      }
    } catch (e, stackTrace) {
      log('💥 Exception occurred: $e', name: 'TaskPermissionService');
      log('💥 Stack trace: $stackTrace', name: 'TaskPermissionService');
      throw Exception('Failed to load permission details: $e');
    }
  }

  // -----------------------
  // 3. Get Zones List
  // -----------------------
  Future<ZonesListModel> getZonesList() async {
    try {
      final url = '${ApiConstants.baseUrl}${ApiConstants.getZonesList}';
      log('🔵 Request URL: $url', name: 'TaskPermissionService');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type":
              "application/vnd.oracle.adf.resourceitem+json; charset=UTF-8",
        },
      );

      log(
        '🔵 Response Status Code: ${response.statusCode}',
        name: 'TaskPermissionService',
      );

      if (response.statusCode == 200) {
        // ✅ الحل هنا
        String decodedBody = utf8.decode(response.bodyBytes);

        final jsonData = jsonDecode(decodedBody);
        log('✅ Successfully parsed JSON data', name: 'TaskPermissionService');
        return ZonesListModel.fromJson(jsonData);
      } else {
        log(
          '❌ Failed with status code: ${response.statusCode}',
          name: 'TaskPermissionService',
        );
        throw Exception(
          'Failed to load permission details - Status: ${response.statusCode}',
        );
      }
    } catch (e, stackTrace) {
      log('💥 Exception occurred: $e', name: 'TaskPermissionService');
      log('💥 Stack trace: $stackTrace', name: 'TaskPermissionService');
      throw Exception('Failed to load permission details: $e');
    }
  }

  Future<AttpermitcheckModel> getAttpermitcheck(int projectId) async {
    try {
      final url =
          '${ApiConstants.baseUrl}${ApiConstants.Attpermitcheck}$projectId';
      log('🔵 Request URL: $url', name: 'TaskPermissionService');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type":
              "application/vnd.oracle.adf.resourceitem+json; charset=UTF-8",
        },
      );

      log(
        '🔵 Response Status Code: ${response.statusCode}',
        name: 'TaskPermissionService',
      );

      if (response.statusCode == 200) {
        String decodedBody = utf8.decode(response.bodyBytes);

        final jsonData = jsonDecode(decodedBody);
        log('✅ Successfully parsed JSON data', name: 'TaskPermissionService');
        log('🔵 Response Body: $jsonData', name: 'TaskPermissionService');
        return AttpermitcheckModel.fromJson(jsonData);
      } else {
        log(
          '❌ Failed with status code: ${response.statusCode}',
          name: 'TaskPermissionService',
        );
        throw Exception(
          'Failed to load permission details - Status: ${response.statusCode}',
        );
      }
    } catch (e, stackTrace) {
      log('💥 Exception occurred: $e', name: 'TaskPermissionService');
      log('💥 Stack trace: $stackTrace', name: 'TaskPermissionService');
      throw Exception('Failed to load permission details: $e');
    }
  }

  Future<void> updateDoneFlag(
    String altKey,
    int doneFlag,
    String doneDate,
  ) async {
    try {
      final url =
          '${ApiConstants.baseUrl}${ApiConstants.updateDoneFlag}$altKey';
      log('🔵 Request URL: $url', name: 'TaskPermissionService');
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          "Content-Type":
              "application/vnd.oracle.adf.resourceitem+json; charset=UTF-8",
        },
        body: jsonEncode({'DoneFlag': doneFlag, 'DoneDate': doneDate}),
      );
      if (response.statusCode == 200) {
        log('✅ Successfully updated done flag', name: 'TaskPermissionService');
      } else {
        log(
          '❌ Failed with status code: ${response.statusCode}',
          name: 'TaskPermissionService',
        );
        throw Exception('Failed to update done flag: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      log('💥 Exception occurred: $e', name: 'TaskPermissionService');
      log('💥 Stack trace: $stackTrace', name: 'TaskPermissionService');
      throw Exception('Failed to update done flag: $e');
    }
  }

  Future<void> createPermission(PermissionModel permission) async {
    try {
      final url = '${ApiConstants.baseUrl}${ApiConstants.createPermission}';
      log('🔵 Request URL: $url', name: 'TaskPermissionService');
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type":
              "application/vnd.oracle.adf.resourceitem+json; charset=UTF-8",
        },
        body: jsonEncode(permission.toJson()),
      );
      if (response.statusCode == 200) {
        log('✅ Successfully created permission', name: 'TaskPermissionService');
      } else {
        log(
          '❌ Failed with status code: ${response.statusCode}',
          name: 'TaskPermissionService',
        );
        throw Exception('Failed to create permission: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      log('💥 Exception occurred: $e', name: 'TaskPermissionService');
      log('💥 Stack trace: $stackTrace', name: 'TaskPermissionService');
      throw Exception('Failed to create permission: $e');
    }
  }
}
