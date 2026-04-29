import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shehabapp/core/models/materials_model.dart';
import 'package:shehabapp/core/providers/auth_provider.dart';
import 'package:shehabapp/core/providers/locale_provider.dart';
import 'package:shehabapp/core/providers/request_material_from_store_provider.dart';
import 'package:shehabapp/l10n/app_localizations.dart';

class RequestMaterialApprovalDetails extends StatefulWidget {
  final Items initialItem;

  const RequestMaterialApprovalDetails({super.key, required this.initialItem});

  static const String routeName = 'request_material_approval_details';

  @override
  State<RequestMaterialApprovalDetails> createState() =>
      _RequestMaterialApprovalDetailsState();
}

class _RequestMaterialApprovalDetailsState
    extends State<RequestMaterialApprovalDetails>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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

  Future<void> _loadDetail() async {
    final provider = Provider.of<RequestMaterialFromStoreProvider>(
      context,
      listen: false,
    );

    final altKey = widget.initialItem.altKey ?? '';
    await provider.fetchOneMaterial(altKey: altKey);

    final freshItem = provider.oneMaterialModel?.items?.firstOrNull;
    if (freshItem != null && mounted) {
      _authDescController.text = freshItem.authDesc?.toString() ?? '';
    }
  }

  String _formatDate(dynamic raw) {
    if (raw == null || raw.toString().isEmpty) return '—';
    try {
      final date = DateTime.parse(raw.toString());
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (_) {
      return raw.toString();
    }
  }

  Future<void> _performApprove() async {
    await _performAuth(authFlag: 1);
  }

  Future<void> _performCancelApproval() async {
    await _performAuth(authFlag: 0);
  }

  Future<void> _performReject() async {
    await _performAuth(authFlag: 2);
  }

  Future<void> _performAuth({required int authFlag}) async {
    final l10n = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final provider = Provider.of<RequestMaterialFromStoreProvider>(
      context,
      listen: false,
    );

    final item =
        provider.oneMaterialModel?.items?.firstOrNull ?? widget.initialItem;

    final userName = authProvider.currentUser?.usersName ?? '';
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    await provider.updateOneMaterialAndApproval(
      altKey: item.altKey ?? '',
      trnsDate: item.trnsDate ?? today,
      quantity: item.quantity?.toString() ?? '0',
      authDesc: _authDescController.text.trim(),
      authUser: authFlag == 0 ? '' : userName,
      authDate: authFlag == 0 ? '' : today,
      authFlag: authFlag,
    );

    if (!mounted) return;

    if (provider.errorMessage == null) {
      final successMsg = _successMessage(l10n, authFlag);
      _showSnackBar(context, successMsg, isSuccess: true);
      await Future.delayed(const Duration(milliseconds: 1600));
      if (mounted) Navigator.of(context).pop(true);
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
                  _ApprovalDetailHeader(l10n: l10n),
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
                                  160,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    _StatusBanner(
                                      item: item,
                                      isArabic: isArabic,
                                    ),
                                    const SizedBox(height: 20),
                                    if (provider.isLoading)
                                      const LinearProgressIndicator(
                                        color: Color(0xFF4F46E5),
                                        backgroundColor: Colors.transparent,
                                      ),
                                    const SizedBox(height: 8),
                                    _RequestInfoSection(
                                      item: item,
                                      l10n: l10n,
                                      isArabic: isArabic,
                                      formatDate: _formatDate,
                                    ),
                                    const SizedBox(height: 20),
                                    _ApproverNotesSection(
                                      l10n: l10n,
                                      controller: _authDescController,
                                    ),
                                  ],
                                ),
                              ),
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

class _StatusBanner extends StatelessWidget {
  final Items item;
  final bool isArabic;
  const _StatusBanner({required this.item, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    final statusText = isArabic
        ? (item.authNameA ?? '')
        : (item.authNameE ?? '');
    final badgeColor = _badgeColor(item.authFlag);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
              color: const Color(0xFF4F46E5).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF4F46E5)),
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
            color: const Color(0xFF4F46E5).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
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
    final projectName = isArabic
        ? (item.projectNameA ?? '')
        : (item.projectNameE ?? '');
    final itemName = isArabic ? (item.itemNameA ?? '') : (item.itemNameE ?? '');
    final unitName = isArabic ? (item.unitNameA ?? '') : (item.unitNameE ?? '');
    final desc = isArabic ? (item.descA ?? '') : (item.descE ?? '');
    final insertUserName = isArabic
        ? (item.insertUserNameA ?? '')
        : (item.insertUserNameE ?? '');

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
          label: isArabic ? 'رقم العقد' : 'Contract No',
          value: item.contractNo ?? '',
          icon: Icons.numbers_rounded,
        ),
        _InfoRow(
          label: isArabic ? 'المشروع' : 'Project',
          value: projectName,
          icon: Icons.business_center_rounded,
        ),
        _InfoRow(label: l10n.item, value: itemName, icon: Icons.layers_rounded),
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
          label: isArabic ? 'البيان' : 'Description',
          value: desc,
          icon: Icons.notes_rounded,
        ),
        _InfoRow(
          label: isArabic ? 'مدخل الطلب' : 'Inserted By',
          value: insertUserName,
          icon: Icons.person_add_rounded,
        ),
        _InfoRow(
          label: isArabic ? 'تاريخ الادخال' : 'Insert Date',
          value: formatDate(item.insertDate),
          icon: Icons.event_available_rounded,
        ),
      ],
    );
  }
}

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
                color: Color(0xFF4F46E5),
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
          _ActionBtn(
            label: l10n.approvalBtnApprove,
            icon: Icons.check_circle_rounded,
            gradient: const [Color(0xFF10B981), Color(0xFF059669)],
            shadowColor: const Color(0xFF10B981),
            onPressed: onApprove,
          ),
          const SizedBox(height: 10),
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
