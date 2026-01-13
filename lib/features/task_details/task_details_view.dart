import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shehabapp/core/providers/daily_tasks_provider.dart';
import '../../core/models/project_tasks_model.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/locale_provider.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/task_info_card.dart';
import 'widgets/employee_dropdown_widget.dart';
import 'widgets/notes_input_widget.dart';
import 'widgets/task_status_widget.dart';
import 'widgets/action_buttons_widget.dart';

class TaskDetailsView extends StatefulWidget {
  final Items? taskItem;

  const TaskDetailsView({super.key, this.taskItem});

  static const String routeName = 'task_details_view';

  @override
  State<TaskDetailsView> createState() => _TaskDetailsViewState();
}

class _TaskDetailsViewState extends State<TaskDetailsView>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _replyController = TextEditingController();
  String? _selectedEmployeeCode;

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

    // Initialize with existing remarks if any
    _notesController.text = widget.taskItem?.remarks ?? '';

    // Load all users after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final dailyTasksProvider = Provider.of<DailyTasksProvider>(
        context,
        listen: false,
      );
      authProvider.getAllUsers();
      dailyTasksProvider.checkExecuteStatus(
        altKey: widget.taskItem?.altKey ?? '',
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _notesController.dispose();
    _replyController.dispose();
    super.dispose();
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
                  // Header Section
                  _buildHeader(context, l10n),

                  // Content Section
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
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Text(
                                l10n.taskDetailsTitle,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Section 1: Task Information
                              _buildSectionTitle(
                                context,
                                l10n.taskInformation,
                                Icons.info_outline_rounded,
                              ),
                              const SizedBox(height: 16),

                              // Project and Process Information
                              TaskInfoCard(
                                projectNameAr: widget.taskItem?.NameA,
                                projectNameEn: widget.taskItem?.NameE,
                                processNameAr: widget.taskItem?.procNameA,
                                processNameEn: widget.taskItem?.procNameE,
                              ),
                              const SizedBox(height: 16),

                              // Employee Dropdown
                              Consumer<AuthProvider>(
                                builder: (context, authProvider, child) {
                                  return EmployeeDropdownWidget(
                                    users: authProvider.allUsers,
                                    defaultEmployeeCode:
                                        widget.taskItem?.NextUsersCodeAct,
                                    selectedEmployeeCode: _selectedEmployeeCode,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedEmployeeCode = value;
                                      });
                                    },
                                  );
                                },
                              ),
                              const SizedBox(height: 16),

                              // Notes Input Fields
                              NotesInputWidget(
                                notesController: _notesController,
                                replyController: _replyController,
                              ),
                              const SizedBox(height: 16),

                              // Task Status (Execute Button + Checkbox + Date)
                              Consumer<DailyTasksProvider>(
                                builder: (context, dailyTasksProvider, child) {
                                  final taskDetails = dailyTasksProvider
                                      .taskDetailsModel
                                      ?.items
                                      ?.first;

                                  return TaskStatusWidget(
                                    doneFlag: widget.taskItem?.doneFlag,
                                    doneDate: widget.taskItem?.doneDate,
                                    attFlagCheck: taskDetails?.attFlagCheck,
                                    attPermitCheck: taskDetails?.attPermitCheck,
                                    attNotifCheck: taskDetails?.attNotifCheck,
                                    onExecute: _handleExecute,
                                    onStatusUpdated: (doneFlag, doneDate) {
                                      // Here you can update the task in the backend
                                      // or perform any other action after status update
                                    },
                                  );
                                },
                              ),
                              const SizedBox(height: 32),

                              // Section 2: Task Actions
                              _buildSectionTitle(
                                context,
                                l10n.taskActions,
                                Icons.touch_app_rounded,
                              ),
                              const SizedBox(height: 16),

                              // Action Buttons
                              ActionButtonsWidget(
                                onProjectTap: () {
                                  _showComingSoonSnackbar(
                                    context,
                                    l10n.projectButton,
                                  );
                                },
                                onAttachmentsTap: () {
                                  _showComingSoonSnackbar(
                                    context,
                                    l10n.attachmentsButton,
                                  );
                                },
                                onPermissionsTap: () {
                                  _showComingSoonSnackbar(
                                    context,
                                    l10n.permissionsButton,
                                  );
                                },
                                onNotificationTap: () {
                                  _showComingSoonSnackbar(
                                    context,
                                    l10n.createNotificationButton,
                                  );
                                },
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
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

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),

          // Title
          Text(
            l10n.taskDetails,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Language Toggle Button
          Consumer<LocaleProvider>(
            builder: (context, provider, child) {
              final isArabic = provider.locale.languageCode == 'ar';
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      final newLang = isArabic ? 'en' : 'ar';
                      provider.setLocale(Locale(newLang));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.language,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isArabic ? 'EN' : 'ع',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4F46E5).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  void _handleExecute() {
    // TODO: Implement execute logic
    // This should save the task data and update the status
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${l10n.executeButton} - ${l10n.comingSoon}'),
        backgroundColor: const Color(0xFF4F46E5),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showComingSoonSnackbar(BuildContext context, String feature) {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - ${l10n.comingSoon}'),
        backgroundColor: const Color(0xFF4F46E5),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
