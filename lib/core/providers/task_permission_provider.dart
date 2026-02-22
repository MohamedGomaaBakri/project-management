import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shehabapp/core/models/attachment_model.dart';
import 'package:shehabapp/core/models/attpermitcheck_model.dart';
import 'package:shehabapp/core/models/permissions_list_model.dart';
import 'package:shehabapp/core/models/permit_status_model.dart';
import 'package:shehabapp/core/models/task_permission_model.dart';
import 'package:shehabapp/core/models/zones_list_model.dart';
import 'package:shehabapp/core/services/task_permission_service.dart';

class TaskPermissionProvider extends ChangeNotifier {
  PermissionModel? permissionModel;
  PermissionListModel? permissionListModel;
  ZonesListModel? zonesListModel;
  PermitStatusModel? permitStatusModel;
  AttpermitcheckModel? attpermitcheckModel;
  AttatchmentModel? attatchmentModel;
  bool isLoading = false;
  String? errorMessage;

  // Filtered permissions based on status
  List<Permission>? get filteredPermissions => permissionModel?.items;

  Future<void> getPermissionDetails(int projectId) async {
    final taskPermissionService = TaskPermissionService();
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      permissionModel = await taskPermissionService.getPermissionDetails(
        projectId,
      );
      isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      log(
        '💥 Exception in getPermissionDetails: $e',
        name: 'getPermissionDetails',
      );
      isLoading = false;
      errorMessage = 'An error occurred while fetching permission details: $e';
      notifyListeners();
      throw Exception(
        'An error occurred while fetching permission details: $e',
      );
    }
  }

  Future<void> getPermissionList() async {
    final taskPermissionService = TaskPermissionService();
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      permissionListModel = await taskPermissionService.getPermissionList();
      isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      log('💥 Exception in getPermissionList: $e', name: 'getPermissionList');
      isLoading = false;
      errorMessage = 'An error occurred while fetching permission list: $e';
      notifyListeners();
      throw Exception('An error occurred while fetching permission list: $e');
    }
  }

  Future<void> getZonesList() async {
    final taskPermissionService = TaskPermissionService();
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      zonesListModel = await taskPermissionService.getZonesList();
      isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      log('💥 Exception in getZonesList: $e', name: 'getZonesList');
      isLoading = false;
      errorMessage = 'An error occurred while fetching zones list: $e';
      notifyListeners();
      throw Exception('An error occurred while fetching zones list: $e');
    }
  }

  Future<void> getPermissionStatus() async {
    final taskPermissionService = TaskPermissionService();
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      permitStatusModel = await taskPermissionService.getPermissionStatus();
      isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      log(
        '💥 Exception in getPermissionStatus: $e',
        name: 'getPermissionStatus',
      );
      isLoading = false;
      errorMessage = 'An error occurred while fetching permission status: $e';
      notifyListeners();
      throw Exception('An error occurred while fetching permission status: $e');
    }
  }

  Future<void> getAttpermitcheck(int projectId) async {
    final taskPermissionService = TaskPermissionService();
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      attpermitcheckModel = await taskPermissionService.getAttpermitcheck(
        projectId,
      );
      isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      log('💥 Exception in getAttpermitcheck: $e', name: 'getAttpermitcheck');
      isLoading = false;
      errorMessage = 'An error occurred while fetching attpermitcheck: $e';
      notifyListeners();
      throw Exception('An error occurred while fetching attpermitcheck: $e');
    }
  }

  Future<void> updateDoneFlag(
    String altKey,
    int doneFlag,
    String doneDate,
  ) async {
    final taskPermissionService = TaskPermissionService();
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await taskPermissionService.updateDoneFlag(altKey, doneFlag, doneDate);
      isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      log('💥 Exception in updateDoneFlag: $e', name: 'updateDoneFlag');
      isLoading = false;
      errorMessage = 'An error occurred while updating done flag: $e';
      notifyListeners();
      throw Exception('An error occurred while updating done flag: $e');
    }
  }

  Future<void> createPermission(Map<String, dynamic> permissionData) async {
    final taskPermissionService = TaskPermissionService();
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await taskPermissionService.createPermission(permissionData);
      isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      log('💥 Exception in createPermission: $e', name: 'createPermission');
      isLoading = false;
      errorMessage = 'An error occurred while creating permission: $e';
      notifyListeners();
      throw Exception('An error occurred while creating permission: $e');
    }
  }

  Future<void> renewalPermission({
    required String projectId,
    required String permitSerial,
    required String userCode,
  }) async {
    final taskPermissionService = TaskPermissionService();
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await taskPermissionService.renewalPermission(
        projectId: projectId,
        permitSerial: permitSerial,
        userCode: userCode,
      );
      isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      log('💥 Exception in renewalPermission: $e', name: 'renewalPermission');
      isLoading = false;
      errorMessage = 'An error occurred while renewing permission: $e';
      notifyListeners();
      throw Exception('An error occurred while renewing permission: $e');
    }
  }

  Future<void> getAttachment(int projectId, int permitSerial) async {
    final taskPermissionService = TaskPermissionService();
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      attatchmentModel = await taskPermissionService.getAttachment(
        projectId,
        permitSerial,
      );
      isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      log('💥 Exception in getAttachment: $e', name: 'getAttachment');
      isLoading = false;
      errorMessage = 'An error occurred while fetching attachment: $e';
      notifyListeners();
      throw Exception('An error occurred while fetching attachment: $e');
    }
  }

  Future<int> getMaxDocSerial() async {
    final taskPermissionService = TaskPermissionService();
    try {
      final allAttachments = await taskPermissionService.getMaxDocSerial();

      // Find the maximum DocSerial from all items
      int maxSerial = 0;
      if (allAttachments.items != null && allAttachments.items!.isNotEmpty) {
        for (var item in allAttachments.items!) {
          if (item.docSerial != null && item.docSerial! > maxSerial) {
            maxSerial = item.docSerial!;
          }
        }
      }

      return maxSerial;
    } on Exception catch (e) {
      log('💥 Exception in getMaxDocSerial: $e', name: 'getMaxDocSerial');
      throw Exception('An error occurred while fetching max doc serial: $e');
    }
  }

  // Filter permissions by status (Active/Expired/All)
  List<Permission> filterByStatus(String status) {
    if (permissionModel?.items == null) return [];

    final now = DateTime.now();
    // Reset time to compare only dates (ignore hours, minutes, seconds)
    final today = DateTime(now.year, now.month, now.day);

    switch (status) {
      case 'active':
        // Active: today is before or equal to endDate
        return permissionModel!.items!.where((permission) {
          if (permission.endDate == null) return false;
          try {
            final endDate = DateTime.parse(permission.endDate!);
            final endDateOnly = DateTime(
              endDate.year,
              endDate.month,
              endDate.day,
            );
            // التصريح ساري إذا كان تاريخ اليوم قبل أو يساوي تاريخ النهاية
            return today.isBefore(endDateOnly) ||
                today.isAtSameMomentAs(endDateOnly);
          } catch (e) {
            log(
              'Error parsing endDate: ${permission.endDate}',
              name: 'filterByStatus',
            );
            return false;
          }
        }).toList();

      case 'expired':
        // Expired: today is after endDate
        return permissionModel!.items!.where((permission) {
          if (permission.endDate == null) return false;
          try {
            final endDate = DateTime.parse(permission.endDate!);
            final endDateOnly = DateTime(
              endDate.year,
              endDate.month,
              endDate.day,
            );
            // التصريح منتهي إذا كان تاريخ اليوم بعد تاريخ النهاية
            return today.isAfter(endDateOnly);
          } catch (e) {
            log(
              'Error parsing endDate: ${permission.endDate}',
              name: 'filterByStatus',
            );
            return false;
          }
        }).toList();

      case 'all':
      default:
        return permissionModel!.items!;
    }
  }

  Future<void> uploadAttachment({
    required int projectId,
    required int permitSerial,
    required int docSerial,
    required String docPath,
    required String fileDesc,
    required String fileContent,
  }) async {
    final taskPermissionService = TaskPermissionService();
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await taskPermissionService.uploadAttachment(
        projectId: projectId.toString(),
        permitSerial: permitSerial.toString(),
        docSerial: docSerial.toString(),
        docPath: docPath,
        fileDesc: fileDesc,
        fileContent: fileContent,
      );
      isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      log('💥 Exception in uploadAttachment: $e', name: 'uploadAttachment');
      isLoading = false;
      errorMessage = 'An error occurred while uploading attachment: $e';
      notifyListeners();
      throw Exception('An error occurred while uploading attachment: $e');
    }
  }
}
