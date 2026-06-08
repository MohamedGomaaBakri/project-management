import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shehabapp/core/api/api_constants.dart';
import 'package:shehabapp/core/models/attachment_model.dart';
import 'package:shehabapp/core/models/safe_and_security_data_model.dart';
import 'package:shehabapp/core/models/safe_and_security_details_model.dart';

class SafeAndSecurityService {
  Future<SafeAndSecurityDataModel> getSafeAndSecurity({
    String? usersCode,
    String? projectId,
    String? contractNo,
    String? secNo,
    int? doneFlag,
  }) async {
    try {
      // Build query string
      final queryParams = <String>[];

      if (usersCode != null && usersCode.isNotEmpty) {
        queryParams.add('UsersCode=$usersCode');
      }
      if (projectId != null && projectId.isNotEmpty) {
        queryParams.add('ProjectId=$projectId');
      }
      if (contractNo != null && contractNo.isNotEmpty) {
        queryParams.add('ContractNo=$contractNo');
      }
      if (secNo != null && secNo.isNotEmpty) {
        queryParams.add('SecNo=$secNo');
      }
      if (doneFlag != null) {
        queryParams.add('DoneFlag=$doneFlag');
      }

      final baseEndpoint =
          '${ApiConstants.baseUrl}${ApiConstants.safeAndSecurityEndpoint}';
      final url = queryParams.isEmpty
          ? baseEndpoint
          : '$baseEndpoint?q=${queryParams.join(";")}';

      log('🌐 API Request URL: $url', name: 'SafeAndSecurityService');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        log(
          '✅ API Response (getSafeAndSecurity): $responseBody',
          name: 'SafeAndSecurityService',
        );

        final SafeAndSecurityDataModel safeAndSecurityModel =
            SafeAndSecurityDataModel.fromJson(json.decode(responseBody));
        return safeAndSecurityModel;
      } else {
        log(
          '❌ API Error (${response.statusCode}): ${response.body}',
          name: 'SafeAndSecurityService',
        );
        throw Exception('Failed to load safe and security data.');
      }
    } catch (e) {
      log(
        '💥 Exception in getSafeAndSecurity: $e',
        name: 'SafeAndSecurityService',
      );
      throw Exception('An error occurred while fetching safe and security: $e');
    }
  }

  Future<SafeAndSecurityDetailsModel> getSafeAndSecurityDetails({
    String? altKey,
  }) async {
    try {
      final url =
          '${ApiConstants.baseUrl}${ApiConstants.safeAndSecurityDetailsEndpoint}$altKey';
      log('🌐 API Request URL: $url', name: 'SafeAndSecurityService');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        log(
          '✅ API Response (getSafeAndSecurityDetails): $responseBody',
          name: 'SafeAndSecurityService',
        );

        final SafeAndSecurityDetailsModel projectsDetails =
            SafeAndSecurityDetailsModel.fromJson(json.decode(responseBody));
        return projectsDetails;
      } else {
        log(
          '❌ API Error (${response.statusCode}): ${response.body}',
          name: 'SafeAndSecurityService',
        );
        throw Exception('Failed to load safe and security details data.');
      }
    } catch (e) {
      log(
        '💥 Exception in getSafeAndSecurityDetails: $e',
        name: 'SafeAndSecurityService',
      );
      throw Exception(
        'An error occurred while fetching safe and security details: $e',
      );
    }
  }

  Future<void> updateDoneFlag(
    String usersCode,
    int doneFlag,
    String doneDate,
  ) async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/EXProjectsPartsSafetyVO1';
      log('🔵 Request URL: $url', name: 'SafeAndSecurityService');
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          "Content-Type":
              "application/vnd.oracle.adf.resourceitem+json; charset=UTF-8",
        },
        body: jsonEncode({
          'DoneFlag': doneFlag,
          'DoneDate': doneDate,
          'UsersCode': usersCode,
        }),
      );
      if (response.statusCode == 200) {
        log('✅ Successfully updated done flag', name: 'SafeAndSecurityService');
      } else {
        log(
          '❌ Failed with status code: ${response.statusCode}',
          name: 'SafeAndSecurityService',
        );
        throw Exception('Failed to update done flag: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      log('💥 Exception occurred: $e', name: 'SafeAndSecurityService');
      log('💥 Stack trace: $stackTrace', name: 'SafeAndSecurityService');
      throw Exception('Failed to update done flag: $e');
    }
  }

  Future<AttatchmentModel> getSafeAndSecurityDetailsAttachment({
    required String ProjectId,
    required String PartId,
    required String SafeId,
  }) async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/SysDocsVO1?q=TblNm=PROJECTS_PARTS_SAFETY;Pk1=$ProjectId;Pk2=$PartId;Pk3=$SafeId';
      log(
        '🌐 API Request URL: $url',
        name: 'getSafeAndSecurityDetailsAttachment',
      );

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        log(
          '✅ API Response (getSafeAndSecurityDetailsAttachment): $responseBody',
          name: 'getSafeAndSecurityDetailsAttachment',
        );

        final AttatchmentModel attatchmentModel = AttatchmentModel.fromJson(
          json.decode(responseBody),
        );
        return attatchmentModel;
      } else {
        log(
          '❌ API Error (${response.statusCode}): ${response.body}',
          name: 'getSafeAndSecurityDetailsAttachment',
        );
        throw Exception(
          'Failed to load safe and security details attachment data.',
        );
      }
    } catch (e) {
      log(
        '💥 Exception in getSafeAndSecurityDetailsAttachment: $e',
        name: 'getSafeAndSecurityDetailsAttachment',
      );
      throw Exception('An error occurred while fetching task attachment: $e');
    }
  }

  Future<int> getMaxDocSerialSafeAndSecurity() async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/SysDocsVO1?q=TblNm=PROJECTS_PARTS_SAFETY';
      log('🌐 API Request URL: $url', name: 'getMaxDocSerialSafeAndSecurity');

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
          name: 'getMaxDocSerialSafeAndSecurity',
        );
        throw Exception('Failed to load max DocSerial data.');
      }
    } catch (e) {
      log(
        '💥 Exception in getMaxDocSerialSafeAndSecurity: $e',
        name: 'getMaxDocSerialSafeAndSecurity',
      );
      throw Exception('An error occurred while fetching max DocSerial: $e');
    }
  }

  Future<void> uploadSafeAndSecurityAttachment({
    required String projectId,
    required String PartId,
    required String SafeId,
    required String fileDesc,
    required String fileContent,
  }) async {
    try {
      // Fetch the maximum DocSerial and add 1
      final maxDocSerial = await getMaxDocSerialSafeAndSecurity();
      final newDocSerial = maxDocSerial + 1;
      log(
        '🔵 New DocSerial to be used: $newDocSerial',
        name: 'SafeAndSecurityService',
      );

      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/SysDocsVO1?q=TblNm=PROJECTS_PARTS_SAFETY;Pk1=$projectId;Pk2=$PartId;Pk3=$SafeId';
      log('🔵 Request URL: $url', name: 'SafeAndSecurityService');

      final requestBody = {
        'TblNm': 'PROJECTS_PARTS_SAFETY',
        'Pk1': projectId,
        'Pk2': PartId,
        'Pk3': SafeId,
        'DocSerial': newDocSerial.toString(),
        'FileDesc': fileDesc,
        'Photo': fileContent,
      };
      log(
        '🔵 Request Body: ${jsonEncode(requestBody)}',
        name: 'SafeAndSecurityService',
      );
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(requestBody),
        headers: {"Content-Type": "application/json"},
      );
      log('🔵 Response Body: ${response.body}', name: 'SafeAndSecurityService');

      log(
        '🔵 Response Status Code: ${response.statusCode}',
        name: 'SafeAndSecurityService',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        String decodedBody = utf8.decode(response.bodyBytes);
        log(
          '✅ Successfully uploaded attachment',
          name: 'SafeAndSecurityService',
        );
        log('🔵 Response Body: $decodedBody', name: 'SafeAndSecurityService');
      } else {
        String decodedBody = utf8.decode(response.bodyBytes);
        log(
          '❌ Failed with status code: ${response.statusCode}',
          name: 'SafeAndSecurityService',
        );
        log(
          '❌ Error Response Body: $decodedBody',
          name: 'SafeAndSecurityService',
        );
        throw Exception(
          'Failed to load attachment - Status: ${response.statusCode}, Body: $decodedBody',
        );
      }
    } catch (e, stackTrace) {
      log('💥 Exception occurred: $e', name: 'SafeAndSecurityService');
      log('💥 Stack trace: $stackTrace', name: 'SafeAndSecurityService');
      throw Exception('Failed to load attachment: $e');
    }
  }
}
