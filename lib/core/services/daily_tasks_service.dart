import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shehabapp/core/models/check_see_project_model.dart';
import 'package:shehabapp/core/models/proccess_model.dart';
import 'package:shehabapp/core/models/project_details_model.dart';
import 'package:shehabapp/core/models/project_tasks_model.dart';
import 'package:shehabapp/core/models/projects_model.dart';
import 'package:shehabapp/core/models/task_details_model.dart';
import '../api/api_constants.dart';

class DailyTasksService {
  Future<ProjectsModel> getProjects() async {
    try {
      final url = '${ApiConstants.baseUrl}${ApiConstants.projectsEndpoint}';
      log('🌐 API Request URL: $url', name: 'DailyTasksService');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        log(
          '✅ API Response (getProjects): $responseBody',
          name: 'DailyTasksService',
        );

        final ProjectsModel projectsModel = ProjectsModel.fromJson(
          json.decode(responseBody),
        );
        return projectsModel;
      } else {
        log(
          '❌ API Error (${response.statusCode}): ${response.body}',
          name: 'DailyTasksService',
        );
        throw Exception('Failed to load projects data.');
      }
    } catch (e) {
      log('💥 Exception in getProjects: $e', name: 'DailyTasksService');
      throw Exception('An error occurred while fetching projects: $e');
    }
  }

  Future<ProjectTasksModel> getProjectsDetails({
    required String usersCode,
    String? projectId,
    String? contractNo,
    String? secNo,
    int? doneFlag,
  }) async {
    try {
      // Build query string
      final queryParams = <String>['UsersCode=$usersCode'];

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

      final queryString = queryParams.join(';');
      final url =
          '${ApiConstants.baseUrl}${ApiConstants.projectsDetailsEndpoint}$queryString';
      log('🌐 API Request URL: $url', name: 'DailyTasksService');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        log(
          '✅ API Response (getProjectsDetails): $responseBody',
          name: 'DailyTasksService',
        );

        final ProjectTasksModel projectsDetails = ProjectTasksModel.fromJson(
          json.decode(responseBody),
        );
        return projectsDetails;
      } else {
        log(
          '❌ API Error (${response.statusCode}): ${response.body}',
          name: 'DailyTasksService',
        );
        throw Exception('Failed to load projects details data.');
      }
    } catch (e) {
      log('💥 Exception in getProjectsDetails: $e', name: 'DailyTasksService');
      throw Exception('An error occurred while fetching projects details: $e');
    }
  }

  Future<TaskDetailsModel> checkExecuteStatus({required String altKey}) async {
    try {
      final url =
          '${ApiConstants.baseUrl}${ApiConstants.checkExecuteStatus}$altKey';
      log('🌐 API Request URL: $url', name: 'DailyTasksService');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        log(
          '✅ API Response (checkExecuteStatus): $responseBody',
          name: 'DailyTasksService',
        );

        final TaskDetailsModel taskDetails = TaskDetailsModel.fromJson(
          json.decode(responseBody),
        );
        return taskDetails;
      } else {
        log(
          '❌ API Error (${response.statusCode}): ${response.body}',
          name: 'DailyTasksService',
        );
        throw Exception('Failed to load task details data.');
      }
    } catch (e) {
      log('💥 Exception in checkExecuteStatus: $e', name: 'DailyTasksService');
      throw Exception('An error occurred while fetching task details: $e');
    }
  }

  Future<ProccessModel> getTaskProccess({required String altKey}) async {
    try {
      final url =
          '${ApiConstants.baseUrl}${ApiConstants.projectsProccessEndpoint}$altKey';
      log('🌐 API Request URL: $url', name: 'getTaskProccess');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        log(
          '✅ API Response (getTaskProccess): $responseBody',
          name: 'getTaskProccess',
        );

        final ProccessModel taskProccess = ProccessModel.fromJson(
          json.decode(responseBody),
        );
        return taskProccess;
      } else {
        log(
          '❌ API Error (${response.statusCode}): ${response.body}',
          name: 'getTaskProccess',
        );
        throw Exception('Failed to load task proccess data.');
      }
    } catch (e) {
      log('💥 Exception in getTaskProccess: $e', name: 'getTaskProccess');
      throw Exception('An error occurred while fetching task proccess: $e');
    }
  }

  Future<void> UpdateTaskProccessData({
    required String altKey,
    required String remarks,
    required String nextUsersCode,
    required String doneFlag,
    required String doneDate,
  }) async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/EXProjectsPartsProcVO2/$altKey';
      log('🌐 API Request URL: $url', name: 'UpdateTaskProccessData');

      log('AltKey: $altKey', name: 'UpdateTaskProccessData');
      log('Remarks: $remarks', name: 'UpdateTaskProccessData');
      log('NextUsersCode: $nextUsersCode', name: 'UpdateTaskProccessData');
      log('DoneFlag: $doneFlag', name: 'UpdateTaskProccessData');
      log('DoneDate: $doneDate', name: 'UpdateTaskProccessData');

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          "Content-Type":
              "application/vnd.oracle.adf.resourceitem+json; charset=UTF-8",
        },
        body: jsonEncode({
          'AltKey': altKey,
          'Remarks': remarks,
          'NextUsersCode': nextUsersCode,
          'DoneFlag': doneFlag,
          'DoneDate': doneDate,
        }),
      );

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        log(
          '✅ API Response (UpdateTaskProccessData): $responseBody',
          name: 'UpdateTaskProccessData',
        );
      } else {
        log(
          '❌ API Error (${response.statusCode}): ${response.body}',
          name: 'UpdateTaskProccessData',
        );
        throw Exception('Failed to update task proccess data.');
      }
    } catch (e) {
      log(
        '💥 Exception in UpdateTaskProccessData: $e',
        name: 'UpdateTaskProccessData',
      );
      throw Exception('An error occurred while updating task proccess: $e');
    }
  }

  Future<CheckSeeProjectModel> checkSeeProject({
    required String usersCode,
  }) async {
    try {
      final url =
          '${ApiConstants.baseUrl}${ApiConstants.checkSeeProject}$usersCode';
      log('🌐 API Request URL: $url', name: 'checkSeeProject');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        log(
          '✅ API Response (checkSeeProject): $responseBody',
          name: 'checkSeeProject',
        );

        final CheckSeeProjectModel checkSeeProject =
            CheckSeeProjectModel.fromJson(json.decode(responseBody));
        return checkSeeProject;
      } else {
        log(
          '❌ API Error (${response.statusCode}): ${response.body}',
          name: 'checkSeeProject',
        );
        throw Exception('Failed to load check see project data.');
      }
    } catch (e) {
      log('💥 Exception in checkSeeProject: $e', name: 'checkSeeProject');
      throw Exception('An error occurred while fetching check see project: $e');
    }
  }

  Future<ProjectDetailsModel> getProjectDetailsModel({
    required String projectId,
  }) async {
    try {
      final url =
          '${ApiConstants.baseUrl}${ApiConstants.getProjectDetails}$projectId';
      log('🌐 API Request URL: $url', name: 'getProjectDetailsModel');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        log(
          '✅ API Response (getProjectDetailsModel): $responseBody',
          name: 'getProjectDetailsModel',
        );

        final ProjectDetailsModel projectDetailsModel =
            ProjectDetailsModel.fromJson(json.decode(responseBody));
        return projectDetailsModel;
      } else {
        log(
          '❌ API Error (${response.statusCode}): ${response.body}',
          name: 'getProjectDetailsModel',
        );
        throw Exception('Failed to load project details model data.');
      }
    } catch (e) {
      log(
        '💥 Exception in getProjectDetailsModel: $e',
        name: 'getProjectDetailsModel',
      );
      throw Exception(
        'An error occurred while fetching project details model: $e',
      );
    }
  }
}
