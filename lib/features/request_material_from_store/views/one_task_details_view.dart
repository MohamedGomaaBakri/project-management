import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shehabapp/core/models/task_and_approvals_model.dart';
import 'package:shehabapp/core/providers/auth_provider.dart';
import 'package:shehabapp/core/providers/locale_provider.dart';
import 'package:shehabapp/core/providers/request_material_from_store_provider.dart';
import 'package:shehabapp/features/request_material_from_store/widgets/task_detail_widgets.dart';
import 'package:shehabapp/l10n/app_localizations.dart';

/// Detail screen for a single material-request task item.
///
/// Behaviour based on [Items.authFlag]:
///   0 → editable (quantity + notes) + Delete button shown
///   1 → fully read-only, no Save / Delete
///   2 → editable (quantity + notes) but NO Delete button
class OneTaskDetailsView extends StatefulWidget {
  /// The task item tapped from the list. Used for initial display while the
  /// detail API call completes.
  final Items initialItem;

  const OneTaskDetailsView({super.key, required this.initialItem});

  static const String routeName = 'one_task_details_view';

  @override
  State<OneTaskDetailsView> createState() => _OneTaskDetailsViewState();
}

class _OneTaskDetailsViewState extends State<OneTaskDetailsView>
    with TickerProviderStateMixin {
  // ── Animations ────────────────────────────────────────────────────────────
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // ── Editable field controllers ────────────────────────────────────────────
  late TextEditingController _quantityController;
  late TextEditingController _notesController;

  // ── Change tracking — Save button is only active when user edits ──────────
  bool _hasChanges = false;
  String _originalQuantity = '';
  String _originalNotes = '';

  @override
  void initState() {
    super.initState();

    // Init with initial item data immediately so screen isn't blank while loading
    _originalQuantity = widget.initialItem.quantity?.toString() ?? '';
    _originalNotes = widget.initialItem.notes ?? '';

    _quantityController = TextEditingController(text: _originalQuantity);
    _notesController = TextEditingController(text: _originalNotes);

    // Listen for changes to enable/disable Save button
    _quantityController.addListener(_onFieldChanged);
    _notesController.addListener(_onFieldChanged);

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
    _quantityController.removeListener(_onFieldChanged);
    _notesController.removeListener(_onFieldChanged);
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // ── Load single item detail ───────────────────────────────────────────────

  Future<void> _loadDetail() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final provider = Provider.of<RequestMaterialFromStoreProvider>(
      context,
      listen: false,
    );
    final teamCode = authProvider.currentUser?.teamCode ?? 0;
    final serial = widget.initialItem.serial ?? 0;

    await provider.getOneTasksAndApprovals(teamCode: teamCode, serial: serial);

    // Update controllers once fresh data arrives and reset change tracking
    final item = provider.oneTaskAndApprovals?.items?.firstOrNull;
    if (item != null && mounted) {
      _originalQuantity = item.quantity?.toString() ?? '';
      _originalNotes = item.notes ?? '';
      _quantityController.text = _originalQuantity;
      _notesController.text = _originalNotes;
      setState(() => _hasChanges = false);
    }
  }

  // ── Change detection ──────────────────────────────────────────────────────

  void _onFieldChanged() {
    final changed =
        _quantityController.text.trim() != _originalQuantity.trim() ||
        _notesController.text.trim() != _originalNotes.trim();
    if (changed != _hasChanges) {
      setState(() => _hasChanges = changed);
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _formatDate(dynamic raw) {
    if (raw == null) return '—';
    try {
      final date = DateTime.parse(raw.toString());
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (_) {
      return raw.toString();
    }
  }

  bool get _canEdit =>
      widget.initialItem.authFlag == 0 || widget.initialItem.authFlag == 2;

  bool get _canDelete => widget.initialItem.authFlag == 0;

  bool get _isReadOnly => widget.initialItem.authFlag == 1;

  // ── Save ──────────────────────────────────────────────────────────────────

  Future<void> _performSave() async {
    final l10n = AppLocalizations.of(context)!;
    // final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final provider = Provider.of<RequestMaterialFromStoreProvider>(
      context,
      listen: false,
    );

    final item =
        provider.oneTaskAndApprovals?.items?.firstOrNull ?? widget.initialItem;
    // final teamCode = authProvider.currentUser?.teamCode ?? 0;
    final qty = double.tryParse(_quantityController.text.trim()) ?? 0;

    await provider.updateOneTasksAndApprovals(
      altKey: item.altKey ?? '',
      trnsDate: item.trnsDate ?? '',
      bandCode: item.bandCode ?? 0,
      bandCodeDet: item.bandCodeDet ?? 0,
      unitCode: item.unitCode ?? 0,
      quantity: qty,
      notes: _notesController.text.trim(),
      authDesc: item.authDesc?.toString() ?? '',
      // authUserName: item.authUserNameA?.toString() ?? '',
      authDate: item.authDate?.toString() ?? '',
      authFlag: item.authFlag ?? 0,
    );

    if (!mounted) return;

    if (provider.errorMessage == null) {
      // Success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                l10n.saveSuccess,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          backgroundColor: Colors.green[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      await Future.delayed(const Duration(milliseconds: 1600));
      if (mounted) Navigator.of(context).pop();
    } else {
      // Error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  provider.errorMessage!,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // ── Delete ────────────────────────────────────────────────────────────────

  Future<void> _performDelete() async {
    final l10n = AppLocalizations.of(context)!;
    // Confirm dialog first
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red[600], size: 26),
            const SizedBox(width: 10),
            Text(
              l10n.deleteConfirmTitle,
              style: TextStyle(
                color: Colors.red[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          l10n.deleteConfirmBody,
          style: const TextStyle(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              l10n.cancel,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              l10n.btnDelete,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final provider = Provider.of<RequestMaterialFromStoreProvider>(
      context,
      listen: false,
    );
    final item =
        provider.oneTaskAndApprovals?.items?.firstOrNull ?? widget.initialItem;
    final teamCode = authProvider.currentUser?.teamCode ?? 0;

    await provider.deleteOneTasksAndApprovals(altKey: item.altKey ?? '');

    if (!mounted) return;

    if (provider.errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                l10n.deleteSuccess,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          backgroundColor: Colors.green[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      await Future.delayed(const Duration(milliseconds: 1600));
      if (mounted) Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  provider.errorMessage!,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
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
                  _DetailHeader(l10n: l10n),

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

                          return Stack(
                            children: [
                              // Scrollable content
                              SingleChildScrollView(
                                padding: EdgeInsets.fromLTRB(
                                  20,
                                  24,
                                  20,
                                  // Space for bottom buttons
                                  _canEdit ? 120 : 40,
                                ),
                                child: Column(
                                  children: [
                                    // Status badge + title
                                    _StatusBanner(item: item, l10n: l10n),
                                    const SizedBox(height: 20),

                                    // Loading overlay on top of content
                                    if (provider.isLoading)
                                      const LinearProgressIndicator(
                                        color: Color(0xFF4F46E5),
                                        backgroundColor: Colors.transparent,
                                      ),

                                    const SizedBox(height: 8),

                                    // ── Read-only notice banner ────────
                                    if (_isReadOnly)
                                      _ReadOnlyBanner(l10n: l10n),

                                    if (_isReadOnly) const SizedBox(height: 16),

                                    // ── Section 1: Request Info ────────
                                    _RequestInfoSection(
                                      item: item,
                                      l10n: l10n,
                                      isArabic:
                                          Localizations.localeOf(
                                            context,
                                          ).languageCode ==
                                          'ar',
                                      formatDate: _formatDate,
                                      quantityController: _quantityController,
                                      notesController: _notesController,
                                      isReadOnly: _isReadOnly,
                                    ),
                                    const SizedBox(height: 20),

                                    // ── Section 2: Approval Info ───────
                                    _ApprovalInfoSection(
                                      item: item,
                                      l10n: l10n,
                                      isArabic:
                                          Localizations.localeOf(
                                            context,
                                          ).languageCode ==
                                          'ar',
                                      formatDate: _formatDate,
                                    ),
                                  ],
                                ),
                              ),

                              // ── Pinned action buttons ──────────────
                              if (_canEdit)
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: _ActionButtons(
                                    l10n: l10n,
                                    canDelete: _canDelete,
                                    hasChanges: _hasChanges,
                                    isSaving: provider.isLoading,
                                    onSave: _performSave,
                                    onDelete: _performDelete,
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

// ── Header ────────────────────────────────────────────────────────────────────

class _DetailHeader extends StatelessWidget {
  final AppLocalizations l10n;
  const _DetailHeader({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back
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
            l10n.taskDetailsViewTitle,
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

// ── Status banner (serial + badge) ────────────────────────────────────────────

class _StatusBanner extends StatelessWidget {
  final Items item;
  final AppLocalizations l10n;

  const _StatusBanner({required this.item, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final statusText = isArabic
        ? (item.authStatusA ?? '')
        : (item.authStatusE ?? '');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Serial chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
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
        AuthStatusBadge(authFlag: item.authFlag, statusText: statusText),
      ],
    );
  }
}

// ── Read-only notice ──────────────────────────────────────────────────────────

class _ReadOnlyBanner extends StatelessWidget {
  final AppLocalizations l10n;
  const _ReadOnlyBanner({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_outline_rounded, color: Colors.green[700], size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.readOnlyMessage,
              style: TextStyle(
                fontSize: 13,
                color: Colors.green[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section 1: Request info ───────────────────────────────────────────────────

class _RequestInfoSection extends StatelessWidget {
  final Items item;
  final AppLocalizations l10n;
  final bool isArabic;
  final String Function(dynamic) formatDate;
  final TextEditingController quantityController;
  final TextEditingController notesController;
  final bool isReadOnly;

  const _RequestInfoSection({
    required this.item,
    required this.l10n,
    required this.isArabic,
    required this.formatDate,
    required this.quantityController,
    required this.notesController,
    required this.isReadOnly,
  });

  @override
  Widget build(BuildContext context) {
    final bandName = isArabic ? (item.bandNameA ?? '') : (item.bandNameE ?? '');
    final unitName = isArabic ? (item.unitNameA ?? '') : (item.unitNameE ?? '');

    return DetailSectionCard(
      title: l10n.sectionTaskInfo,
      icon: Icons.assignment_rounded,
      accentColor: const Color(0xFF4F46E5),
      children: [
        // Transaction Date
        DetailInfoRow(
          label: l10n.detailTrnsDate,
          value: formatDate(item.trnsDate),
          icon: Icons.calendar_today_rounded,
        ),

        // Band
        DetailInfoRow(
          label: l10n.detailBand,
          value: bandName,
          icon: Icons.layers_rounded,
        ),

        // Unit
        DetailInfoRow(
          label: l10n.detailUnit,
          value: unitName,
          icon: Icons.straighten_rounded,
        ),

        // Quantity & Notes — editable when allowed
        EditableFieldsWidget(
          quantityController: quantityController,
          notesController: notesController,
          isReadOnly: isReadOnly,
          l10n: l10n,
        ),
      ],
    );
  }
}

// ── Section 2: Approval info ──────────────────────────────────────────────────

class _ApprovalInfoSection extends StatelessWidget {
  final Items item;
  final AppLocalizations l10n;
  final bool isArabic;
  final String Function(dynamic) formatDate;

  const _ApprovalInfoSection({
    required this.item,
    required this.l10n,
    required this.isArabic,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    final authUserName = isArabic
        ? (item.authUserNameA?.toString() ?? '')
        : (item.authUserNameE?.toString() ?? '');

    Color accentColor;
    switch (item.authFlag) {
      case 1:
        accentColor = Colors.green;
        break;
      case 2:
        accentColor = Colors.red;
        break;
      default:
        accentColor = Colors.orange;
    }

    return DetailSectionCard(
      title: l10n.sectionAuthInfo,
      icon: Icons.verified_rounded,
      accentColor: accentColor,
      children: [
        // Auth description
        DetailInfoRow(
          label: l10n.detailAuthDesc,
          value: item.authDesc?.toString() ?? '',
          icon: Icons.description_rounded,
        ),

        // Auth user
        DetailInfoRow(
          label: l10n.detailAuthUser,
          value: authUserName,
          icon: Icons.person_rounded,
        ),

        // Auth date
        DetailInfoRow(
          label: l10n.detailAuthDate,
          value: formatDate(item.authDate),
          icon: Icons.event_rounded,
        ),
      ],
    );
  }
}

// ── Pinned action buttons ─────────────────────────────────────────────────────

class _ActionButtons extends StatelessWidget {
  final AppLocalizations l10n;
  final bool canDelete;
  final bool hasChanges;
  final bool isSaving;
  final VoidCallback onSave;
  final VoidCallback onDelete;

  const _ActionButtons({
    required this.l10n,
    required this.canDelete,
    required this.hasChanges,
    required this.isSaving,
    required this.onSave,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
      child: Row(
        children: [
          // Save button — active only when user has made changes
          Expanded(
            child: _SaveButton(
              l10n: l10n,
              onPressed: onSave,
              isEnabled: hasChanges && !isSaving,
              isSaving: isSaving,
            ),
          ),

          if (canDelete) ...[
            const SizedBox(width: 12),
            // Delete button — only for authFlag == 0
            _DeleteButton(l10n: l10n, onPressed: isSaving ? () {} : onDelete),
          ],
        ],
      ),
    );
  }
}

class _SaveButton extends StatefulWidget {
  final AppLocalizations l10n;
  final VoidCallback onPressed;
  final bool isEnabled;
  final bool isSaving;

  const _SaveButton({
    required this.l10n,
    required this.onPressed,
    this.isEnabled = true,
    this.isSaving = false,
  });

  @override
  State<_SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<_SaveButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isEnabled && !widget.isSaving;

    return GestureDetector(
      onTapDown: active ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: active
          ? (_) {
              setState(() => _isPressed = false);
              Future.delayed(
                const Duration(milliseconds: 100),
                widget.onPressed,
              );
            }
          : null,
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(_isPressed ? 0.97 : 1.0),
        height: 52,
        decoration: BoxDecoration(
          gradient: active
              ? const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(colors: [Colors.grey[300]!, Colors.grey[400]!]),
          borderRadius: BorderRadius.circular(14),
          boxShadow: active && !_isPressed
              ? [
                  BoxShadow(
                    color: const Color(0xFF4F46E5).withOpacity(0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ]
              : [],
        ),
        child: widget.isSaving
            ? const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.save_rounded,
                    color: active ? Colors.white : Colors.grey[500],
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.l10n.btnSave,
                    style: TextStyle(
                      color: active ? Colors.white : Colors.grey[500],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _DeleteButton extends StatefulWidget {
  final AppLocalizations l10n;
  final VoidCallback onPressed;
  const _DeleteButton({required this.l10n, required this.onPressed});

  @override
  State<_DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<_DeleteButton> {
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
        duration: const Duration(milliseconds: 180),
        transform: Matrix4.identity()..scale(_isPressed ? 0.97 : 1.0),
        height: 52,
        width: 52,
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.red.shade300),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Icon(Icons.delete_rounded, color: Colors.red[600], size: 24),
      ),
    );
  }
}
