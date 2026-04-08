import 'package:flutter/material.dart';
import 'package:shehabapp/core/models/band_and_items_model/band_and_items_model.dart';
import 'package:shehabapp/core/models/bands_model/bands_model.dart';
import 'package:shehabapp/core/models/items_model/items_model.dart';
import 'package:shehabapp/core/services/band_items_service.dart';

class BandItemsProvider with ChangeNotifier {
  final BandItemsService _bandItemsService = BandItemsService();

  BandAndItemsModel? bandAndItemsModel;
  BandsModel? bandsModel;
  ItemsModel? itemsModel;
  bool isLoading = false;
  bool isCreating = false;
  String? errorMessage;
  String? createErrorMessage;

  Future<void> getAllBandItems() async {
    isLoading = true;
    notifyListeners();
    try {
      bandAndItemsModel = await _bandItemsService.getAllBandItems();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAllBands({required String projectId}) async {
    isLoading = true;
    notifyListeners();
    try {
      bandsModel = await _bandItemsService.getBands(projectId: projectId);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAllItems({required String projectId}) async {
    isLoading = true;
    notifyListeners();
    try {
      itemsModel = await _bandItemsService.getItems(projectId: projectId);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  /// Calculates the next Serial = max(existing serials) + 1
  int getNextSerial() {
    final items = bandAndItemsModel?.items ?? [];
    if (items.isEmpty) return 1;
    final maxSerial = items
        .map((e) => e.serial ?? 0)
        .reduce((a, b) => a > b ? a : b);
    return maxSerial + 1;
  }

  Future<bool> createBandOrItem({required Map<String, dynamic> body}) async {
    isCreating = true;
    createErrorMessage = null;
    notifyListeners();
    try {
      await _bandItemsService.createBandOrItem(body: body);
      // Refresh the list after successful creation
      await getAllBandItems();
      isCreating = false;
      notifyListeners();
      return true;
    } catch (e) {
      createErrorMessage = e.toString();
      isCreating = false;
      notifyListeners();
      return false;
    }
  }
}
