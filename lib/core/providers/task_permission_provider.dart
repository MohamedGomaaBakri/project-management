import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shehabapp/core/models/permissions_list_model.dart';
import 'package:shehabapp/core/models/task_permission_model.dart';
import 'package:shehabapp/core/models/zones_list_model.dart';
import 'package:shehabapp/core/services/task_permission_service.dart';

class TaskPermissionProvider extends ChangeNotifier {
  PermissionModel? permissionModel;
  PermissionListModel? permissionListModel;
  ZonesListModel? zonesListModel;
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
}
