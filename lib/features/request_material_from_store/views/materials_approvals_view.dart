import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shehabapp/core/models/material_projects_model.dart' as mp;
import 'package:shehabapp/core/models/materials_model.dart';
import 'package:shehabapp/core/providers/auth_provider.dart';
import 'package:shehabapp/core/providers/locale_provider.dart';
import 'package:shehabapp/core/providers/request_material_from_store_provider.dart';
import 'package:shehabapp/features/request_material_from_store/widgets/materials_approvals_filter_widget.dart';
import 'package:shehabapp/features/request_material_from_store/widgets/materials_data_table_widget.dart';
import 'package:shehabapp/features/request_material_from_store/widgets/materials_filter_widget.dart';
import 'package:shehabapp/features/request_material_from_store/views/request_material_approval_details.dart';
import 'package:shehabapp/l10n/app_localizations.dart';

class MaterialsApprovalsView extends StatefulWidget {
  const MaterialsApprovalsView({super.key});

  static const String routeName = 'materials_approvals_view';

  @override
  State<MaterialsApprovalsView> createState() => _MaterialsApprovalsViewState();
}

class _MaterialsApprovalsViewState extends State<MaterialsApprovalsView>
    with TickerProviderStateMixin {
  // ── Animations ─────────────────────────────────────────────────────────────
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // ── Filter state ───────────────────────────────────────────────────────────
  DateTime? _selectedDate;
  AuthFilterStatus _selectedAuth = AuthFilterStatus.all;
  mp.Items? _selectedProject;

  // ── Displayed rows ─────────────────────────────────────────────────────────
  List<Items> _displayedItems = [];

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

    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ── Data loading ────────────────────────────────────────────────────────────

  Future<void> _loadData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final provider = Provider.of<RequestMaterialFromStoreProvider>(
      context,
      listen: false,
    );

    final teamCode =
        int.tryParse(authProvider.currentUser?.teamCode?.toString() ?? '0') ??
        0;
    final teamType =
        int.tryParse(authProvider.currentUser?.teamType?.toString() ?? '0') ??
        0;

    // Load projects list for the dropdown
    await provider.fetchMaterialProjects();

    // Load all material approvals
    await provider.fetchMaterials(teamCode: teamCode, teamType: teamType);

    if (mounted) {
      _applyFilters();
    }
  }

  // ── Filter logic (client-side) ──────────────────────────────────────────────

  void _applyFilters() {
    final provider = Provider.of<RequestMaterialFromStoreProvider>(
      context,
      listen: false,
    );
    final allItems = provider.materialsModel?.items ?? [];

    final filtered = allItems.where((item) {
      // Date filter
      if (_selectedDate != null) {
        final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate!);
        if (!(item.trnsDate ?? '').startsWith(dateStr)) return false;
      }

      // Auth flag filter
      if (_selectedAuth != AuthFilterStatus.all) {
        if (item.authFlag != _authFlagFor(_selectedAuth)) return false;
      }

      // Project filter — match by projectId or contractNo
      if (_selectedProject != null) {
        if (item.projectId != _selectedProject!.projectId) return false;
      }

      return true;
    }).toList();

    setState(() => _displayedItems = filtered);
  }

  void _resetFilters() {
    setState(() {
      _selectedDate = null;
      _selectedAuth = AuthFilterStatus.all;
      _selectedProject = null;
    });
    final provider = Provider.of<RequestMaterialFromStoreProvider>(
      context,
      listen: false,
    );
    setState(() {
      _displayedItems = provider.materialsModel?.items ?? [];
    });
  }

  int _authFlagFor(AuthFilterStatus status) {
    switch (status) {
      case AuthFilterStatus.approved:
        return 1;
      case AuthFilterStatus.notApproved:
        return 0;
      case AuthFilterStatus.rejected:
        return 2;
      default:
        return -1;
    }
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

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
                  // Gradient header
                  _ApprovalsHeader(l10n: l10n, isArabic: isArabic),

                  // White rounded body
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
                      child: Consumer<RequestMaterialFromStoreProvider>(
                        builder: (context, provider, _) {
                          final projects =
                              provider.materialProjectsModel?.items ?? <mp.Items>[];

                          return SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                            child: Column(
                              children: [
                                // Screen title
                                Text(
                                  isArabic ? 'اعتمادات طلبات الصرف' : 'Material Approvals',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Filter card
                                MaterialsApprovalsFilterWidget(
                                  selectedDate: _selectedDate,
                                  selectedAuth: _selectedAuth,
                                  selectedProject: _selectedProject,
                                  projects: projects,
                                  onDateChanged: (d) =>
                                      setState(() => _selectedDate = d),
                                  onAuthChanged: (a) =>
                                      setState(() => _selectedAuth = a),
                                  onProjectChanged: (p) =>
                                      setState(() => _selectedProject = p),
                                  onSearchPressed: _applyFilters,
                                  onResetPressed: _resetFilters,
                                ),

                                const SizedBox(height: 24),

                                // Divider
                                Container(
                                  height: 1,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        const Color(
                                          0xFF4F46E5,
                                        ).withOpacity(0.3),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Loading / error / table
                                if (provider.isLoading)
                                  _LoadingState(l10n: l10n)
                                else if (provider.errorMessage != null)
                                  _ErrorState(
                                    message: provider.errorMessage!,
                                    onRetry: _loadData,
                                    l10n: l10n,
                                  )
                                else
                                  MaterialsDataTableWidget(
                                    items: _displayedItems,
                                    onRowTapped: (item) async {
                                      final result = await Navigator.pushNamed(
                                        context,
                                        RequestMaterialApprovalDetails.routeName,
                                        arguments: item,
                                      );
                                      if (result == true) {
                                        _loadData();
                                      }
                                    },
                                  ),
                              ],
                            ),
                          );
                        },
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
}

// ── Header ─────────────────────────────────────────────────────────────────────

class _ApprovalsHeader extends StatelessWidget {
  final AppLocalizations l10n;
  final bool isArabic;
  const _ApprovalsHeader({required this.l10n, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
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
            isArabic ? 'اعتمادات طلبات الصرف' : 'Material Approvals',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Language toggle
          Consumer<LocaleProvider>(
            builder: (context, provider, _) {
              final isArabicLocale = provider.locale.languageCode == 'ar';
              return GestureDetector(
                onTap: () => provider.setLocale(Locale(isArabicLocale ? 'en' : 'ar')),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.language, color: Colors.white, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        isArabicLocale ? 'EN' : 'ع',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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

// ── Loading ─────────────────────────────────────────────────────────────────────

class _LoadingState extends StatelessWidget {
  final AppLocalizations l10n;
  const _LoadingState({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Color(0xFF4F46E5)),
            const SizedBox(height: 16),
            Text(
              l10n.loading,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Error ───────────────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final AppLocalizations l10n;

  const _ErrorState({
    required this.message,
    required this.onRetry,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red[400], size: 48),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
