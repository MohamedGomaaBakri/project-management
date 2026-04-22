import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shehabapp/core/api/api_constants.dart';
import 'package:shehabapp/core/models/attachment_model.dart';
import 'package:shehabapp/core/models/band_list_model.dart';
import 'package:shehabapp/core/models/task_and_approvals_model.dart';
import 'package:shehabapp/core/models/teams_model.dart';

class RequestMaterialFromStoreService {
  Future<TasksAndApprovalsModel> getTasksAndApprovals({
    required int teamCode,
    required dynamic teamType,
  }) async {
    try {
      final url =
          '${ApiConstants.baseUrl}${ApiConstants.getTasksAndApprovals}$teamCode;TeamType=$teamType';
      log('🔵 Request URL: $url', name: 'RequestMaterialFromStoreService');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type":
              "application/vnd.oracle.adf.resourceitem+json; charset=UTF-8",
        },
      );

      log(
        '🔵 Response Status Code: ${response.statusCode}',
        name: 'RequestMaterialFromStoreService',
      );

      if (response.statusCode == 200) {
        // ✅ الحل هنا
        String decodedBody = utf8.decode(response.bodyBytes);

        final jsonData = jsonDecode(decodedBody);
        log(
          '✅ Successfully parsed JSON data',
          name: 'RequestMaterialFromStoreService',
        );
        return TasksAndApprovalsModel.fromJson(jsonData);
      } else {
        log(
          '❌ Failed with status code: ${response.statusCode}',
          name: 'RequestMaterialFromStoreService',
        );
        throw Exception(
          'Failed to load tasks and approvals - Status: ${response.statusCode}',
        );
      }
    } catch (e, stackTrace) {
      log('💥 Exception occurred: $e', name: 'RequestMaterialFromStoreService');
      log(
        '💥 Stack trace: $stackTrace',
        name: 'RequestMaterialFromStoreService',
      );
      throw Exception('Failed to load tasks and approvals: $e');
    }
  }

  Future<TasksAndApprovalsModel> getOneTasksAndApprovals({
    required int teamCode,
    required int serial,
  }) async {
    try {
      final url =
          '${ApiConstants.baseUrl}${ApiConstants.getTasksAndApprovals}$teamCode;Serial=$serial';
      log('🔵 Request URL: $url', name: 'RequestMaterialFromStoreService');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type":
              "application/vnd.oracle.adf.resourceitem+json; charset=UTF-8",
        },
      );

      log(
        '🔵 Response Status Code: ${response.statusCode}',
        name: 'RequestMaterialFromStoreService',
      );

      if (response.statusCode == 200) {
        // ✅ الحل هنا
        String decodedBody = utf8.decode(response.bodyBytes);

        final jsonData = jsonDecode(decodedBody);
        log(
          '✅ Successfully parsed JSON data',
          name: 'RequestMaterialFromStoreService',
        );
        return TasksAndApprovalsModel.fromJson(jsonData);
      } else {
        log(
          '❌ Failed with status code: ${response.statusCode}',
          name: 'RequestMaterialFromStoreService',
        );
        throw Exception(
          'Failed to load one task and approvals - Status: ${response.statusCode}',
        );
      }
    } catch (e, stackTrace) {
      log('💥 Exception occurred: $e', name: 'RequestMaterialFromStoreService');
      log(
        '💥 Stack trace: $stackTrace',
        name: 'RequestMaterialFromStoreService',
      );
      throw Exception('Failed to load one task and approvals: $e');
    }
  }

  Future<void> updateOneTasksAndApprovals({
    required String altKey,
    required String trnsDate,
    required int bandCode,
    required int bandCodeDet,
    required int unitCode,
    required double quantity,
    required String notes,
    required String authDesc,
    // required String authUserName,
    required String authDate,
    int? authFlag,
  }) async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/ExProjectsBandExecVO1/$altKey';
      log('🔵 Request URL: $url', name: 'RequestMaterialFromStoreService');

      // Log request body before sending
      final requestBody = jsonEncode({
        "TrnsDate": trnsDate,
        "BandCode": bandCode,
        "BandCodeDet": bandCodeDet,
        "UnitCode": unitCode,
        "Quantity": quantity,
        "Notes": notes,
        "AuthDesc": authDesc,
        // "AuthUserName": authUserName,
        "AuthDate": authDate,
        if (authFlag != null) "AuthFlag": authFlag,
      });
      log(
        '📦 Request Body: $requestBody',
        name: 'RequestMaterialFromStoreService',
      );

      final response = await http.patch(
        Uri.parse(url),
        body: requestBody,
        headers: {
          "Content-Type":
              "application/vnd.oracle.adf.resourceitem+json; charset=UTF-8",
        },
      );

      log(
        '🔵 Response Status Code: ${response.statusCode}',
        name: 'RequestMaterialFromStoreService',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('✅ Update successful', name: 'RequestMaterialFromStoreService');
      } else {
        final errorBody = utf8.decode(response.bodyBytes);
        log(
          '❌ Failed with status code: ${response.statusCode}',
          name: 'RequestMaterialFromStoreService',
        );
        log(
          '❌ Error Response Body: $errorBody',
          name: 'RequestMaterialFromStoreService',
        );
        throw Exception(
          'Failed to update task - Status: ${response.statusCode} | $errorBody',
        );
      }
    } catch (e, stackTrace) {
      log('💥 Exception occurred: $e', name: 'RequestMaterialFromStoreService');
      log(
        '💥 Stack trace: $stackTrace',
        name: 'RequestMaterialFromStoreService',
      );
      throw Exception('Failed to load one task and approvals: $e');
    }
  }

  Future<void> deleteOneTasksAndApprovals({required String altKey}) async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/ExProjectsBandExecVO1/$altKey';
      log('🔵 Request URL: $url', name: 'RequestMaterialFromStoreService');

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          "Content-Type":
              "application/vnd.oracle.adf.resourceitem+json; charset=UTF-8",
        },
      );

      log(
        '🔵 Response Status Code: ${response.statusCode}',
        name: 'RequestMaterialFromStoreService',
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        log('✅ Delete successful', name: 'RequestMaterialFromStoreService');
      } else {
        final errorBody = utf8.decode(response.bodyBytes);
        log(
          '❌ Failed with status code: ${response.statusCode}',
          name: 'RequestMaterialFromStoreService',
        );
        log(
          '❌ Error Response Body: $errorBody',
          name: 'RequestMaterialFromStoreService',
        );
        throw Exception(
          'Failed to delete task - Status: ${response.statusCode} | $errorBody',
        );
      }
    } catch (e, stackTrace) {
      log('💥 Exception occurred: $e', name: 'RequestMaterialFromStoreService');
      log(
        '💥 Stack trace: $stackTrace',
        name: 'RequestMaterialFromStoreService',
      );
      throw Exception('Failed to load one task and approvals: $e');
    }
  }

  Future<void> addOneTasksAndApprovals({
    required int teamCode,
    required dynamic teamType,
    required int serial,
    required String trnsDate,
    required int bandCode,
    required int bandCodeDet,
    required int unitCode,
    required double quantity,
    required String notes,
    required int insertUser,
    required String insertDate,
  }) async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/ExProjectsBandExecVO1';
      log('🔵 Request URL: $url', name: 'RequestMaterialFromStoreService');

      // Log request body before sending
      final requestBody = jsonEncode({
        "TeamCode": teamCode,
        "TeamType": teamType,
        "Serial": serial,
        "TrnsDate": trnsDate,
        "BandCode": bandCode,
        "BandCodeDet": bandCodeDet,
        "UnitCode": unitCode,
        "Quantity": quantity,
        "Notes": notes,
        "InsertUser": insertUser,
        "InsertDate": insertDate,
      });
      log(
        '📦 Request Body: $requestBody',
        name: 'RequestMaterialFromStoreService',
      );

      final response = await http.post(
        Uri.parse(url),
        body: requestBody,
        headers: {
          "Content-Type":
              "application/vnd.oracle.adf.resourceitem+json; charset=UTF-8",
        },
      );

      log(
        '🔵 Response Status Code: ${response.statusCode}',
        name: 'RequestMaterialFromStoreService',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('✅ Update successful', name: 'RequestMaterialFromStoreService');
      } else {
        final errorBody = utf8.decode(response.bodyBytes);
        log(
          '❌ Failed with status code: ${response.statusCode}',
          name: 'RequestMaterialFromStoreService',
        );
        log(
          '❌ Error Response Body: $errorBody',
          name: 'RequestMaterialFromStoreService',
        );
        throw Exception(
          'Failed to update task - Status: ${response.statusCode} | $errorBody',
        );
      }
    } catch (e, stackTrace) {
      log('💥 Exception occurred: $e', name: 'RequestMaterialFromStoreService');
      log(
        '💥 Stack trace: $stackTrace',
        name: 'RequestMaterialFromStoreService',
      );
      throw Exception('Failed to load one task and approvals: $e');
    }
  }

  Future<BandListModel> getBandList({
    required int teamCode,
    required int teamType,
  }) async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/ExBandCodeExecVRO1?q=TeamCode=$teamCode;TeamType=$teamType';
      log('🌐 API Request URL: $url', name: 'getBandList');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        log('✅ API Response (getBandList): $responseBody', name: 'getBandList');

        final BandListModel bandListModel = BandListModel.fromJson(
          json.decode(responseBody),
        );
        return bandListModel;
      } else {
        log(
          '❌ API Error (${response.statusCode}): ${response.body}',
          name: 'getBandList',
        );
        throw Exception('Failed to load band list data.');
      }
    } catch (e) {
      log('💥 Exception in getBandList: $e', name: 'getBandList');
      throw Exception('An error occurred while fetching band list: $e');
    }
  }

  Future<AttatchmentModel> getTaskAttachment({
    required String pk1,
    required String pk2,
  }) async {
    try {
      final url =
          '${ApiConstants.baseUrl}SysDocsVO1?q=TblNm=PROJECTS_BAND_EXEC;Pk1=$pk1;Pk2=$pk2';
      log('🌐 API Request URL: $url', name: 'getTaskAttachment');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        log(
          '✅ API Response (getTaskAttachment): $responseBody',
          name: 'getTaskAttachment',
        );

        final AttatchmentModel attatchmentModel = AttatchmentModel.fromJson(
          json.decode(responseBody),
        );
        return attatchmentModel;
      } else {
        log(
          '❌ API Error (${response.statusCode}): ${response.body}',
          name: 'getTaskAttachment',
        );
        throw Exception('Failed to load task attachment data.');
      }
    } catch (e) {
      log('💥 Exception in getTaskAttachment: $e', name: 'getTaskAttachment');
      throw Exception('An error occurred while fetching task attachment: $e');
    }
  }

  Future<int> getMaxDocSerial() async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/SysDocsVO1?q=TblNm=PROJECTS_BAND_EXEC';
      log('🌐 API Request URL: $url', name: 'getMaxDocSerial');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        log(
          '✅ API Response (getMaxDocSerial): $responseBody',
          name: 'getMaxDocSerial',
        );

        final AttatchmentModel attachmentModel = AttatchmentModel.fromJson(
          json.decode(responseBody),
        );

        // Find the maximum DocSerial value
        int maxDocSerial = 0;
        if (attachmentModel.items != null &&
            attachmentModel.items!.isNotEmpty) {
          for (var item in attachmentModel.items!) {
            if (item.docSerial != null && item.docSerial! > maxDocSerial) {
              maxDocSerial = item.docSerial!;
            }
          }
        }

        log('✅ Max DocSerial found: $maxDocSerial', name: 'getMaxDocSerial');
        return maxDocSerial;
      } else {
        log(
          '❌ API Error (${response.statusCode}): ${response.body}',
          name: 'getMaxDocSerial',
        );
        throw Exception('Failed to load max DocSerial data.');
      }
    } catch (e) {
      log('💥 Exception in getMaxDocSerial: $e', name: 'getMaxDocSerial');
      throw Exception('An error occurred while fetching max DocSerial: $e');
    }
  }

  Future<void> uploadAttachment({
    required String pk1,
    required String pk2,
    required String fileDesc,
    required String fileContent,
  }) async {
    try {
      // Fetch the maximum DocSerial and add 1
      final maxDocSerial = await getMaxDocSerial();
      final newDocSerial = maxDocSerial + 1;
      log(
        '🔵 New DocSerial to be used: $newDocSerial',
        name: 'RequestMaterialFromStoreService',
      );

      final url = '${ApiConstants.baseUrl}${ApiConstants.uploadAttachment}';
      log('🔵 Request URL: $url', name: 'RequestMaterialFromStoreService');

      final requestBody = {
        'TblNm': 'PROJECTS_BAND_EXEC',
        'Pk1': pk1,
        'Pk2': pk2,
        'Pk3': null,
        'Pk4': null,
        'Pk5': null,
        'Pk6': null,
        'Pk7': null,
        'Pk8': null,
        'Pk9': null,
        'EntryYear': null,
        'EntryType': null,
        'EntryNo': null,
        'FileDesc': fileDesc,
        'DocSerial': newDocSerial,
        'Photo': fileContent,
        'DocFlag': null,
        'ValideFDate': null,
        'ValideTDate': null,
        'DocType': 999,
        'DocNo': null,
      };

      log(
        '📦 Request Body: ${jsonEncode(requestBody)}',
        name: 'RequestMaterialFromStoreService',
      );

      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(requestBody),
        headers: {"Content-Type": "application/json"},
      );

      log(
        '🔵 Response Status Code: ${response.statusCode}',
        name: 'RequestMaterialFromStoreService',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedBody = utf8.decode(response.bodyBytes);
        log(
          '✅ Successfully uploaded attachment',
          name: 'RequestMaterialFromStoreService',
        );
        log(
          '🔵 Response Body: $decodedBody',
          name: 'RequestMaterialFromStoreService',
        );
      } else {
        final decodedBody = utf8.decode(response.bodyBytes);
        log(
          '❌ Failed with status code: ${response.statusCode}',
          name: 'RequestMaterialFromStoreService',
        );
        log(
          '❌ Error Response Body: $decodedBody',
          name: 'RequestMaterialFromStoreService',
        );
        throw Exception(
          'Failed to upload attachment - Status: ${response.statusCode}, Body: $decodedBody',
        );
      }
    } catch (e, stackTrace) {
      log('💥 Exception occurred: $e', name: 'RequestMaterialFromStoreService');
      log(
        '💥 Stack trace: $stackTrace',
        name: 'RequestMaterialFromStoreService',
      );
      throw Exception('Failed to upload attachment: $e');
    }
  }

  Future<TeamsModel> getTeams() async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/ExTeamCodeVRO1';
      log('🌐 API Request URL: $url', name: 'getTeams');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        log('✅ API Response (getTeams): $responseBody', name: 'getTeams');

        final TeamsModel teamsModel = TeamsModel.fromJson(
          json.decode(responseBody),
        );
        return teamsModel;
      } else {
        log(
          '❌ API Error (${response.statusCode}): ${response.body}',
          name: 'getTeams',
        );
        throw Exception('Failed to load teams data.');
      }
    } catch (e) {
      log('💥 Exception in getTeams: $e', name: 'getTeams');
      throw Exception('An error occurred while fetching teams: $e');
    }
  }
}
