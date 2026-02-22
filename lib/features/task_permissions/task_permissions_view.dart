import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/task_permission_model.dart';
import '../../core/providers/task_permission_provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/locale_provider.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/permission_info_card_widget.dart';
import 'widgets/permission_filter_widget.dart';
import 'widgets/permission_data_table_widget.dart';
import 'create_permission_view.dart';

class TaskPermissionsView extends StatefulWidget {
  final int? projectId;

  const TaskPermissionsView({super.key, this.projectId});

  static const String routeName = 'task_permissions_view';

  @override
  State<TaskPermissionsView> createState() => _TaskPermissionsViewState();
}

class _TaskPermissionsViewState extends State<TaskPermissionsView>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Filter state
  PermissionStatus _selectedStatus = PermissionStatus.all;

  // Data state
  List<Permission> _permissions = [];
  bool _isLoading = false;

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
    if (widget.projectId == null) return;

    setState(() {
      _isLoading = true;
    });

    final permissionProvider = Provider.of<TaskPermissionProvider>(
      context,
      listen: false,
    );

    try {
      await permissionProvider.getPermissionDetails(widget.projectId!);
      await permissionProvider.getPermissionList();
      await permissionProvider.getZonesList();

      if (mounted) {
        setState(() {
          _permissions = permissionProvider.permissionModel?.items ?? [];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _performSearch() {
    final permissionProvider = Provider.of<TaskPermissionProvider>(
      context,
      listen: false,
    );

    setState(() {
      _isLoading = true;
    });

    // Filter based on selected status
    String statusFilter = 'all';
    if (_selectedStatus == PermissionStatus.active) {
      statusFilter = 'active';
    } else if (_selectedStatus == PermissionStatus.expired) {
      statusFilter = 'expired';
    }

    final filteredData = permissionProvider.filterByStatus(statusFilter);

    setState(() {
      _permissions = filteredData;
      _isLoading = false;
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedStatus = PermissionStatus.all;
    });
    _performSearch();
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
                                l10n.taskPermissionsTitle,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Project Info Card
                              Consumer<TaskPermissionProvider>(
                                builder: (context, permissionProvider, child) {
                                  final items =
                                      permissionProvider.permissionModel?.items;
                                  final firstPermission =
                                      (items != null && items.isNotEmpty)
                                      ? items.first
                                      : null;
                                  return PermissionInfoCardWidget(
                                    projectNameAr:
                                        firstPermission?.projectNameA,
                                    projectNameEn:
                                        firstPermission?.projectNameE,
                                    contractNo: firstPermission?.contractNo,
                                  );
                                },
                              ),

                              const SizedBox(height: 24),

                              // Filter Section
                              PermissionFilterWidget(
                                selectedStatus: _selectedStatus,
                                onStatusChanged: (value) {
                                  setState(() {
                                    _selectedStatus = value;
                                  });
                                },
                                onSearchPressed: _performSearch,
                                onResetPressed: _resetFilters,
                              ),

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
                              SizedBox(
                                height: 400,
                                child: _isLoading
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
                                              l10n.loadingPermissions,
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : PermissionDataTableWidget(
                                        permissions: _permissions,
                                        onDataChanged: _loadInitialData,
                                      ),
                              ),

                              const SizedBox(height: 24),

                              // New Permission Button — only shown if mobilePermitFlag == 1
                              Consumer<AuthProvider>(
                                builder: (context, authProv, _) {
                                  final perms =
                                      authProv
                                              .usersPermissions
                                              ?.items
                                              ?.isNotEmpty ==
                                          true
                                      ? authProv.usersPermissions!.items!.first
                                      : null;
                                  // Show button when perms not loaded yet, or flag == 1
                                  if (perms != null &&
                                      perms.mobilePermitFlag != 1) {
                                    return const SizedBox.shrink();
                                  }
                                  return Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF4F46E5),
                                            Color(0xFF7C3AED),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xFF4F46E5,
                                            ).withOpacity(0.4),
                                            blurRadius: 20,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          onTap: () {
                                            // Navigate to create permission screen
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CreatePermissionView(
                                                      projectId:
                                                          widget.projectId,
                                                    ),
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 32,
                                              vertical: 16,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(
                                                    8,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                    size: 24,
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Text(
                                                  l10n.newPermission,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
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
            l10n.taskPermissions,
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
