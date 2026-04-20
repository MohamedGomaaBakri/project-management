import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shehabapp/core/providers/auth_provider.dart';
import 'package:shehabapp/core/providers/locale_provider.dart';
import 'package:shehabapp/features/request_material_from_store/views/approvals_view.dart';
import 'package:shehabapp/features/request_material_from_store/views/tasks_data_view.dart';
import 'package:shehabapp/features/request_material_from_store/widgets/selection_card_widget.dart';
import 'package:shehabapp/l10n/app_localizations.dart';

/// Screen that lets the user choose between Tasks (المهام) and
/// Approval (الاعتماد) within the "Request Materials From Store" module.
///
/// The Approval card is only shown when the current user's
/// [UsersPermissionsModel.mobileMnAuthFlag] equals 1.
class TaskAndApprovalSelectionView extends StatefulWidget {
  const TaskAndApprovalSelectionView({super.key});

  static const String routeName = 'task_and_approval_selection_view';

  @override
  State<TaskAndApprovalSelectionView> createState() =>
      _TaskAndApprovalSelectionViewState();
}

class _TaskAndApprovalSelectionViewState
    extends State<TaskAndApprovalSelectionView>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
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
                  _TaskAndApprovalHeader(l10n: l10n),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 30,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: _TaskAndApprovalBody(l10n: l10n),
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

// ────────────────────────────────────────────────────────────────────────────
// Header widget
// ────────────────────────────────────────────────────────────────────────────

class _TaskAndApprovalHeader extends StatelessWidget {
  final AppLocalizations l10n;

  const _TaskAndApprovalHeader({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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

          // Screen title
          Text(
            l10n.tasksAndApprovalTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          // Language toggle
          Consumer<LocaleProvider>(
            builder: (context, provider, child) {
              final isArabic = provider.locale?.languageCode == 'ar';
              return GestureDetector(
                onTap: () {
                  final newLang = isArabic ? 'en' : 'ar';
                  provider.setLocale(Locale(newLang));
                },
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
                          fontSize: 16,
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

// ────────────────────────────────────────────────────────────────────────────
// Body widget — contains the animated cards list
// ────────────────────────────────────────────────────────────────────────────

class _TaskAndApprovalBody extends StatelessWidget {
  final AppLocalizations l10n;

  const _TaskAndApprovalBody({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final perms = authProvider.usersPermissions?.items?.isNotEmpty == true
            ? authProvider.usersPermissions!.items!.first
            : null;

        final bool showApproval = perms?.mobileMnAuthFlag == 1;

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Section heading
                  Text(
                    l10n.selectCategory,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  // ── Tasks card (always visible) ──────────────────────────
                  _AnimatedSelectionCard(
                    delay: 100,
                    child: SelectionCardWidget(
                      title: l10n.tasksSelection,
                      subtitle: l10n.tasksSelectionDesc,
                      icon: Icons.assignment_turned_in_rounded,
                      gradient: const [Color(0xFF4F46E5), Color(0xFF6366F1)],
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          TasksDataView.routeName,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Approval card (only when mobileMnAuthFlag == 1) ──────
                  if (showApproval)
                    _AnimatedSelectionCard(
                      delay: 250,
                      child: SelectionCardWidget(
                        title: l10n.approvalSelection,
                        subtitle: l10n.approvalSelectionDesc,
                        icon: Icons.verified_rounded,
                        gradient: const [Color(0xFF10B981), Color(0xFF059669)],
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ApprovalsView.routeName,
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Animated wrapper that slides + fades each card in on mount
// ────────────────────────────────────────────────────────────────────────────

class _AnimatedSelectionCard extends StatelessWidget {
  final int delay;
  final Widget child;

  const _AnimatedSelectionCard({required this.delay, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.easeOutBack,
      builder: (context, value, innerChild) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(opacity: value.clamp(0.0, 1.0), child: innerChild),
        );
      },
      child: child,
    );
  }
}
