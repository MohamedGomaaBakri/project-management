import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shehabapp/core/models/task_and_approvals_model.dart';
import 'package:shehabapp/core/providers/auth_provider.dart';
import 'package:shehabapp/core/providers/locale_provider.dart';
import 'package:shehabapp/core/providers/request_material_from_store_provider.dart';
import 'package:shehabapp/features/request_material_from_store/views/add_task_view.dart';
import 'package:shehabapp/features/request_material_from_store/widgets/tasks_data_table_widget.dart';
import 'package:shehabapp/features/request_material_from_store/widgets/tasks_filter_widget.dart';
import 'package:shehabapp/l10n/app_localizations.dart';

/// Main screen that shows the material-request tasks list.
///
/// 1. Loads all data on init using the current user's teamCode.
/// 2. Applies client-side filters (date + auth status) on search press.
/// 3. Shows a colour-coded data table and a pinned Add button at the bottom.
class TasksDataView extends StatefulWidget {
  const TasksDataView({super.key});

  static const String routeName = 'tasks_data_view';

  @override
  State<TasksDataView> createState() => _TasksDataViewState();
}

class _TasksDataViewState extends State<TasksDataView>
    with TickerProviderStateMixin {
  // ── Animations ────────────────────────────────────────────────────────────
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // ── Filter state ──────────────────────────────────────────────────────────
  DateTime? _selectedDate;
  AuthFilterStatus _selectedAuth = AuthFilterStatus.all;

  // ── Displayed rows (after local filter applied) ───────────────────────────
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

  // ── Data loading ──────────────────────────────────────────────────────────

  Future<void> _loadData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final provider = Provider.of<RequestMaterialFromStoreProvider>(
      context,
      listen: false,
    );

    final teamCode = authProvider.currentUser?.teamCode ?? 0;
    await provider.getTasksAndApprovals(
      teamCode: teamCode,
      teamType: authProvider.currentUser?.teamType,
    );

    if (mounted) {
      setState(() {
        _displayedItems = provider.tasksAndApprovals?.items ?? [];
      });
    }
  }

  // ── Filter logic (client-side) ────────────────────────────────────────────

  void _applyFilters() {
    final provider = Provider.of<RequestMaterialFromStoreProvider>(
      context,
      listen: false,
    );
    final allItems = provider.tasksAndApprovals?.items ?? [];

    final filtered = allItems.where((item) {
      // Date filter: match trnsDate prefix yyyy-MM-dd
      if (_selectedDate != null) {
        final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate!);
        if (!(item.trnsDate ?? '').startsWith(dateStr)) return false;
      }

      // Auth flag filter
      if (_selectedAuth != AuthFilterStatus.all) {
        if (item.authFlag != _authFlagFor(_selectedAuth)) return false;
      }

      return true;
    }).toList();

    setState(() => _displayedItems = filtered);
  }

  void _resetFilters() {
    setState(() {
      _selectedDate = null;
      _selectedAuth = AuthFilterStatus.all;
    });
    // Show all items after reset
    final provider = Provider.of<RequestMaterialFromStoreProvider>(
      context,
      listen: false,
    );
    setState(() {
      _displayedItems = provider.tasksAndApprovals?.items ?? [];
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

  // ── Build ─────────────────────────────────────────────────────────────────

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
                  // Gradient header
                  _TasksHeader(l10n: l10n),

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
                          return Stack(
                            children: [
                              SingleChildScrollView(
                                padding: const EdgeInsets.fromLTRB(
                                  24,
                                  24,
                                  24,
                                  96, // space for the pinned Add button
                                ),
                                child: Column(
                                  children: [
                                    // Screen title
                                    Text(
                                      l10n.tasksDataTitle,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    const SizedBox(height: 24),

                                    // Filter card
                                    TasksFilterWidget(
                                      selectedDate: _selectedDate,
                                      selectedAuth: _selectedAuth,
                                      onDateChanged: (d) =>
                                          setState(() => _selectedDate = d),
                                      onAuthChanged: (a) =>
                                          setState(() => _selectedAuth = a),
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

                                    // Loading / error / data table
                                    if (provider.isLoading)
                                      _LoadingState(l10n: l10n)
                                    else if (provider.errorMessage != null)
                                      _ErrorState(
                                        message: provider.errorMessage!,
                                        onRetry: _loadData,
                                        l10n: l10n,
                                      )
                                    else
                                      TasksDataTableWidget(
                                        items: _displayedItems,
                                      ),
                                  ],
                                ),
                              ),

                              // Pinned Add button
                              Positioned(
                                bottom: 24,
                                left: 24,
                                right: 24,
                                child: _AddButton(l10n: l10n),
                              ),
                            ],
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

// ── Header ────────────────────────────────────────────────────────────────────

class _TasksHeader extends StatelessWidget {
  final AppLocalizations l10n;
  const _TasksHeader({required this.l10n});

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
            l10n.tasksDataTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Language toggle
          Consumer<LocaleProvider>(
            builder: (context, provider, _) {
              final isArabic = provider.locale?.languageCode == 'ar';
              return GestureDetector(
                onTap: () => provider.setLocale(Locale(isArabic ? 'en' : 'ar')),
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
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── Pinned Add button ─────────────────────────────────────────────────────────

class _AddButton extends StatefulWidget {
  final AppLocalizations l10n;
  const _AddButton({required this.l10n});

  @override
  State<_AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<_AddButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        Future.delayed(const Duration(milliseconds: 100), () {
          Navigator.pushNamed(context, AddTaskView.routeName);
        });
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(_isPressed ? 0.97 : 1.0),
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: const Color(0xFF4F46E5).withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_rounded, color: Colors.white, size: 24),
            const SizedBox(width: 10),
            Text(
              widget.l10n.addNewRecord,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Loading state ─────────────────────────────────────────────────────────────

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

// ── Error state ───────────────────────────────────────────────────────────────

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
