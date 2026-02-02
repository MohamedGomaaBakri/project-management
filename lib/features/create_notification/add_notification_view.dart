import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shehabapp/core/providers/notification_provider.dart';
import 'package:shehabapp/core/providers/locale_provider.dart';
import 'package:shehabapp/l10n/app_localizations.dart';
import 'package:shehabapp/core/models/users_type_model.dart' as user_type;
import 'package:shehabapp/core/models/users_model.dart';
import 'widgets/custom_user_type_dropdown.dart';
import 'widgets/conditional_user_field.dart';
import 'widgets/notification_type_selector.dart';
import 'widgets/date_display_field.dart';
import 'widgets/description_input_field.dart';

class AddNotificationView extends StatefulWidget {
  final int projectId;
  final int partId;
  final int flowId;
  final int procId;

  const AddNotificationView({
    super.key,
    required this.projectId,
    required this.partId,
    required this.flowId,
    required this.procId,
  });

  static const String routeName = 'add_notification_view';

  @override
  State<AddNotificationView> createState() => _AddNotificationViewState();
}

class _AddNotificationViewState extends State<AddNotificationView>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Form controllers
  final TextEditingController _descriptionController = TextEditingController();

  // Form state
  user_type.Items? _selectedUserType;
  Items? _selectedUser;
  int _selectedNotificationType = 1; // Default to "إشعار بتوقف"
  String? _userTypeError;
  String? _userError;
  String? _descriptionError;

  // Loading state
  bool _isLoading = false;
  bool _isSubmitting = false;

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

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    final notificationProvider = Provider.of<NotificationProvider>(
      context,
      listen: false,
    );

    try {
      // Load users and user types
      print('🔵 Loading initial data...');
      await Future.wait([
        notificationProvider.getNotificationUsers(),
        // Load all user types for the project
        notificationProvider.getAllUsersTypes(projectId: widget.projectId),
      ]);

      print('🔵 Data loaded successfully');
      print(
        '🔵 User types count: ${notificationProvider.notificationUsersTypeModel?.items?.length ?? 0}',
      );
      print(
        '🔵 Users count: ${notificationProvider.notificationUsersModel?.items?.length ?? 0}',
      );
    } catch (e) {
      print('💥 Error loading data: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _onUserTypeChanged(user_type.Items? userType) async {
    setState(() {
      _selectedUserType = userType;
      _selectedUser = null;
      _userTypeError = null;
      _userError = null;
    });

    if (userType != null) {
      // Load user types for this user
      final notificationProvider = Provider.of<NotificationProvider>(
        context,
        listen: false,
      );

      try {
        await notificationProvider.getUsersType(
          usersCode: userType.usersCode ?? 0,
          projectId: widget.projectId,
        );
      } catch (e) {
        print('Error loading user types: $e');
      }
    }
  }

  bool _validateForm() {
    bool isValid = true;

    setState(() {
      _userTypeError = null;
      _userError = null;
      _descriptionError = null;
    });

    final l10n = AppLocalizations.of(context)!;

    if (_selectedUserType == null) {
      setState(() {
        _userTypeError = l10n.pleaseSelectUserType;
      });
      isValid = false;
    }

    // Check if user selection is required
    if (_selectedUserType != null) {
      final userName =
          _selectedUserType!.usersName ?? _selectedUserType!.usersNameE;
      if (userName == null || userName.isEmpty) {
        if (_selectedUser == null) {
          setState(() {
            _userError = l10n.pleaseSelectUser;
          });
          isValid = false;
        }
      }
    }

    if (_descriptionController.text.trim().isEmpty) {
      setState(() {
        _descriptionError = l10n.pleaseEnterDescription;
      });
      isValid = false;
    }

    return isValid;
  }

  void _submitNotification() async {
    if (!_validateForm()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final l10n = AppLocalizations.of(context)!;
    final notificationProvider = Provider.of<NotificationProvider>(
      context,
      listen: false,
    );

    try {
      // Get max NoteSer and increment
      final maxNoteSer = await notificationProvider.getMaxNoteSer();
      final newNoteSer = maxNoteSer + 1;

      // Get current date in ISO format
      final now = DateTime.now();
      final timeZoneOffset = now.timeZoneOffset;
      final offsetHours = timeZoneOffset.inHours;
      final offsetMinutes = timeZoneOffset.inMinutes.remainder(60);
      final offsetString =
          '${offsetHours >= 0 ? '+' : ''}${offsetHours.toString().padLeft(2, '0')}:${offsetMinutes.abs().toString().padLeft(2, '0')}';
      final noteDate = '${now.toIso8601String().split('.')[0]}$offsetString';

      // Determine user code
      int userCode = 0;
      if (_selectedUser != null) {
        userCode = _selectedUser!.usersCode ?? 0;
      } else if (_selectedUserType != null) {
        userCode = _selectedUserType!.usersCode ?? 0;
      }

      // Create notification
      await notificationProvider.addNewNotification(
        projectId: widget.projectId,
        partId: widget.partId,
        flowId: widget.flowId,
        procId: widget.procId,
        noteSer: newNoteSer,
        docSerial: 0, // Not used in the new API
        userType: _selectedUserType?.code ?? 0,
        descA: _descriptionController.text.trim(),
        insertUser: 800, // TODO: Get from current user session
        noteDate: noteDate,
        noteType: _selectedNotificationType,
        userCode: userCode,
      );

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.notificationCreatedSuccessfully,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );

        // Navigate back
        Navigator.of(context).pop();
      }
    } catch (e) {
      print('Error creating notification: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.failedToCreateNotification,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final notificationProvider = Provider.of<NotificationProvider>(context);

    // Get current date for display
    final now = DateTime.now();
    final timeZoneOffset = now.timeZoneOffset;
    final offsetHours = timeZoneOffset.inHours;
    final offsetMinutes = timeZoneOffset.inMinutes.remainder(60);
    final offsetString =
        '${offsetHours >= 0 ? '+' : ''}${offsetHours.toString().padLeft(2, '0')}:${offsetMinutes.abs().toString().padLeft(2, '0')}';
    final currentDate = '${now.toIso8601String().split('.')[0]}$offsetString';

    // Get user name from selected user type
    String? userName;
    if (_selectedUserType != null) {
      userName = _selectedUserType!.usersName ?? _selectedUserType!.usersNameE;
    }

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
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            // Title
                            Text(
                              l10n.createNewNotification,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // User Type Dropdown
                            CustomUserTypeDropdown(
                              userTypes: notificationProvider
                                  .notificationUsersTypeModel
                                  ?.items,
                              selectedUserType: _selectedUserType,
                              onChanged: _onUserTypeChanged,
                              isLoading: _isLoading,
                            ),

                            if (_userTypeError != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  _userTypeError!,
                                  style: TextStyle(
                                    color: Colors.red[600],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                            const SizedBox(height: 16),

                            // Conditional User Field
                            ConditionalUserField(
                              userName: userName,
                              users: notificationProvider
                                  .notificationUsersModel
                                  ?.items,
                              selectedUser: _selectedUser,
                              onUserChanged: (user) {
                                setState(() {
                                  _selectedUser = user;
                                  _userError = null;
                                });
                              },
                              isLoading: _isLoading,
                            ),

                            if (_userError != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  _userError!,
                                  style: TextStyle(
                                    color: Colors.red[600],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                            const SizedBox(height: 16),

                            // Notification Type Selector
                            NotificationTypeSelector(
                              selectedType: _selectedNotificationType,
                              onTypeChanged: (type) {
                                setState(() {
                                  _selectedNotificationType = type;
                                });
                              },
                            ),

                            const SizedBox(height: 16),

                            // Date Display
                            DateDisplayField(date: currentDate),

                            const SizedBox(height: 16),

                            // Description Input
                            DescriptionInputField(
                              controller: _descriptionController,
                              errorText: _descriptionError,
                            ),

                            const SizedBox(height: 32),

                            // Submit Button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _isSubmitting
                                    ? null
                                    : _submitNotification,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4F46E5),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 4,
                                  shadowColor: const Color(
                                    0xFF4F46E5,
                                  ).withOpacity(0.4),
                                ),
                                child: _isSubmitting
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.check_circle_outline,
                                            size: 24,
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            l10n.createNotification,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),

                            const SizedBox(height: 24),
                          ],
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
            l10n.createNewNotification,
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
}
