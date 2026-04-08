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
  String? errorMessage;

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
}
