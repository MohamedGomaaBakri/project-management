import 'package:flutter/foundation.dart';
import '../models/safe_and_security_data_model.dart';
import '../models/safe_and_security_details_model.dart';
import '../models/attachment_model.dart';
import '../models/projects_model.dart';
import '../services/safe_and_security_service.dart';
import '../services/daily_tasks_service.dart';

class SafeAndSecurityProvider with ChangeNotifier {
  final SafeAndSecurityService _service = SafeAndSecurityService();
  final DailyTasksService _dailyTasksService = DailyTasksService();

  SafeAndSecurityDataModel? _safeAndSecurity;
  SafeAndSecurityDetailsModel? _safeAndSecurityDetails;
  AttatchmentModel? _attachmentModel;
  ProjectsModel? projectsModel;
  bool _isLoading = false;
  String? _errorMessage;

  SafeAndSecurityDataModel? get safeAndSecurity => _safeAndSecurity;
  SafeAndSecurityDetailsModel? get safeAndSecurityDetails =>
      _safeAndSecurityDetails;
  AttatchmentModel? get attachmentModel => _attachmentModel;
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

  Future<void> fetchSafeAndSecurityDetails({String? altKey}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _safeAndSecurityDetails = await _service.getSafeAndSecurityDetails(
        altKey: altKey,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateDoneFlag({
    required String usersCode,
    required int doneFlag,
    required String doneDate,
    required String altKey,
  }) async {
    try {
      await _service.updateDoneFlag(usersCode, doneFlag, doneDate, altKey);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> getSafeAndSecurityDetailsAttachment({
    required String projectId,
    required String partId,
    required String safeId,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      _attachmentModel = await _service.getSafeAndSecurityDetailsAttachment(
        ProjectId: projectId,
        PartId: partId,
        SafeId: safeId,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadSafeAndSecurityAttachment({
    required String projectId,
    required String partId,
    required String safeId,
    required String fileDesc,
    required String fileContent,
  }) async {
    try {
      await _service.uploadSafeAndSecurityAttachment(
        projectId: projectId,
        PartId: partId,
        SafeId: safeId,
        fileDesc: fileDesc,
        fileContent: fileContent,
      );
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
