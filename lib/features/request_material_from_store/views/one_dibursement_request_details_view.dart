import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shehabapp/core/models/materials_model.dart';
import 'package:shehabapp/core/providers/auth_provider.dart';
import 'package:shehabapp/core/providers/locale_provider.dart';
import 'package:shehabapp/core/providers/request_material_from_store_provider.dart';
import 'package:shehabapp/features/request_material_from_store/widgets/material_detail_widgets.dart';
import 'package:shehabapp/l10n/app_localizations.dart';

/// Detail screen for a single material disbursement request item.
///
/// Behaviour based on [Items.authFlag]:
///   0 → editable (quantity) + Delete button (if applicable)
///   1 → fully read-only, no Save / Delete
///   2 → editable (quantity) but NO Delete button
class OneDibursementRequestDetailsView extends StatefulWidget {
  final Items initialItem;

  const OneDibursementRequestDetailsView({
    super.key,
    required this.initialItem,
  });

  static const String routeName = 'one_disbursement_request_details_view';

  @override
  State<OneDibursementRequestDetailsView> createState() =>
      _OneDibursementRequestDetailsViewState();
}

class _OneDibursementRequestDetailsViewState
    extends State<OneDibursementRequestDetailsView>
    with TickerProviderStateMixin {
  // ── Animations ────────────────────────────────────────────────────────────
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // ── Editable field controllers ────────────────────────────────────────────
  late TextEditingController _quantityController;

  // ── Change tracking — Save button is only active when user edits ──────────
  bool _hasChanges = false;
  String _originalQuantity = '';

  @override
  void initState() {
    super.initState();

    _originalQuantity = widget.initialItem.quantity?.toString() ?? '';

    _quantityController = TextEditingController(text: _originalQuantity);
    _quantityController.addListener(_onFieldChanged);

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
    _quantityController.dispose();
    super.dispose();
  }

  // ── Load single item detail ───────────────────────────────────────────────

  Future<void> _loadDetail() async {
    final provider = Provider.of<RequestMaterialFromStoreProvider>(
      context,
      listen: false,
    );
    final altKey = widget.initialItem.altKey ?? '';

    await provider.fetchOneMaterial(altKey: altKey);

    final item = provider.oneMaterialModel?.items?.firstOrNull;
    if (item != null && mounted) {
      _originalQuantity = item.quantity?.toString() ?? '';
      _quantityController.text = _originalQuantity;
      setState(() => _hasChanges = false);
    }
  }

  // ── Change detection ──────────────────────────────────────────────────────

  void _onFieldChanged() {
    final changed = _quantityController.text.trim() != _originalQuantity.trim();
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

  bool get _canEdit => widget.initialItem.authFlag == 2;

  bool get _isReadOnly => widget.initialItem.authFlag != 2;

  // ── Save ──────────────────────────────────────────────────────────────────

  Future<void> _performSave() async {
    final l10n = AppLocalizations.of(context)!;
    final provider = Provider.of<RequestMaterialFromStoreProvider>(
      context,
      listen: false,
    );
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final item =
        provider.oneMaterialModel?.items?.firstOrNull ?? widget.initialItem;

    final qty = _quantityController.text.trim();

    await provider.updateOneMaterialAndApproval(
      altKey: item.altKey ?? '',
      trnsDate: item.trnsDate ?? '',
      quantity: qty,
      authDesc: item.authDesc?.toString() ?? '',
      authDate: item.authDate?.toString() ?? '',
      authUser:
          authProvider.currentUser?.usersName ??
          '', // Or keep existing authUser if needed
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
                              provider.oneMaterialModel?.items?.firstOrNull ??
                              widget.initialItem;

                          return Stack(
                            children: [
                              // Scrollable content
                              SingleChildScrollView(
                                padding: EdgeInsets.fromLTRB(
                                  20,
                                  24,
                                  20,
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

                                    // Read-only notice banner
                                    if (_isReadOnly)
                                      _ReadOnlyBanner(l10n: l10n),

                                    if (_isReadOnly) const SizedBox(height: 16),

                                    // Section 1: Request Info
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
                                      isReadOnly: _isReadOnly,
                                    ),
                                    const SizedBox(height: 20),

                                    // Section 2: Approval Info
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

                              // Pinned action buttons
                              if (_canEdit)
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: _ActionButtons(
                                    l10n: l10n,
                                    hasChanges: _hasChanges,
                                    isSaving: provider.isLoading,
                                    onSave: _performSave,
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
            l10n.taskDetailsViewTitle, // Re-use or define new string if needed
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Language toggle
          Consumer<LocaleProvider>(
            builder: (context, provider, _) {
              final isArabic = provider.locale.languageCode == 'ar';
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
        ? (item.authNameA ?? '')
        : (item.authNameE ?? '');

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
        MaterialAuthStatusBadge(
          authFlag: item.authFlag,
          statusText: statusText,
        ),
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
  final bool isReadOnly;

  const _RequestInfoSection({
    required this.item,
    required this.l10n,
    required this.isArabic,
    required this.formatDate,
    required this.quantityController,
    required this.isReadOnly,
  });

  @override
  Widget build(BuildContext context) {
    final itemName = isArabic ? (item.itemNameA ?? '') : (item.itemNameE ?? '');
    final unitName = isArabic ? (item.unitNameA ?? '') : (item.unitNameE ?? '');
    final projectName = isArabic
        ? (item.projectNameA ?? '')
        : (item.projectNameE ?? '');
    final contractNo = item.contractNo ?? '';
    final description = isArabic ? (item.descA ?? '') : (item.descE ?? '');
    final insertUserName = isArabic
        ? (item.insertUserNameA ?? '')
        : (item.insertUserNameE ?? '');
    final statusName = isArabic
        ? (item.statusNameA ?? '')
        : (item.statusNameE ?? '');

    return MaterialDetailSectionCard(
      title:
          l10n.sectionTaskInfo, // Re-use or add sectionRequestInfo if available
      icon: Icons.assignment_rounded,
      accentColor: const Color(0xFF4F46E5),
      children: [
        MaterialDetailInfoRow(
          label: l10n.detailTrnsDate,
          value: formatDate(item.trnsDate),
          icon: Icons.calendar_today_rounded,
        ),
        MaterialDetailInfoRow(
          label: l10n.item,
          value: itemName,
          icon: Icons.layers_rounded,
        ),
        MaterialDetailInfoRow(
          label: l10n.detailUnit,
          value: unitName,
          icon: Icons.straighten_rounded,
        ),
        MaterialDetailInfoRow(
          label: isArabic ? 'رقم العقد' : 'Contract No',
          value: contractNo,
          icon: Icons.numbers_rounded,
        ),
        MaterialDetailInfoRow(
          label: l10n.project, // Assuming l10n.project exists
          value: projectName,
          icon: Icons.business_rounded,
        ),
        MaterialDetailInfoRow(
          label: isArabic ? 'البيان' : 'Description',
          value: description,
          icon: Icons.notes_rounded,
        ),
        MaterialDetailInfoRow(
          label: l10n.status,
          value: statusName,
          icon: Icons.info_outline_rounded,
        ),
        MaterialEditableFieldsWidget(
          quantityController: quantityController,
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

    return MaterialDetailSectionCard(
      title: l10n.sectionAuthInfo,
      icon: Icons.verified_rounded,
      accentColor: accentColor,
      children: [
        MaterialDetailInfoRow(
          label: isArabic ? 'مدخل الطلب' : 'Inserted By',
          value: isArabic
              ? (item.insertUserNameA ?? '')
              : (item.insertUserNameE ?? ''),
          icon: Icons.person_add_rounded,
        ),
        MaterialDetailInfoRow(
          label: isArabic ? 'تاريخ الادخال' : 'Insert Date',
          value: formatDate(item.insertDate),
          icon: Icons.event_available_rounded,
        ),
        MaterialDetailInfoRow(
          label: l10n.detailAuthDesc,
          value: item.authDesc?.toString() ?? '',
          icon: Icons.description_rounded,
        ),
        MaterialDetailInfoRow(
          label: l10n.detailAuthUser,
          value: authUserName,
          icon: Icons.person_rounded,
        ),
        MaterialDetailInfoRow(
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
  final bool hasChanges;
  final bool isSaving;
  final VoidCallback onSave;

  const _ActionButtons({
    required this.l10n,
    required this.hasChanges,
    required this.isSaving,
    required this.onSave,
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
