import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/management_provider.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/models/create_notification_model.dart';
import '../../create_notification/widgets/notification_details_header.dart';
import '../../create_notification/widgets/notification_info_card.dart';

class MngNotificationDetailsView extends StatefulWidget {
  final String altKey;

  const MngNotificationDetailsView({super.key, required this.altKey});

  static const String routeName = 'mng_notification_details_view';

  @override
  State<MngNotificationDetailsView> createState() =>
      _MngNotificationDetailsViewState();
}

class _MngNotificationDetailsViewState extends State<MngNotificationDetailsView>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  Items? _notificationDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();

    // Load notification details
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNotificationDetails();
    });
  }

  void _loadNotificationDetails() async {
    final managementProvider = Provider.of<ManagementProvider>(
      context,
      listen: false,
    );

    await managementProvider.fetchNotificationDetails(altKey: widget.altKey);

    if (mounted) {
      setState(() {
        _notificationDetails =
            managementProvider.notificationDetailsModel?.items?.first;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('yyyy-MM-dd HH:mm').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  String _getLocalizedText(String? arabicText, dynamic englishText) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final isArabic = localeProvider.locale.languageCode == 'ar';

    if (isArabic) {
      return arabicText ?? '';
    } else {
      if (englishText == null) return arabicText ?? '';
      return englishText.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4F46E5), Color(0xFF7C3AED), Color(0xFFEC4899)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  // Header
                  const NotificationDetailsHeader(),

                  // Content
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 24),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: _isLoading
                          ? _buildLoadingState(l10n)
                          : _notificationDetails == null
                          ? _buildErrorState(l10n)
                          : _buildContent(context, l10n),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Color(0xFF4F46E5)),
          const SizedBox(height: 16),
          Text(
            l10n.loadingNotificationDetails,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            l10n.noDataAvailable,
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            l10n.notificationDetailsTitle,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),

          const SizedBox(height: 24),
          // Contract Number
          NotificationInfoCard(
            label: l10n.contractNumber,
            value: _notificationDetails?.contractNo?.toString() ?? '',
            icon: Icons.numbers,
          ),
          const SizedBox(height: 16),

          // Project
          NotificationInfoCard(
            label: l10n.project,
            value: _getLocalizedText(
              _notificationDetails?.projectNameA,
              _notificationDetails?.projectNameE,
            ),
            icon: Icons.business,
          ),

          const SizedBox(height: 16),

          // Operation
          NotificationInfoCard(
            label: l10n.operation,
            value: _getLocalizedText(
              _notificationDetails?.procNameA,
              _notificationDetails?.procNameE,
            ),
            icon: Icons.settings,
          ),

          const SizedBox(height: 16),
          // insert user
          NotificationInfoCard(
            label: l10n.insertUser,
            value: _notificationDetails?.insertUser?.toString() ?? '',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 16),

          // User Type
          NotificationInfoCard(
            label: l10n.userType,
            value: _getLocalizedText(
              _notificationDetails?.userTypeName,
              _notificationDetails?.userTypeNameE,
            ),
            icon: Icons.person_outline,
          ),

          const SizedBox(height: 16),

          // User Name
          NotificationInfoCard(
            label: l10n.userName,
            value: _getLocalizedText(
              _notificationDetails?.usersName,
              _notificationDetails?.usersNameE,
            ),
            icon: Icons.person,
          ),

          const SizedBox(height: 16),

          // Notification Type
          NotificationInfoCard(
            label: l10n.notificationTypeLabel,
            value: _getLocalizedText(
              _notificationDetails?.noteTypeName,
              _notificationDetails?.noteTypeNameE,
            ),
            icon: Icons.notifications_active,
          ),

          const SizedBox(height: 16),

          // Notification Date
          NotificationInfoCard(
            label: l10n.notificationDateLabel,
            value: _formatDate(_notificationDetails?.noteDate),
            icon: Icons.calendar_today,
          ),

          const SizedBox(height: 16),

          // Description
          NotificationInfoCard(
            label: l10n.description,
            value: _getLocalizedText(
              _notificationDetails?.descA,
              _notificationDetails?.descE,
            ),
            icon: Icons.description,
            isLongText: true,
          ),

          const SizedBox(height: 24),

          // Reply Date (if replied)
          if (_notificationDetails?.doneFlag == 1) ...[
            NotificationInfoCard(
              label: l10n.replyDateLabel,
              value: _formatDate(_notificationDetails?.doneDate),
              icon: Icons.event_available,
            ),
            const SizedBox(height: 16),
          ],

          // Reply Description (if replied)
          if (_notificationDetails?.doneFlag == 1 &&
              _notificationDetails?.reDesc != null &&
              _notificationDetails!.reDesc!.isNotEmpty) ...[
            NotificationInfoCard(
              label: l10n.replyDescription,
              value: _notificationDetails?.reDesc ?? '',
              icon: Icons.reply,
              isLongText: true,
            ),
            const SizedBox(height: 16),
          ],

          // Insert User
          NotificationInfoCard(
            label: l10n.insertUserLabel,
            value: _notificationDetails?.insertUser?.toString() ?? '',
            icon: Icons.person_add,
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
