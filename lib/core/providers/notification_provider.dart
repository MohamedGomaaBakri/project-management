import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shehabapp/core/models/all_notification_model.dart';
import 'package:shehabapp/core/models/create_notification_model.dart';
import 'package:shehabapp/core/models/attachment_model.dart';
import 'package:shehabapp/core/models/users_model.dart';
import 'package:shehabapp/core/models/users_type_model.dart';
import 'package:shehabapp/core/services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  CreateNotificationModel? NotificationsModel;
  CreateNotificationModel? NotificationDetailsModel;
  AttatchmentModel? notificationAttachmentModel;
  UsersModel? notificationUsersModel;
  UsersTypeModel? notificationUsersTypeModel;
  AllNotificationsModel? allNotificationsModel;
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

  // Get notification users
  Future<void> getNotificationUsers() async {
    final notificationService = NotificationService();
    isLoading = true;
    errMessage = null;
    notifyListeners();

    try {
      notificationUsersModel = await notificationService.getNotificationUsers();
      isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      log(
        '💥 Exception in getNotificationUsers: $e',
        name: 'getNotificationUsers',
      );
      isLoading = false;
      errMessage = 'An error occurred while fetching notification users: $e';
      notifyListeners();
      throw Exception(
        'An error occurred while fetching notification users: $e',
      );
    }
  }

  // Get notification users type
  Future<void> getUsersType({
    required int usersCode,
    required int projectId,
  }) async {
    final notificationService = NotificationService();
    isLoading = true;
    errMessage = null;
    notifyListeners();

    try {
      notificationUsersTypeModel = await notificationService.getUsersType(
        usersCode: usersCode,
        projectId: projectId,
      );
      isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      log(
        '💥 Exception in getNotificationUsersType: $e',
        name: 'getNotificationUsersType',
      );
      isLoading = false;
      errMessage =
          'An error occurred while fetching notification users type: $e';
      notifyListeners();
      throw Exception(
        'An error occurred while fetching notification users type: $e',
      );
    }
  }

  Future<void> getAllNotifications() async {
    final notificationService = NotificationService();
    isLoading = true;
    errMessage = null;
    notifyListeners();

    try {
      allNotificationsModel = await notificationService.getAllNotifications();
      isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      log(
        '💥 Exception in getAllNotifications: $e',
        name: 'getAllNotifications',
      );
      isLoading = false;
      errMessage = 'An error occurred while fetching all notifications: $e';
      notifyListeners();
      throw Exception('An error occurred while fetching all notifications: $e');
    }
  }

  Future<void> addNewNotification({
    required int projectId,
    required int partId,
    required int flowId,
    required int procId,
    required int noteSer,
    required int docSerial,
    required int userType,
    required String descA,
    required int insertUser,
    required String noteDate,
    required int noteType,
    required int userCode,
  }) async {
    final notificationService = NotificationService();
    isLoading = true;
    errMessage = null;
    notifyListeners();

    try {
      await notificationService.uploadNewNotification(
        projectId: projectId,
        partId: partId,
        flowId: flowId,
        procId: procId,
        noteSer: noteSer,
        userType: userType,
        descA: descA,
        insertUser: insertUser,
        noteDate: noteDate,
        noteType: noteType,
        userCode: userCode,
      );
      isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      log('💥 Exception in addNewNotification: $e', name: 'addNewNotification');
      isLoading = false;
      errMessage = 'An error occurred while adding new notification: $e';
      notifyListeners();
      throw Exception('An error occurred while adding new notification: $e');
    }
  }

  Future<int> getMaxNoteSer() async {
    final notificationService = NotificationService();
    try {
      return await notificationService.getMaxNoteSer();
    } catch (e) {
      log('💥 Exception in getMaxNoteSer: $e', name: 'NotificationProvider');
      return 0;
    }
  }

  Future<void> getAllUsersTypes({required int projectId}) async {
    final notificationService = NotificationService();
    isLoading = true;
    errMessage = null;
    notifyListeners();

    try {
      notificationUsersTypeModel = await notificationService.getAllUsersTypes(
        projectId: projectId,
      );
      isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      log('💥 Exception in getAllUsersTypes: $e', name: 'getAllUsersTypes');
      isLoading = false;
      errMessage = 'An error occurred while loading user types: $e';
      notifyListeners();
      throw Exception('An error occurred while loading user types: $e');
    }
  }
}
