import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shehabapp/core/models/safe_and_security_data_model.dart';
import 'package:shehabapp/core/providers/auth_provider.dart';
import 'package:shehabapp/core/providers/safe_and_security_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../core/providers/locale_provider.dart';
import '../daily_tasks/widgets/status_filter_radio.dart';
import 'widgets/safe_filter_section_widget.dart';
import 'widgets/safe_and_security_table_widget.dart';

class SafeAndSecurityView extends StatefulWidget {
  static const String routeName = '/safe-and-security';

  const SafeAndSecurityView({super.key});

  @override
  State<SafeAndSecurityView> createState() => _SafeAndSecurityViewState();
}

class _SafeAndSecurityViewState extends State<SafeAndSecurityView>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Filter state
  String? _selectedProject;
  final TextEditingController _contractController = TextEditingController();
  final TextEditingController _secController = TextEditingController();
  TaskStatus _selectedStatus = TaskStatus.all;

  // Data state
  List<Items> _items = [];
  bool _isLoading = false;

  // Theme colors
  static const Color _green1 = Color(0xFF16A34A);
  static const Color _green2 = Color(0xFF059669);
  static const Color _green3 = Color(0xFF34D399);

  @override
  void initState() {
    super.initState();

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    final provider = Provider.of<SafeAndSecurityProvider>(
      context,
      listen: false,
    );
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final usersCode = authProvider.currentUser?.usersCode.toString();

    // Load projects list for the dropdown
    await provider.getProjects();

    // Load initial data with usersCode
    await provider.fetchSafeAndSecurity();

    if (mounted) {
      setState(() {
        _items = provider.safeAndSecurity?.items ?? [];
      });
    }
  }

  Future<void> _performSearch() async {
    setState(() => _isLoading = true);

    final provider = Provider.of<SafeAndSecurityProvider>(
      context,
      listen: false,
    );
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final usersCode = authProvider.currentUser?.usersCode.toString();

    int? doneFlag;
    if (_selectedStatus == TaskStatus.doneOnly) {
      doneFlag = 1;
    } else if (_selectedStatus == TaskStatus.notDoneOnly) {
      doneFlag = 0;
    }

    log(
      '🔍 Safe Search — project: $_selectedProject, contract: ${_contractController.text}, sec: ${_secController.text}, doneFlag: $doneFlag',
    );

    await provider.fetchSafeAndSecurity(
      // usersCode: usersCode,
      projectId: _selectedProject,
      contractNo: _contractController.text.isNotEmpty
          ? _contractController.text
          : null,
      secNo: _secController.text.isNotEmpty ? _secController.text : null,
      doneFlag: doneFlag,
    );

    if (mounted) {
      setState(() {
        _items = provider.safeAndSecurity?.items ?? [];
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _contractController.dispose();
    _secController.dispose();
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
            colors: [_green1, _green2, _green3],
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
                  _buildHeader(context, l10n),

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
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              // Title
                              Text(
                                l10n.safeAndSecurity,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Filter Section
                              Consumer<SafeAndSecurityProvider>(
                                builder: (context, safeProvider, child) {
                                  final projects =
                                      safeProvider.projectsModel?.items ?? [];
                                  return SafeFilterSectionWidget(
                                    selectedProject: _selectedProject,
                                    projects: projects,
                                    onProjectChanged: (value) {
                                      setState(() {
                                        _selectedProject = value;
                                        log(
                                          'selectedProject $_selectedProject',
                                        );
                                      });
                                    },
                                    contractController: _contractController,
                                    secController: _secController,
                                    selectedStatus: _selectedStatus,
                                    onStatusChanged: (value) {
                                      setState(() {
                                        _selectedStatus = value;
                                      });
                                    },
                                    onSearchPressed: _performSearch,
                                    onResetPressed: () {
                                      setState(() {
                                        _selectedProject = null;
                                        _contractController.clear();
                                        _secController.clear();
                                        _selectedStatus = TaskStatus.all;
                                      });
                                      _performSearch();
                                    },
                                  );
                                },
                              ),

                              const SizedBox(height: 24),

                              // Divider
                              Container(
                                height: 1,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      _green1.withOpacity(0.3),
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
                                            color: _green1,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            '...',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : SafeAndSecurityTableWidget(items: _items),
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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.health_and_safety,
                color: Colors.white,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.safeAndSecurity,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // Language Toggle
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
