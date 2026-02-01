import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shehabapp/core/models/create_notification_model.dart';
import 'package:shehabapp/core/models/attachment_model.dart';
import 'package:shehabapp/core/services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  CreateNotificationModel? NotificationsModel;
  CreateNotificationModel? NotificationDetailsModel;
  AttatchmentModel? notificationAttachmentModel;
  String? errMessage;
  bool isLoading = false;
  bool isAttachmentLoading = false;

  Future<void> getNotificationList({
    required int projectId,
    required int partId,
    required int flowId,
    required int procId,
    int? doneFlag,
  }) async {
    final notificationService = NotificationService();
    isLoading = true;
    errMessage = null;
    notifyListeners();

    try {
      NotificationsModel = await notificationService.getNotificationList(
        projectId: projectId,
        partId: partId,
        flowId: flowId,
        procId: procId,
        doneFlag: doneFlag,
      );
      isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      log(
        '💥 Exception in getNotificationList: $e',
        name: 'getNotificationList',
      );
      isLoading = false;
      errMessage = 'An error occurred while fetching notification list: $e';
      notifyListeners();
      throw Exception('An error occurred while fetching notification list: $e');
    }
  }

  Future<void> getNotificationDetails({
    required int projectId,
    required int partId,
    required int flowId,
    required int procId,
    required int noteSer,
  }) async {
    final notificationService = NotificationService();
    isLoading = true;
    errMessage = null;
    notifyListeners();

    try {
      NotificationDetailsModel = await notificationService
          .getNotificationDetails(
            projectId: projectId,
            partId: partId,
            flowId: flowId,
            procId: procId,
            noteSer: noteSer,
          );
      isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      log(
        '💥 Exception in getNotificationDetails: $e',
        name: 'getNotificationDetails',
      );
      isLoading = false;
      errMessage = 'An error occurred while fetching notification details: $e';
      notifyListeners();
      throw Exception(
        'An error occurred while fetching notification details: $e',
      );
    }
  }

  // Get all notification attachments
  Future<void> getAllNotificationAttachments({
    required int projectId,
    required int partId,
    required int flowId,
    required int procId,
    required int noteSer,
  }) async {
    final notificationService = NotificationService();
    isAttachmentLoading = true;
    errMessage = null;
    notifyListeners();

    try {
      notificationAttachmentModel = await notificationService
          .getAllNotificationAttachments(
            projectId: projectId,
            partId: partId,
            flowId: flowId,
            procId: procId,
            noteSer: noteSer,
          );
      isAttachmentLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      log(
        '💥 Exception in getAllNotificationAttachments: $e',
        name: 'getAllNotificationAttachments',
      );
      isAttachmentLoading = false;
      errMessage = 'An error occurred while fetching attachments: $e';
      notifyListeners();
      throw Exception('An error occurred while fetching attachments: $e');
    }
  }

  // Get specific notification attachments
  Future<void> getNotificationAttachments({
    required int projectId,
    required int partId,
    required int flowId,
    required int procId,
    required int noteSer,
  }) async {
    final notificationService = NotificationService();
    isAttachmentLoading = true;
    errMessage = null;
    notifyListeners();

    try {
      notificationAttachmentModel = await notificationService
          .getNotificationAttachments(
            projectId: projectId,
            partId: partId,
            flowId: flowId,
            procId: procId,
            noteSer: noteSer,
          );
      isAttachmentLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      log(
        '💥 Exception in getNotificationAttachments: $e',
        name: 'getNotificationAttachments',
      );
      isAttachmentLoading = false;
      errMessage = 'An error occurred while fetching attachments: $e';
      notifyListeners();
      throw Exception('An error occurred while fetching attachments: $e');
    }
  }

  // Upload notification attachment
  Future<void> uploadNotificationAttachment({
    required int projectId,
    required int partId,
    required int flowId,
    required int procId,
    required int noteSer,
    required int docSerial,
    required String docPath,
    required String fileDesc,
    required String fileContent,
  }) async {
    final notificationService = NotificationService();

    try {
      await notificationService.uploadNotificationAttachment(
        projectId: projectId,
        partId: partId,
        flowId: flowId,
        procId: procId,
        noteSer: noteSer,
        docSerial: docSerial,
        docPath: docPath,
        fileDesc: fileDesc,
        fileContent: fileContent,
      );

      log(
        '✅ Successfully uploaded notification attachment',
        name: 'NotificationProvider',
      );
    } on Exception catch (e) {
      log(
        '💥 Exception in uploadNotificationAttachment: $e',
        name: 'uploadNotificationAttachment',
      );
      throw Exception('An error occurred while uploading attachment: $e');
    }
  }

  // Get max doc serial for notification attachments
  Future<int> getMaxNotificationDocSerial() async {
    final notificationService = NotificationService();

    try {
      final attachments = await notificationService
          .getAllNotificationAttachments(
            projectId: 0,
            partId: 0,
            flowId: 0,
            procId: 0,
            noteSer: 0,
          );

      if (attachments.items == null || attachments.items!.isEmpty) {
        return 0;
      }

      int maxSerial = 0;
      for (var item in attachments.items!) {
        if (item.docSerial != null && item.docSerial! > maxSerial) {
          maxSerial = item.docSerial!;
        }
      }

      return maxSerial;
    } catch (e) {
      log(
        '💥 Exception in getMaxNotificationDocSerial: $e',
        name: 'getMaxNotificationDocSerial',
      );
      return 0;
    }
  }
}
