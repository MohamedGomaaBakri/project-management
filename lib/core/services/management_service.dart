import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shehabapp/core/models/create_notification_model.dart';
import 'package:shehabapp/core/models/mng_notif_cnt_model.dart';
import 'package:shehabapp/core/models/mng_permit_cnt_model.dart';
import 'package:shehabapp/core/models/mng_proc_cnt_model.dart';

class ManagementService {
  Future<MngNotifCntModel> getNotificationCount() async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/ExProjectsNotifCnt1';
      log('🌐 API Request URL: $url', name: 'getNotificationCount');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        // log(
        //   '✅ API Response (getProjects): $responseBody',
        //   name: 'DailyTasksService',
        // );

        final MngNotifCntModel notificationCountModel =
            MngNotifCntModel.fromJson(json.decode(responseBody));
        return notificationCountModel;
      } else {
        log(
          '❌ API Error (${response.statusCode}): ${response.body}',
          name: 'getNotificationCount',
        );
        throw Exception('Failed to load notification count data.');
      }
    } catch (e) {
      log(
        '💥 Exception in getNotificationCount: $e',
        name: 'getNotificationCount',
      );
      throw Exception(
        'An error occurred while fetching notification count: $e',
      );
    }
  }

  Future<MngPermitCntModel> getPermitCount() async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/ExProjectsPermitCnt1';
      log('🌐 API Request URL: $url', name: 'getPermitCount');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        // log(
        //   '✅ API Response (getProjects): $responseBody',
        //   name: 'DailyTasksService',
        // );

        final MngPermitCntModel permitModel = MngPermitCntModel.fromJson(
          json.decode(responseBody),
        );
        return permitModel;
      } else {
        log(
          '❌ API Error (${response.statusCode}): ${response.body}',
          name: 'getPermitCount',
        );
        throw Exception('Failed to load permit count data.');
      }
    } catch (e) {
      log('💥 Exception in getPermitCount: $e', name: 'getPermitCount');
      throw Exception('An error occurred while fetching permit count: $e');
    }
  }

  Future<MngProcCntModel> getProcCount() async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/ExProjectsProcCnt1';
      log('🌐 API Request URL: $url', name: 'getProcCount');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        // log(
        //   '✅ API Response (getProjects): $responseBody',
        //   name: 'DailyTasksService',
        // );

        final MngProcCntModel procModel = MngProcCntModel.fromJson(
          json.decode(responseBody),
        );
        return procModel;
      } else {
        log(
          '❌ API Error (${response.statusCode}): ${response.body}',
          name: 'getProcCount',
        );
        throw Exception('Failed to load proc count data.');
      }
    } catch (e) {
      log('💥 Exception in getProcCount: $e', name: 'getProcCount');
      throw Exception('An error occurred while fetching proc count: $e');
    }
  }

  Future<CreateNotificationModel> getNotificationList() async {
    try {
      String url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/ProjectsPartsProcNotifVO1';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type":
              "application/vnd.oracle.adf.resourceitem+json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        String decodedBody = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(decodedBody);

        // طباعة بيانات الـ Response
        print('🟢 ========== Notification Response ==========');
        print('📥 Status Code: ${response.statusCode}');
        print('📥 Response Data: $jsonData');
        if (jsonData['items'] != null && jsonData['items'].isNotEmpty) {
          print('📥 First Item: ${jsonData['items'][0]}');
          print('📥 Total Items: ${jsonData['items'].length}');
        }
        print('🟢 ============================================');

        return CreateNotificationModel.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to load permission details - Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load permission details: $e');
    }
  }

  Future<CreateNotificationModel> getNotificationDetails({
    required String altKey,
  }) async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/ProjectsPartsProcNotifVO1?q=AltKey=$altKey';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type":
              "application/vnd.oracle.adf.resourceitem+json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        String decodedBody = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(decodedBody);
        return CreateNotificationModel.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to load notification details - Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load notification details: $e');
    }
  }
}
