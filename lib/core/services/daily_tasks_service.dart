import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shehabapp/core/models/project_tasks_model.dart';
import 'package:shehabapp/core/models/projects_model.dart';
import 'package:shehabapp/core/models/task_details_model.dart';
import '../api/api_constants.dart';

class DailyTasksService {
  Future<ProjectsModel> getProjects() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.projectsEndpoint}'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        final ProjectsModel projectsModel = ProjectsModel.fromJson(
          json.decode(responseBody),
        );
        return projectsModel;
      } else {
        throw Exception('Failed to load projects data.');
      }
    } catch (e) {
      print('Error in getProjects: $e');
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
        queryParams.add('PROJECT_ID=$projectId');
      }
      if (contractNo != null && contractNo.isNotEmpty) {
        queryParams.add('CONTRACT_NO=$contractNo');
      }
      if (secNo != null && secNo.isNotEmpty) {
        queryParams.add('SEC_NO=$secNo');
      }
      if (doneFlag != null) {
        queryParams.add('DONE_FLAG=$doneFlag');
      }

      final queryString = queryParams.join('&');

      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.projectsDetailsEndpoint}$queryString',
        ),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        final ProjectTasksModel projectsDetails = ProjectTasksModel.fromJson(
          json.decode(responseBody),
        );
        return projectsDetails;
      } else {
        throw Exception('Failed to load projects details data.');
      }
    } catch (e) {
      print('Error in getProjectsDetails: $e');
      throw Exception('An error occurred while fetching projects details: $e');
    }
  }

  Future<TaskDetailsModel> checkExecuteStatus({required String altKey}) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.checkExecuteStatus}$altKey',
        ),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        final TaskDetailsModel taskDetails = TaskDetailsModel.fromJson(
          json.decode(responseBody),
        );
        return taskDetails;
      } else {
        throw Exception('Failed to load task details data.');
      }
    } catch (e) {
      print('Error in getTaskDetails: $e');
      throw Exception('An error occurred while fetching task details: $e');
    }
  }
}
