import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/notification_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/models/create_notification_model.dart';
import 'widgets/notification_data_table_widget.dart';
import 'widgets/response_status_filter_radio.dart';
import 'add_notification_view.dart';

class NotificationsView extends StatefulWidget {
  final int projectId;
  final int partId;
  final int flowId;
  final int procId;

  const NotificationsView({
    super.key,
    required this.projectId,
    required this.partId,
    required this.flowId,
    required this.procId,
  });

  static const String routeName = 'notifications_view';

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Filter state
  ResponseStatus _selectedStatus = ResponseStatus.all;

  // Data state
  List<Items> _notifications = [];
  bool _isLoading = false;

  // Project and Operation names from API
  String? _projectName;
  String? _operationName;

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

    // Load data after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() async {
    final notificationProvider = Provider.of<NotificationProvider>(
      context,
      listen: false,
    );

    await notificationProvider.getNotificationList(
      projectId: widget.projectId,
      partId: widget.partId,
      flowId: widget.flowId,
      procId: widget.procId,
    );

    // Update UI after data is loaded
    if (mounted) {
      setState(() {
        _notifications = notificationProvider.NotificationsModel?.items ?? [];

        // Extract project and operation names from first notification
        if (_notifications.isNotEmpty) {
          final firstNotification = _notifications.first;
          _projectName = firstNotification.projectNameA;
          _operationName = firstNotification.procNameA;

          print('📋 Project Name: $_projectName');
          print('📋 Operation Name: $_operationName');
        }
      });
    }
  }

  void _performSearch() async {
    setState(() {
      _isLoading = true;
    });

    final notificationProvider = Provider.of<NotificationProvider>(
      context,
      listen: false,
    );

    // Determine doneFlag based on selected status
    int? doneFlag;
    if (_selectedStatus == ResponseStatus.replied) {
      doneFlag = 1;
    } else if (_selectedStatus == ResponseStatus.notReplied) {
      doneFlag = 0;
    }
    // If ResponseStatus.all, doneFlag remains null

    // Call API with filters
    await notificationProvider.getNotificationList(
      projectId: widget.projectId,
      partId: widget.partId,
      flowId: widget.flowId,
      procId: widget.procId,
      doneFlag: doneFlag,
    );

    // Update UI with filtered data from API
    if (mounted) {
      setState(() {
        _notifications = notificationProvider.NotificationsModel?.items ?? [];
        _isLoading = false;
      });
    }
  }

  void _resetFilters() {
    setState(() {
      _selectedStatus = ResponseStatus.all;
    });
    _loadInitialData();
  }

  @override
  void dispose() {
    _controller.dispose();
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
                            children: [
                              // Title
                              Text(
                                l10n.notificationsView,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Filter Section
                              _buildSimplifiedFilterSection(context, l10n),

                              const SizedBox(height: 24),

                              // Horizontal Divider
                              Container(
                                height: 1,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      const Color(0xFF4F46E5).withOpacity(0.3),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Data Table
                              _isLoading
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const CircularProgressIndicator(
                                            color: Color(0xFF4F46E5),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            l10n.loadingNotifications,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : NotificationDataTableWidget(
                                      notifications: _notifications,
                                    ),

                              const SizedBox(height: 24),

                              // Create Notification Button
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddNotificationView(
                                              projectId: widget.projectId,
                                              partId: widget.partId,
                                              flowId: widget.flowId,
                                              procId: widget.procId,
                                            ),
                                      ),
                                    );
                                  },
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
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                    size: 24,
                                  ),
                                  label: Text(
                                    l10n.addNotificationButton,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSimplifiedFilterSection(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.filter_list,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.filterBy,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4F46E5),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Project Name (Read-only)
          _buildInfoRow(
            context,
            l10n.projectFilter,
            _projectName != null && _projectName!.isNotEmpty
                ? _projectName!
                : '-- ${l10n.noDataAvailable} --',
            Icons.business,
            isEmpty: _projectName == null || _projectName!.isEmpty,
          ),

          const SizedBox(height: 12),

          // Operation Name (Read-only)
          _buildInfoRow(
            context,
            l10n.operationFilter,
            _operationName != null && _operationName!.isNotEmpty
                ? _operationName!
                : '-- ${l10n.noDataAvailable} --',
            Icons.settings,
            isEmpty: _operationName == null || _operationName!.isEmpty,
          ),

          const SizedBox(height: 20),

          // Response Status Filter
          ResponseStatusFilterRadio(
            selectedStatus: _selectedStatus,
            onChanged: (value) {
              setState(() {
                _selectedStatus = value;
              });
            },
          ),

          const SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _performSearch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.search),
                    label: Text(
                      l10n.search,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: _resetFilters,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      side: const BorderSide(color: Colors.redAccent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.refresh),
                    label: Text(
                      l10n.reset,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    bool isEmpty = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isEmpty ? Colors.red[50] : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEmpty ? Colors.red[200]! : Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isEmpty ? Icons.error_outline : icon,
            size: 20,
            color: isEmpty ? Colors.red[600] : const Color(0xFF4F46E5),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: isEmpty ? Colors.red[700] : Colors.grey[800],
                    fontWeight: FontWeight.w600,
                    fontStyle: isEmpty ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
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
            l10n.notificationsView,
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
