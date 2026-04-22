import 'package:flutter/material.dart';
import 'package:shehabapp/core/models/attachment_model.dart';
import 'package:shehabapp/core/models/band_list_model.dart';
import 'package:shehabapp/core/models/task_and_approvals_model.dart';
import 'package:shehabapp/core/models/teams_model.dart';
import 'package:shehabapp/core/services/request_material_from_store_service.dart';

class RequestMaterialFromStoreProvider extends ChangeNotifier {
  final RequestMaterialFromStoreService _service =
      RequestMaterialFromStoreService();

  TasksAndApprovalsModel? _tasksAndApprovals;
  TasksAndApprovalsModel? _oneTaskAndApprovals;
  AttatchmentModel? _attatchments;
  int? _maxDocSerial;
  BandListModel? _bandList;
  TeamsModel? _teams;
  TasksAndApprovalsModel? get tasksAndApprovals => _tasksAndApprovals;
  TasksAndApprovalsModel? get oneTaskAndApprovals => _oneTaskAndApprovals;
  int? get maxDocSerial => _maxDocSerial;
  AttatchmentModel? get attatchments => _attatchments;
  BandListModel? get bandList => _bandList;
  TeamsModel? get teams => _teams;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> getTasksAndApprovals({
    required int teamCode,
    required dynamic teamType,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tasksAndApprovals = await _service.getTasksAndApprovals(
        teamCode: teamCode,
        teamType: teamType,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getOneTasksAndApprovals({
    required int teamCode,
    required int serial,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _oneTaskAndApprovals = await _service.getOneTasksAndApprovals(
        teamCode: teamCode,
        serial: serial,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
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
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.updateOneTasksAndApprovals(
        altKey: altKey,
        trnsDate: trnsDate,
        bandCode: bandCode,
        bandCodeDet: bandCodeDet,
        unitCode: unitCode,
        quantity: quantity,
        notes: notes,
        authDesc: authDesc,
        // authUserName: authUserName,
        authDate: authDate,
        authFlag: authFlag,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
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
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.addOneTasksAndApprovals(
        teamCode: teamCode,
        teamType: teamType,
        serial: serial,
        trnsDate: trnsDate,
        bandCode: bandCode,
        bandCodeDet: bandCodeDet,
        unitCode: unitCode,
        quantity: quantity,
        notes: notes,
        insertUser: insertUser,
        insertDate: insertDate,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteOneTasksAndApprovals({required String altKey}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.deleteOneTasksAndApprovals(altKey: altKey);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getBandList({
    required int teamCode,
    required int teamType,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _bandList = await _service.getBandList(
        teamCode: teamCode,
        teamType: teamType,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAttatchments({
    required String pk1,
    required String pk2,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _attatchments = await _service.getTaskAttachment(pk1: pk1, pk2: pk2);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getMaxDocSerial() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _maxDocSerial = await _service.getMaxDocSerial();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadAttachment({
    required String pk1,
    required String pk2,
    required String fileDesc,
    required String fileContent,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.uploadAttachment(
        pk1: pk1,
        pk2: pk2,
        fileDesc: fileDesc,
        fileContent: fileContent,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getTeams() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _teams = await _service.getTeams();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
