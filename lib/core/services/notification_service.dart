import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shehabapp/core/models/attachment_model.dart';
import 'package:shehabapp/core/models/create_notification_model.dart';

class NotificationService {
  Future<CreateNotificationModel> getNotificationList({
    required int projectId,
    required int partId,
    required int flowId,
    required int procId,
    int? doneFlag,
  }) async {
    try {
      String url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/ProjectsPartsProcNotifVO1?q=ProjectId=$projectId;PartId=$partId;FlowId=$flowId;ProcId=$procId';

      // Add doneFlag to query if provided
      if (doneFlag != null) {
        url += ';DoneFlag=$doneFlag';
      }

      // طباعة بيانات الـ Request
      print('🔵 ========== Notification Request ==========');
      print('📤 URL: $url');
      print('📤 ProjectId: $projectId');
      print('📤 PartId: $partId');
      print('📤 FlowId: $flowId');
      print('📤 ProcId: $procId');
      print('📤 DoneFlag: $doneFlag');
      print('🔵 ==========================================');

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
    required int projectId,
    required int partId,
    required int flowId,
    required int procId,
    required int noteSer,
  }) async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/ProjectsPartsProcNotifVO1?q=ProjectId=$projectId;PartId=$partId;FlowId=$flowId;ProcId=$procId;NoteSer=$noteSer';
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

  Future<AttatchmentModel> getAllNotificationAttachments({
    required int projectId,
    required int partId,
    required int flowId,
    required int procId,
    required int noteSer,
  }) async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/SysDocsVO1?q=TblNm=PROJECTS_PARTS_PROC_NOTIF';
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
        return AttatchmentModel.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to load notification details - Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load notification details: $e');
    }
  }

  Future<AttatchmentModel> getNotificationAttachments({
    required int projectId,
    required int partId,
    required int flowId,
    required int procId,
    required int noteSer,
  }) async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/SysDocsVO1?q=TblNm=PROJECTS_PARTS_PROC_NOTIF;Pk1=$projectId;Pk2=$partId;Pk3=$flowId;Pk4=$procId;Pk5=$noteSer';
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
        return AttatchmentModel.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to load notification details - Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load notification details: $e');
    }
  }

  Future<void> createNotification({
    required int projectId,
    required int partId,
    required int flowId,
    required int procId,
    required int noteSer,
  }) async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/ProjectsPartsProcNotifVO1';
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type":
              "application/vnd.oracle.adf.resourceitem+json; charset=UTF-8",
        },
        body: jsonEncode({
          'ProjectId': projectId,
          'PartId': partId,
          'FlowId': flowId,
          'ProcId': procId,
          'NoteSer': noteSer,
        }),
      );

      if (response.statusCode == 200) {
        log('✅ Successfully uploaded attachment', name: 'NotificationService');
        log('🔵 Response Body: ${response.body}', name: 'NotificationService');
      } else {
        throw Exception(
          'Failed to load notification details - Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load notification details: $e');
    }
  }

  Future<void> uploadNotificationAttachment({
    required int projectId,
    required int partId,
    required int flowId,
    required int procId,
    required int noteSer,
    required int docSerial,
    required String docPath,
    required String fileDesc,
    required String fileContent,
  }) async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/SysDocsVO1';

      log(
        '🔵 [NotificationService] Upload Request URL: $url',
        name: 'NotificationService',
      );
      log(
        '🔵 [NotificationService] Request Parameters:',
        name: 'NotificationService',
      );
      log('   ProjectId: $projectId', name: 'NotificationService');
      log('   PartId: $partId', name: 'NotificationService');
      log('   FlowId: $flowId', name: 'NotificationService');
      log('   ProcId: $procId', name: 'NotificationService');
      log('   NoteSer: $noteSer', name: 'NotificationService');
      log('   DocSerial: $docSerial', name: 'NotificationService');
      log('   FileDesc: $fileDesc', name: 'NotificationService');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type":
              "application/vnd.oracle.adf.resourceitem+json; charset=UTF-8",
        },
        body: jsonEncode({
          'TblNm': 'PROJECTS_PARTS_PROC_NOTIF',
          'Pk1': projectId,
          'Pk2': partId,
          'Pk3': flowId,
          'Pk4': procId,
          'Pk5': noteSer,
          'DocSerial': docSerial,
          'DocPath': docPath,
          'FileDesc': fileDesc,
          'Photo64': fileContent,
        }),
      );

      log(
        '🔵 [NotificationService] Response Status: ${response.statusCode}',
        name: 'NotificationService',
      );
      log(
        '🔵 [NotificationService] Response Body: ${response.body}',
        name: 'NotificationService',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log(
          '✅ Successfully uploaded notification attachment',
          name: 'NotificationService',
        );
      } else {
        throw Exception(
          'Failed to upload attachment - Status: ${response.statusCode}, Body: ${response.body}',
        );
      }
    } catch (e) {
      log(
        '💥 Exception in uploadNotificationAttachment: $e',
        name: 'NotificationService',
      );
      throw Exception('Failed to upload notification attachment: $e');
    }
  }
}
