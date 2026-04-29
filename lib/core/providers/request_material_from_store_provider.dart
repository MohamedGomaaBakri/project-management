import 'package:flutter/material.dart';
import 'package:shehabapp/core/models/material_projects_model.dart';
import 'package:shehabapp/core/models/materials_model.dart';
import 'package:shehabapp/core/models/project_items_model.dart';
import 'package:shehabapp/core/services/request_material_from_store_service.dart';

class RequestMaterialFromStoreProvider extends ChangeNotifier {
  final RequestMaterialFromStoreService _service =
      RequestMaterialFromStoreService();

  MaterialsModel? _materialsModel;
  MaterialsModel? _oneMaterialModel;
  MaterialProjectsModel? _materialProjectsModel;
  ProjectItemsModel? _projectItemsModel;

  bool _isLoading = false;
  String? _errorMessage;

  MaterialsModel? get materialsModel => _materialsModel;
  MaterialsModel? get oneMaterialModel => _oneMaterialModel;
  MaterialProjectsModel? get materialProjectsModel => _materialProjectsModel;
  ProjectItemsModel? get projectItemsModel => _projectItemsModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchMaterials({
    required int teamCode,
    required dynamic teamType,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _materialsModel = await _service.getMaterials();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchOneMaterial({required String altKey}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _oneMaterialModel = await _service.getOneMaterial(altKey: altKey);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
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
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.updateOneMaterialAndApproval(
        altKey: altKey,
        trnsDate: trnsDate,
        authDesc: authDesc,
        authDate: authDate,
        authUser: authUser,
        quantity: quantity,
        authFlag: authFlag,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMaterialProjects() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _materialProjectsModel = await _service.getProjects();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProjectItems({required String projectId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _projectItemsModel = await _service.getProjectItems(projectId: projectId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
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
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.addOneMaterialRequestAndApprovals(
        projectId: projectId,
        serial: serial,
        trnsDate: trnsDate,
        // bandBal: bandBal,
        itemCode: itemCode,
        unitCode: unitCode,
        quantity: quantity,
        descA: descA,
        descE: descE,
        insertUser: insertUser,
        insertDate: insertDate,
        authFlag: authFlag,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
