import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shehabapp/core/api/api_constants.dart';
import 'package:shehabapp/core/models/safe_and_security_data_model.dart';

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
}
