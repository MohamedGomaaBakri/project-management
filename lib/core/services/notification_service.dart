import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shehabapp/core/models/all_notification_model.dart';
import 'package:shehabapp/core/models/attachment_model.dart';
import 'package:shehabapp/core/models/create_notification_model.dart';
import 'package:shehabapp/core/models/users_model.dart';
import 'package:shehabapp/core/models/users_type_model.dart';

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
    required dynamic projectId,
    required dynamic partId,
    required dynamic flowId,
    required dynamic procId,
    required dynamic noteSer,
    required dynamic docSerial,
    required dynamic docPath,
    required dynamic fileDesc,
    required dynamic fileContent,
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
      log('   Pk1: $projectId', name: 'NotificationService');
      log('   Pk2: $partId', name: 'NotificationService');
      log('   Pk3: $flowId', name: 'NotificationService');
      log('   Pk4: $procId', name: 'NotificationService');
      log('   Pk5: $noteSer', name: 'NotificationService');
      log('   DocSerial: $docSerial', name: 'NotificationService');
      log('   DocPath: $docPath', name: 'NotificationService');
      log('   FileDesc: $fileDesc', name: 'NotificationService');
      log('   Photo64: $fileContent', name: 'NotificationService');

      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'TblNm': 'PROJECTS_PARTS_PROC_NOTIF',
          'Pk1': projectId.toString(),
          'Pk2': partId.toString(),
          'Pk3': flowId.toString(),
          'Pk4': procId.toString(),
          'Pk5': noteSer.toString(),
          'DocSerial': docSerial.toString(),
          'DocPath': docPath.toString(),
          'FileDesc': fileDesc.toString(),
          'Photo': fileContent.toString(),
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

  Future<UsersModel> getNotificationUsers() async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/EXNotifUsersVRO1';
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
        return UsersModel.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to load notification details - Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load notification details: $e');
    }
  }

  Future<UsersTypeModel> getUsersType({
    required int usersCode,
    required int projectId,
  }) async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/ExNotifTypesVRO1?q=UsersCode=$usersCode;ProjectId=$projectId';
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
        return UsersTypeModel.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to load notification details - Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load notification details: $e');
    }
  }

  Future<AllNotificationsModel> getAllNotifications() async {
    try {
      final url =
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
        return AllNotificationsModel.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to load notification details - Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load notification details: $e');
    }
  }

  Future<void> uploadNewNotification({
    required int projectId,
    required int flowId,
    required int partId,
    required int procId,
    required int noteSer,
    required int userType,
    required int userCode,
    required int noteType,
    required String noteDate,
    required String descA,
    required int insertUser,
  }) async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/ProjectsPartsProcNotifVO1';

      final requestBody = {
        'ProjectId': projectId.toString(),
        'FlowId': flowId.toString(),
        'PartId': partId.toString(),
        'ProcId': procId.toString(),
        'NoteSer': noteSer.toString(),
        'UserType': userType.toString(),
        'UserCode': userCode.toString(),
        'NoteType': noteType.toString(),
        'NoteDate': noteDate,
        'DescA': descA,
        'InsertUser': insertUser.toString(),
      };

      log(
        '🔵 [NotificationService] Creating new notification',
        name: 'NotificationService',
      );
      log('🔵 Request Body: $requestBody', name: 'NotificationService');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type":
              "application/vnd.oracle.adf.resourceitem+json; charset=UTF-8",
        },
        body: jsonEncode(requestBody),
      );

      log(
        '🔵 Response Status: ${response.statusCode}',
        name: 'NotificationService',
      );
      log('🔵 Response Body: ${response.body}', name: 'NotificationService');

      if (response.statusCode == 200 || response.statusCode == 201) {
        log(
          '✅ Successfully uploaded new notification',
          name: 'NotificationService',
        );
      } else {
        throw Exception(
          'Failed to upload new notification - Status: ${response.statusCode}, Body: ${response.body}',
        );
      }
    } catch (e) {
      log(
        '💥 Exception in uploadNewNotification: $e',
        name: 'NotificationService',
      );
      throw Exception('Failed to upload new notification: $e');
    }
  }

  Future<int> getMaxNoteSer() async {
    try {
      final allNotifications = await getAllNotifications();

      if (allNotifications.items == null || allNotifications.items!.isEmpty) {
        return 0;
      }

      int maxNoteSer = 0;
      for (var item in allNotifications.items!) {
        if (item.noteSer != null && item.noteSer! > maxNoteSer) {
          maxNoteSer = item.noteSer!;
        }
      }

      log('🔵 Max NoteSer found: $maxNoteSer', name: 'NotificationService');

      return maxNoteSer;
    } catch (e) {
      log('💥 Exception in getMaxNoteSer: $e', name: 'NotificationService');
      return 0;
    }
  }

  Future<UsersTypeModel> getAllUsersTypes({required int projectId}) async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/ExNotifTypesVRO1?q=ProjectId=$projectId';

      log(
        '🔵 [NotificationService] Fetching all user types for project: $projectId',
        name: 'NotificationService',
      );

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
        final model = UsersTypeModel.fromJson(jsonData);

        log(
          '🔵 [NotificationService] Loaded ${model.items?.length ?? 0} user types',
          name: 'NotificationService',
        );

        return model;
      } else {
        throw Exception(
          'Failed to load user types - Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      log(
        '💥 [NotificationService] Exception in getAllUsersTypes: $e',
        name: 'NotificationService',
      );
      throw Exception('Failed to load user types: $e');
    }
  }
}
