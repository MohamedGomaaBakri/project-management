import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shehabapp/core/models/material_projects_model.dart';
import 'package:shehabapp/core/models/materials_model.dart';
import 'package:shehabapp/core/models/project_items_model.dart';

class RequestMaterialFromStoreService {
  Future<MaterialsModel> getMaterials() async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/ProjectsItemReqVO1';
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
        return MaterialsModel.fromJson(jsonData);
      } else {
        log(
          '❌ Failed with status code: ${response.statusCode}',
          name: 'RequestMaterialFromStoreService',
        );
        throw Exception('Failed to load  - Status: ${response.statusCode}');
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

  Future<MaterialsModel> getOneMaterial({required String altKey}) async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/ProjectsItemReqVO1?q=AltKey=$altKey';
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
        return MaterialsModel.fromJson(jsonData);
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

  Future<void> updateOneMaterialAndApproval({
    required String altKey,
    required String trnsDate,
    required String authDesc,
    required String authDate,
    required String authUser,
    required String quantity,

    int? authFlag,
  }) async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/ProjectsItemReqVO1/$altKey';
      log('🔵 Request URL: $url', name: 'RequestMaterialFromStoreService');

      // Log request body before sending
      final requestBody = jsonEncode({
        "AuthUser": authUser,
        "AuthDesc": authDesc,
        "AuthDate": authDate,
        "Quantity": quantity,
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

  Future<MaterialProjectsModel> getProjects() async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/EXProjectsVRO1?';
      log('🌐 API Request URL: $url', name: 'getProjects');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        log('✅ API Response (getProjects): $responseBody', name: 'getProjects');

        final MaterialProjectsModel materialProjectsModel =
            MaterialProjectsModel.fromJson(json.decode(responseBody));
        return materialProjectsModel;
      } else {
        log(
          '❌ API Error (${response.statusCode}): ${response.body}',
          name: 'getProjects',
        );
        throw Exception('Failed to load projects data.');
      }
    } catch (e) {
      log('💥 Exception in getProjects: $e', name: 'getProjects');
      throw Exception('An error occurred while fetching projects: $e');
    }
  }

  Future<ProjectItemsModel> getProjectItems({required String projectId}) async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/ExProjectsItemsVRO1?q=ProjectId=$projectId';
      log('🌐 API Request URL: $url', name: 'getProjectItems');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        log(
          '✅ API Response (getProjectItems): $responseBody',
          name: 'getProjectItems',
        );

        final ProjectItemsModel projectItemsModel = ProjectItemsModel.fromJson(
          json.decode(responseBody),
        );
        return projectItemsModel;
      } else {
        log(
          '❌ API Error (${response.statusCode}): ${response.body}',
          name: 'getProjectItems',
        );
        throw Exception('Failed to load projects items data.');
      }
    } catch (e) {
      log('💥 Exception in getProjectItems: $e', name: 'getProjectItems');
      throw Exception('An error occurred while fetching projects items: $e');
    }
  }

  Future<void> addOneMaterialRequestAndApprovals({
    required int projectId,
    required int serial,
    required String trnsDate,
    // required String bandBal,
    required int itemCode,
    required int unitCode,
    required double quantity,
    required String descA,
    required String descE,
    required int insertUser,
    required String insertDate,
    required int authFlag,
  }) async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/ProjectsItemReqVO1';
      log('🔵 Request URL: $url', name: 'addOneTasksAndApprovals');

      // Log request body before sending
      final requestBody = jsonEncode({
        "ProjectId": projectId,
        "Serial": serial,
        "TrnsDate": trnsDate,
        // "BandBal": bandBal,
        "ItemCode": itemCode,
        "UnitCode": unitCode,
        "Quantity": quantity,
        "DescA": descA,
        "DescE": descE,
        "InsertUser": insertUser,
        "InsertDate": insertDate,
        "AuthFlag": authFlag,
      });
      log(
        '📦 Request Body: $requestBody',
        name: 'addOneMaterialRequestAndApprovals',
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
        name: 'addOneMaterialRequestAndApprovals',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('✅ Update successful', name: 'addOneMaterialRequestAndApprovals');
      } else {
        final errorBody = utf8.decode(response.bodyBytes);
        log(
          '❌ Failed with status code: ${response.statusCode}',
          name: 'addOneMaterialRequestAndApprovals',
        );
        log(
          '❌ Error Response Body: $errorBody',
          name: 'addOneMaterialRequestAndApprovals',
        );
        throw Exception(
          'Failed to update task - Status: ${response.statusCode} | $errorBody',
        );
      }
    } catch (e, stackTrace) {
      log(
        '💥 Exception occurred: $e',
        name: 'addOneMaterialRequestAndApprovals',
      );
      log(
        '💥 Stack trace: $stackTrace',
        name: 'addOneMaterialRequestAndApprovals',
      );
      throw Exception('Failed to add one material request and approvals: $e');
    }
  }
}
