import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shehabapp/core/models/safe_and_security_data_model.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/providers/safe_and_security_provider.dart';
import 'widgets/safe_and_security_attachment_bottom_sheet.dart';

class SafeAndSecurityDetailsView extends StatefulWidget {
  final Items item;

  const SafeAndSecurityDetailsView({super.key, required this.item});

  static const String routeName = 'safe_and_security_details_view';

  @override
  State<SafeAndSecurityDetailsView> createState() =>
      _SafeAndSecurityDetailsViewState();
}

class _SafeAndSecurityDetailsViewState extends State<SafeAndSecurityDetailsView>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final TextEditingController _remarksController = TextEditingController();

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

    _remarksController.text = widget.item.remarks?.toString() ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  // ─── helpers ────────────────────────────────────────────────────────────────

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  String _label(String ar, String en) => _isArabic ? ar : en;

  // ─── execute (update done flag) ─────────────────────────────────────────────

  Future<void> _handleExecute() async {
    final provider = Provider.of<SafeAndSecurityProvider>(
      context,
      listen: false,
    );
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final usersCode = authProvider.currentUser?.usersCode.toString() ?? '';

    if (usersCode.isEmpty) {
      _showSnack(
        _label('خطأ: كود المستخدم غير متوفر', 'Error: user code not found'),
        Colors.red,
      );
      return;
    }

    final now = DateTime.now();
    final formattedDate =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    try {
      await provider.updateDoneFlag(
        usersCode: usersCode,
        doneFlag: 1,
        doneDate: formattedDate,
      );

      if (mounted) {
        _showSnack(
          _label('تم التنفيذ بنجاح ✓', 'Executed successfully ✓'),
          _green1,
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        _showSnack(_label('حدث خطأ: $e', 'Error: $e'), Colors.red);
      }
    }
  }

  // ─── attachments ─────────────────────────────────────────────────────────────

  Future<void> _handleAttachmentsTap() async {
    final provider = Provider.of<SafeAndSecurityProvider>(
      context,
      listen: false,
    );
    final isArabic = _isArabic;

    final projectId = widget.item.projectId?.toString();
    final partId = widget.item.partId?.toString();
    final safeId = widget.item.safeId?.toString();

    if (projectId == null || partId == null || safeId == null) {
      _showSnack(_label('بيانات ناقصة', 'Missing data'), Colors.red);
      return;
    }

    _showSnack(
      isArabic ? 'جاري تحميل المرفقات...' : 'Loading attachments...',
      _green2,
      duration: 1,
    );

    await provider.getSafeAndSecurityDetailsAttachment(
      projectId: projectId,
      partId: partId,
      safeId: safeId,
    );

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: SafeAndSecurityAttachmentBottomSheet(
          attachmentData: provider.attachmentModel,
          isArabic: isArabic,
          projectId: projectId,
          partId: partId,
          safeId: safeId,
        ),
      ),
    );
  }

  void _showSnack(String msg, Color color, {int duration = 2}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: duration),
      ),
    );
  }

  // ─── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
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
                  _buildHeader(context),
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
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Page title
                            Text(
                              _label(
                                'تفاصيل السلامة والأمان',
                                'Safety & Security Details',
                              ),
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // ── Section 1: Info ────────────────────────────
                            _buildSectionTitle(
                              _label('معلومات السجل', 'Record Information'),
                              Icons.info_outline_rounded,
                            ),
                            const SizedBox(height: 16),
                            _buildInfoCard(),
                            const SizedBox(height: 24),

                            // ── Section 2: Notes ───────────────────────────
                            _buildSectionTitle(
                              _label('الملاحظات', 'Remarks'),
                              Icons.note_alt_outlined,
                            ),
                            const SizedBox(height: 16),
                            _buildRemarksCard(),
                            const SizedBox(height: 24),

                            // ── Section 3: Actions ─────────────────────────
                            _buildSectionTitle(
                              _label('الإجراءات', 'Actions'),
                              Icons.touch_app_rounded,
                            ),
                            const SizedBox(height: 16),
                            _buildActionsCard(),
                            const SizedBox(height: 32),
                          ],
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

  // ─── header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
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
                color: Colors.white.withValues(alpha: 0.25),
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
                _label('تفاصيل السلامة', 'Safety Details'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // Language toggle
          Consumer<LocaleProvider>(
            builder: (context, provider, child) {
              final isAr = provider.locale.languageCode == 'ar';
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      provider.setLocale(Locale(isAr ? 'en' : 'ar'));
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
                            isAr ? 'EN' : 'ع',
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

  // ─── section title ──────────────────────────────────────────────────────────

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [_green1, _green2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: _green1.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  // ─── info card ──────────────────────────────────────────────────────────────

  Widget _buildInfoCard() {
    final isAr = _isArabic;
    final item = widget.item;

    final projectName = isAr
        ? item.projectNameA
        : (item.projectNameE?.toString() ?? item.projectNameA);
    final safeName = isAr
        ? item.safeNameA
        : (item.safeNameE?.toString() ?? item.safeNameA);

    final isDone = item.doneFlag == 1;
    final doneStatus = isAr ? item.doneStatusA : item.doneStatusE;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _green1.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.tag,
            label: _label('رقم العقد', 'Contract No.'),
            value: item.contractNo ?? '-',
            gradientColors: const [Color(0xFFEC4899), Color(0xFFF472B6)],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.folder_outlined,
            label: _label('رقم السجل', 'Sec No.'),
            value: item.secNo?.toString() ?? '-',
            gradientColors: const [Color(0xFF0891B2), Color(0xFF22D3EE)],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.account_tree_rounded,
            label: _label('اسم المشروع', 'Project Name'),
            value: projectName?.toString() ?? '-',
            gradientColors: const [Color(0xFF4F46E5), Color(0xFF6366F1)],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.shield_outlined,
            label: _label('البند', 'Safety Item'),
            value: safeName?.toString() ?? '-',
            gradientColors: const [_green1, _green2],
          ),
          if (item.doneDate != null && item.doneDate!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildInfoRow(
              icon: Icons.calendar_today_rounded,
              label: _label('تاريخ التنفيذ', 'Done Date'),
              value: item.doneDate ?? '-',
              gradientColors: const [Color(0xFFF59E0B), Color(0xFFFBBF24)],
            ),
          ],
          const SizedBox(height: 16),
          // Status badge row
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDone
                        ? [_green1, _green2]
                        : [Colors.orange, Colors.amber],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: (isDone ? _green1 : Colors.orange).withValues(
                        alpha: 0.3,
                      ),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  isDone ? Icons.check_circle : Icons.pending,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _label('الحالة', 'Status'),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: (isDone ? _green1 : Colors.orange).withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDone ? _green1 : Colors.orange,
                        ),
                      ),
                      child: Text(
                        doneStatus ??
                            (isDone
                                ? _label('منفّذ', 'Done')
                                : _label('قيد التنفيذ', 'Pending')),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isDone ? _green1 : Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required List<Color> gradientColors,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: gradientColors[0].withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 16),
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
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── remarks card ────────────────────────────────────────────────────────────

  Widget _buildRemarksCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _green1.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_green1, _green2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: _green1.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.note_alt_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _label('الملاحظات', 'Remarks'),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _green1.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: TextField(
              controller: _remarksController,
              maxLines: 4,
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
              decoration: InputDecoration(
                hintText: _label(
                  'أدخل الملاحظات هنا...',
                  'Enter remarks here...',
                ),
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── actions card ─────────────────────────────────────────────────────────────

  Widget _buildActionsCard() {
    final isDone = widget.item.doneFlag == 1;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _green1.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Execute / Mark done
          _buildActionButton(
            icon: isDone ? Icons.check_circle : Icons.play_circle_fill,
            label: isDone
                ? _label('تم التنفيذ بالفعل', 'Already Executed')
                : _label('تنفيذ', 'Execute'),
            gradientColors: isDone
                ? [Colors.grey[400]!, Colors.grey[500]!]
                : [_green1, _green2],
            onTap: isDone ? null : _handleExecute,
          ),
          const SizedBox(height: 14),
          // Attachments
          _buildActionButton(
            icon: Icons.attach_file_rounded,
            label: _label('المرفقات', 'Attachments'),
            gradientColors: const [Color(0xFF4F46E5), Color(0xFF7C3AED)],
            onTap: _handleAttachmentsTap,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required List<Color> gradientColors,
    required VoidCallback? onTap,
  }) {
    final disabled = onTap == null;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: disabled
                  ? [Colors.grey[300]!, Colors.grey[400]!]
                  : gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: disabled
                ? []
                : [
                    BoxShadow(
                      color: gradientColors[0].withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              if (!disabled)
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white54,
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
