import 'package:flutter/foundation.dart';
import '../models/safe_and_security_data_model.dart';
import '../models/projects_model.dart';
import '../services/safe_and_security_service.dart';
import '../services/daily_tasks_service.dart';

class SafeAndSecurityProvider with ChangeNotifier {
  final SafeAndSecurityService _service = SafeAndSecurityService();
  final DailyTasksService _dailyTasksService = DailyTasksService();

  SafeAndSecurityDataModel? _safeAndSecurity;
  ProjectsModel? projectsModel;
  bool _isLoading = false;
  String? _errorMessage;

  SafeAndSecurityDataModel? get safeAndSecurity => _safeAndSecurity;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> getProjects() async {
    try {
      projectsModel = await _dailyTasksService.getProjects();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchSafeAndSecurity({
    String? usersCode,
    String? projectId,
    String? contractNo,
    String? secNo,
    int? doneFlag,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _safeAndSecurity = await _service.getSafeAndSecurity(
        usersCode: usersCode,
        projectId: projectId,
        contractNo: contractNo,
        secNo: secNo,
        doneFlag: doneFlag,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
