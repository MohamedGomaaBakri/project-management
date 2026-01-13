import 'package:flutter/material.dart';
import 'package:shehabapp/core/models/project_tasks_model.dart';
import 'package:shehabapp/core/models/projects_model.dart';
import 'package:shehabapp/core/models/task_details_model.dart';
import 'package:shehabapp/core/services/daily_tasks_service.dart';

class DailyTasksProvider with ChangeNotifier {
  final DailyTasksService _dailyTasksService = DailyTasksService();
  ProjectsModel? projectsModel;
  ProjectTasksModel? projectTasksModel;
  TaskDetailsModel? taskDetailsModel;
  bool isLoading = false;
  String? errorMessage;

  Future<void> getProjects() async {
    isLoading = true;
    notifyListeners();
    try {
      projectsModel = await _dailyTasksService.getProjects();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getProjectsDetails({
    required String usersCode,
    String? projectId,
    String? contractNo,
    String? secNo,
    int? doneFlag,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      projectTasksModel = await _dailyTasksService.getProjectsDetails(
        usersCode: usersCode,
        projectId: projectId,
        contractNo: contractNo,
        secNo: secNo,
        doneFlag: doneFlag,
      );
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkExecuteStatus({required String altKey}) async {
    isLoading = true;
    notifyListeners();
    try {
      taskDetailsModel = await _dailyTasksService.checkExecuteStatus(
        altKey: altKey,
      );
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }
}
