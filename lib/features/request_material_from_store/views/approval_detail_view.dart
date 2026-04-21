import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shehabapp/core/models/task_and_approvals_model.dart';
import 'package:shehabapp/core/providers/auth_provider.dart';
import 'package:shehabapp/core/providers/locale_provider.dart';
import 'package:shehabapp/core/providers/request_material_from_store_provider.dart';
import 'package:shehabapp/l10n/app_localizations.dart';

/// Detail screen for an approval item.
///
/// Shows: date, band, unit, quantity, notes, approver notes (editable).
/// Action buttons: Approve (اعتماد) | Cancel Approval (إلغاء اعتماد) | Reject (رفض).
///
/// The approver notes field ([_authDescController]) is always editable so the
/// approver can write their comment before taking action.
class ApprovalDetailView extends StatefulWidget {
  final Items initialItem;

  const ApprovalDetailView({super.key, required this.initialItem});

  static const String routeName = 'approval_detail_view';

  @override
  State<ApprovalDetailView> createState() => _ApprovalDetailViewState();
}

class _ApprovalDetailViewState extends State<ApprovalDetailView>
    with TickerProviderStateMixin {
  // ── Animations ─────────────────────────────────────────────────────────────
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // ── Approver notes controller (user-written) ──────────────────────────────
  late TextEditingController _authDescController;

  @override
  void initState() {
    super.initState();

    _authDescController = TextEditingController(
      text: widget.initialItem.authDesc?.toString() ?? '',
    );

    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) => _loadDetail());
  }

  @override
  void dispose() {
    _controller.dispose();
    _authDescController.dispose();
    super.dispose();
  }

  // ── Load detail ─────────────────────────────────────────────────────────────

  Future<void> _loadDetail() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final provider = Provider.of<RequestMaterialFromStoreProvider>(
      context,
      listen: false,
    );
    final teamCode =
        int.tryParse(authProvider.currentUser?.teamCode?.toString() ?? '0') ??
        0;
    final serial = widget.initialItem.serial ?? 0;

    await provider.getOneTasksAndApprovals(teamCode: teamCode, serial: serial);

    // Refresh approver notes from fresh data if available
    final freshItem = provider.oneTaskAndApprovals?.items?.firstOrNull;
    if (freshItem != null && mounted) {
      _authDescController.text = freshItem.authDesc?.toString() ?? '';
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _formatDate(dynamic raw) {
    if (raw == null || raw.toString().isEmpty) return '—';
    try {
      final date = DateTime.parse(raw.toString());
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (_) {
      return raw.toString();
    }
  }

  // ── Action: Approve (authFlag = 1) ────────────────────────────────────────

  Future<void> _performApprove() async {
    await _performAuth(authFlag: 1);
  }

  // ── Action: Cancel Approval (authFlag = 0) ────────────────────────────────

  Future<void> _performCancelApproval() async {
    await _performAuth(authFlag: 0);
  }

  // ── Action: Reject (authFlag = 2) ─────────────────────────────────────────

  Future<void> _performReject() async {
    await _performAuth(authFlag: 2);
  }

  /// Common handler: build the PATCH payload and send via [updateOneTasksAndApprovals].
  Future<void> _performAuth({required int authFlag}) async {
    final l10n = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final provider = Provider.of<RequestMaterialFromStoreProvider>(
      context,
      listen: false,
    );

    final item =
        provider.oneTaskAndApprovals?.items?.firstOrNull ?? widget.initialItem;

    final teamCode =
        int.tryParse(authProvider.currentUser?.teamCode?.toString() ?? '0') ??
        0;
    final userName = authProvider.currentUser?.usersName ?? '';
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Build new AuthFlag-aware authStatus fields through backend — we only
    // send the fields the PATCH endpoint accepts, setting AuthFlag implicitly
    // via authDesc/authUserName/authDate.
    //
    // NOTE: AuthFlag itself is not directly a parameter of
    // [updateOneTasksAndApprovals]; instead the backend derives the flag from
    // which user / date we send. However the existing service method does send
    // all numeric fields unchanged — so we pass the same band/unit/qty/date
    // and update authDesc + authUserName + authDate to reflect the action.
    //
    // If the API supports a dedicated AuthFlag field, that can be added to
    // the service; for now we follow the existing contract.
    await provider.updateOneTasksAndApprovals(
      altKey: item.altKey ?? '',
      trnsDate: item.trnsDate ?? today,
      bandCode: item.bandCode ?? 0,
      bandCodeDet: item.bandCodeDet ?? 0,
      unitCode: item.unitCode ?? 0,
      quantity: (item.quantity ?? 0).toDouble(),
      notes: item.notes ?? '',
      authDesc: _authDescController.text.trim(),
      // authUserName: authFlag == 0 ? '' : userName,
      authDate: authFlag == 0 ? '' : today,
      authFlag: authFlag,
    );

    if (!mounted) return;

    if (provider.errorMessage == null) {
      final successMsg = _successMessage(l10n, authFlag);
      _showSnackBar(context, successMsg, isSuccess: true);
      await Future.delayed(const Duration(milliseconds: 1600));
      if (mounted) Navigator.of(context).pop(true); // pop with refresh signal
    } else {
      _showSnackBar(context, provider.errorMessage!, isSuccess: false);
    }
  }

  String _successMessage(AppLocalizations l10n, int authFlag) {
    switch (authFlag) {
      case 1:
        return l10n.approvalActionSuccess;
      case 0:
        return l10n.cancelApprovalActionSuccess;
      case 2:
        return l10n.rejectActionSuccess;
      default:
        return l10n.saveSuccess;
    }
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    required bool isSuccess,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess
                  ? Icons.check_circle_rounded
                  : Icons.error_outline_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: isSuccess ? Colors.green[700] : Colors.red[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: Duration(seconds: isSuccess ? 2 : 3),
      ),
    );
  }

  // ── Build ───────────────────────────────────────────────────────────────────

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
            colors: [Color(0xFF10B981), Color(0xFF059669), Color(0xFF047857)],
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
                  _ApprovalDetailHeader(l10n: l10n),

                  // White body
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Consumer<RequestMaterialFromStoreProvider>(
                        builder: (context, provider, _) {
                          final item =
                              provider
                                  .oneTaskAndApprovals
                                  ?.items
                                  ?.firstOrNull ??
                              widget.initialItem;
                          final isArabic =
                              Localizations.localeOf(context).languageCode ==
                              'ar';

                          return Stack(
                            children: [
                              SingleChildScrollView(
                                padding: const EdgeInsets.fromLTRB(
                                  20,
                                  24,
                                  20,
                                  160, // space for 3 buttons
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // Status banner (serial + badge)
                                    _StatusBanner(
                                      item: item,
                                      isArabic: isArabic,
                                    ),
                                    const SizedBox(height: 20),

                                    // Loading indicator
                                    if (provider.isLoading)
                                      const LinearProgressIndicator(
                                        color: Color(0xFF10B981),
                                        backgroundColor: Colors.transparent,
                                      ),

                                    const SizedBox(height: 8),

                                    // ── Request info section ───────────
                                    _RequestInfoSection(
                                      item: item,
                                      l10n: l10n,
                                      isArabic: isArabic,
                                      formatDate: _formatDate,
                                    ),
                                    const SizedBox(height: 20),

                                    // ── Approver notes section ─────────
                                    _ApproverNotesSection(
                                      l10n: l10n,
                                      controller: _authDescController,
                                    ),
                                  ],
                                ),
                              ),

                              // ── Pinned action buttons ──────────────
                              if (!provider.isLoading)
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: _ActionButtons(
                                    l10n: l10n,
                                    onApprove: _performApprove,
                                    onCancelApproval: _performCancelApproval,
                                    onReject: _performReject,
                                  ),
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

// ── Header ─────────────────────────────────────────────────────────────────────

class _ApprovalDetailHeader extends StatelessWidget {
  final AppLocalizations l10n;
  const _ApprovalDetailHeader({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
          Text(
            l10n.approvalDetailTitle,
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

// ── Status banner ──────────────────────────────────────────────────────────────

class _StatusBanner extends StatelessWidget {
  final Items item;
  final bool isArabic;
  const _StatusBanner({required this.item, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    final statusText = isArabic
        ? (item.authStatusA ?? '')
        : (item.authStatusE ?? '');
    final badgeColor = _badgeColor(item.authFlag);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Serial chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF10B981), Color(0xFF059669)],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '# ${item.serial ?? '—'}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),

        // Auth status badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: badgeColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: badgeColor.withOpacity(0.5)),
          ),
          child: Text(
            statusText,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: badgeColor,
            ),
          ),
        ),
      ],
    );
  }

  Color _badgeColor(int? authFlag) {
    switch (authFlag) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.green;
      case 2:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

// ── Info row ───────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF059669)),
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
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isEmpty ? '—' : value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section card ───────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Divider(color: Colors.grey.shade100, thickness: 1.5),
          ...children,
        ],
      ),
    );
  }
}

// ── Request info section ───────────────────────────────────────────────────────

class _RequestInfoSection extends StatelessWidget {
  final Items item;
  final AppLocalizations l10n;
  final bool isArabic;
  final String Function(dynamic) formatDate;

  const _RequestInfoSection({
    required this.item,
    required this.l10n,
    required this.isArabic,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    final bandName = isArabic ? (item.bandNameA ?? '') : (item.bandNameE ?? '');
    final unitName = isArabic ? (item.unitNameA ?? '') : (item.unitNameE ?? '');

    return _SectionCard(
      title: l10n.approvalDetailSectionRequest,
      icon: Icons.assignment_rounded,
      children: [
        _InfoRow(
          label: l10n.detailTrnsDate,
          value: formatDate(item.trnsDate),
          icon: Icons.calendar_today_rounded,
        ),
        _InfoRow(
          label: l10n.detailBand,
          value: bandName,
          icon: Icons.layers_rounded,
        ),
        _InfoRow(
          label: l10n.detailUnit,
          value: unitName,
          icon: Icons.straighten_rounded,
        ),
        _InfoRow(
          label: l10n.detailQuantity,
          value: item.quantity?.toString() ?? '',
          icon: Icons.inventory_2_rounded,
        ),
        _InfoRow(
          label: l10n.detailNotes,
          value: item.notes ?? '',
          icon: Icons.notes_rounded,
        ),
      ],
    );
  }
}

// ── Approver notes section ─────────────────────────────────────────────────────

class _ApproverNotesSection extends StatelessWidget {
  final AppLocalizations l10n;
  final TextEditingController controller;

  const _ApproverNotesSection({required this.l10n, required this.controller});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: l10n.approvalDetailSectionApproverNotes,
      icon: Icons.verified_rounded,
      children: [
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: l10n.approvalDetailApproverNotesHint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF10B981),
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.all(14),
          ),
          style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
        ),
      ],
    );
  }
}

// ── Pinned action buttons ──────────────────────────────────────────────────────

class _ActionButtons extends StatelessWidget {
  final AppLocalizations l10n;
  final VoidCallback onApprove;
  final VoidCallback onCancelApproval;
  final VoidCallback onReject;

  const _ActionButtons({
    required this.l10n,
    required this.onApprove,
    required this.onCancelApproval,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Approve button (full width, green)
          _ActionBtn(
            label: l10n.approvalBtnApprove,
            icon: Icons.check_circle_rounded,
            gradient: const [Color(0xFF10B981), Color(0xFF059669)],
            shadowColor: const Color(0xFF10B981),
            onPressed: onApprove,
          ),
          const SizedBox(height: 10),

          // Cancel approval + Reject (side by side)
          Row(
            children: [
              Expanded(
                child: _OutlinedActionBtn(
                  label: l10n.approvalBtnCancelApproval,
                  icon: Icons.cancel_outlined,
                  color: Colors.orange,
                  onPressed: onCancelApproval,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _OutlinedActionBtn(
                  label: l10n.approvalBtnReject,
                  icon: Icons.thumb_down_alt_rounded,
                  color: Colors.red,
                  onPressed: onReject,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Gradient filled action button with press animation.
class _ActionBtn extends StatefulWidget {
  final String label;
  final IconData icon;
  final List<Color> gradient;
  final Color shadowColor;
  final VoidCallback onPressed;

  const _ActionBtn({
    required this.label,
    required this.icon,
    required this.gradient,
    required this.shadowColor,
    required this.onPressed,
  });

  @override
  State<_ActionBtn> createState() => _ActionBtnState();
}

class _ActionBtnState extends State<_ActionBtn> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        Future.delayed(const Duration(milliseconds: 100), widget.onPressed);
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(_isPressed ? 0.97 : 1.0),
        height: 52,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: widget.shadowColor.withOpacity(0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Text(
              widget.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
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

/// Outlined (bordered) action button.
class _OutlinedActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _OutlinedActionBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          backgroundColor: color.withOpacity(0.04),
        ),
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }
}
