
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shehabapp/features/workshops/screens/workOrderEquipmentsScreen.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/providers/locale_provider.dart';
import '../models/workshops_models.dart';

// =============================================================================
// SCREEN 2: WorkOrderDetailsScreen (Details View)
// =============================================================================

class WorkOrderDetailsScreen extends StatefulWidget {
  final String altKey;
  const WorkOrderDetailsScreen({super.key, required this.altKey});

  @override
  State<WorkOrderDetailsScreen> createState() => _WorkOrderDetailsScreenState();
}

class _WorkOrderDetailsScreenState extends State<WorkOrderDetailsScreen> with SingleTickerProviderStateMixin {
  WorkOrderModel? _details;
  bool _isLoading = true;
  String? _errorMessage;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _fetchDetails();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchDetails() async {
    final String apiUrl = "http://195.201.246.251:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/MneWorkOrdersMastVO1?q=AltKey=${widget.altKey}";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = data['items'] ?? [];
        if (items.isNotEmpty) {
          setState(() {
            _details = WorkOrderModel.fromJson(items[0]);
            _isLoading = false;
          });
          _animationController.forward();
        } else {
          setState(() {
            _errorMessage = "Details not found";
            _isLoading = false;
          });
        }
      } else {
        throw Exception("Failed to load details");
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _toggleLanguage(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final currentLocale = localeProvider.locale.languageCode;
    localeProvider.setLocale(Locale(currentLocale == 'ar' ? 'en' : 'ar'));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Provider.of<LocaleProvider>(context).locale.languageCode == 'ar';
    final primaryColor = const Color(0xFF4F46E5);
    final accentColor = const Color(0xFF7C3AED);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          l10n.details ?? "تفاصيل الطلب",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primaryColor, accentColor],
            ),
          ),
        ),
        actions: [
          // زر تبديل اللغة
          Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 8.0),
            child: Material(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _toggleLanguage(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.language,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isArabic ? 'EN' : 'عربي',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: primaryColor,
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.loading ?? "جاري التحميل...",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      )
          : _errorMessage != null || _details == null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              "${l10n.error ?? 'خطأ'}: $_errorMessage",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red[700], fontSize: 16),
            ),
          ],
        ),
      )
          : Column(
        children: [
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // --- Header Card with Work Order Number ---
                      _buildHeaderCard(context, primaryColor, accentColor, isArabic, l10n),
                      const SizedBox(height: 16),

                      // --- Card 1: Main Info ---
                      _buildSectionCard(
                        context,
                        title: l10n.workOrderNo ?? "بيانات الطلب",
                        icon: Icons.assignment_outlined,
                        iconColor: primaryColor,
                        children: [
                          _buildInfoRow(
                            l10n.workOrderNo ?? "رقم أمر العمل",
                            _details!.altKey,
                            icon: Icons.tag,
                          ),
                          _buildInfoRow(
                            l10n.reqNo ?? "رقم الطلب",
                            _details!.reqCode,
                            icon: Icons.confirmation_number_outlined,
                          ),
                          _buildInfoRow(
                            l10n.date ?? "التاريخ",
                            _details!.trnsDate,
                            icon: Icons.calendar_today_outlined,
                          ),
                          _buildInfoRow(
                            l10n.status ?? "الحالة",
                            _details!.getStatus(isArabic),
                            isHighlighted: true,
                            icon: Icons.check_circle_outline,
                          ),
                          _buildInfoRow(
                            l10n.authStatus ?? "الاعتماد",
                            _details!.getAuth(isArabic),
                            icon: Icons.verified_outlined,
                          ),
                          _buildInfoRow(
                            l10n.orderType ?? "نوع الأمر",
                            _details!.getType(isArabic),
                            icon: Icons.category_outlined,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // --- Card 2: Operations Info ---
                      _buildSectionCard(
                        context,
                        title: "بيانات التنفيذ",
                        icon: Icons.engineering_outlined,
                        iconColor: Colors.orange[700]!,
                        children: [
                          _buildInfoRow(
                            l10n.store ?? "المستودع",
                            _details!.getStore(isArabic),
                            icon: Icons.warehouse_outlined,
                          ),
                          _buildInfoRow(
                            l10n.technician ?? "الفني",
                            _details!.getTech(isArabic),
                            icon: Icons.person_outline,
                          ),
                          _buildInfoRow(
                            l10n.contactMethod ?? "طريقة الاستلام",
                            _details!.getContact(isArabic),
                            icon: Icons.contactless_outlined,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // --- Card 3: Notes ---
                      if ((_details!.notes != null && _details!.notes!.isNotEmpty) ||
                          (_details!.techNotes != null && _details!.techNotes!.isNotEmpty))
                        _buildSectionCard(
                          context,
                          title: l10n.notes ?? "الملاحظات",
                          icon: Icons.note_alt_outlined,
                          iconColor: Colors.blue[700]!,
                          children: [
                            if (_details!.notes != null && _details!.notes!.isNotEmpty)
                              _buildNoteBox(
                                "ملاحظات عامة",
                                _details!.notes!,
                                Colors.blue,
                              ),
                            if (_details!.notes != null && _details!.notes!.isNotEmpty &&
                                _details!.techNotes != null && _details!.techNotes!.isNotEmpty)
                              const SizedBox(height: 12),
                            if (_details!.techNotes != null && _details!.techNotes!.isNotEmpty)
                              _buildNoteBox(
                                "ملاحظات الفني",
                                _details!.techNotes!,
                                Colors.orange,
                              ),
                          ],
                        ),

                      if ((_details!.notes != null && _details!.notes!.isNotEmpty) ||
                          (_details!.techNotes != null && _details!.techNotes!.isNotEmpty))
                        const SizedBox(height: 16),

                      // --- Card 4: Audit Info ---
                      _buildSectionCard(
                        context,
                        title: "معلومات النظام",
                        icon: Icons.info_outlined,
                        iconColor: Colors.purple[700]!,
                        children: [
                          _buildInfoRow(
                            l10n.user ?? "المستخدم",
                            _details!.getUser(isArabic),
                            icon: Icons.account_circle_outlined,
                          ),
                          _buildInfoRow(
                            l10n.entryDate ?? "تاريخ الإدخال",
                            _details!.insertDate ?? "-",
                            icon: Icons.access_time,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // --- Bottom Action Button ---
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkOrderEquipmentsScreen(
                          altKey: _details!.altKey,
                          workOrderAltKey: _details!.altKey,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[700],
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    shadowColor: Colors.orange.withOpacity(0.3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.handyman, size: 24),
                      const SizedBox(width: 12),
                      Text(
                        l10n.viewEquipments ?? "عرض المعدات",
                        style: const TextStyle(
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
        ],
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, Color primaryColor, Color accentColor, bool isArabic, AppLocalizations l10n) {
    final isDelivered = _details!.statusDescE.toLowerCase() == 'delivered';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryColor, accentColor],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.receipt_long,
                  size: 32,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.workOrderNo ?? "أمر العمل",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _details!.altKey,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: isDelivered ? Colors.green : Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _details!.getStatus(isArabic),
                  style: TextStyle(
                    color: isDelivered ? Colors.green[800] : Colors.orange[800],
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color iconColor,
        required List<Widget> children,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.grey[800],
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      String label,
      String value, {
        bool isHighlighted = false,
        IconData? icon,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 18,
              color: Colors.grey[500],
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isHighlighted
                    ? Colors.green.withOpacity(0.1)
                    : Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: isHighlighted
                    ? Border.all(color: Colors.green.withOpacity(0.3))
                    : null,
              ),
              child: Text(
                value,
                style: TextStyle(
                  fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w600,
                  color: isHighlighted ? Colors.green[800] : Colors.grey[800],
                  fontSize: 14,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteBox(String title, String content, Color themeColor) {
    // تحديد الألوان المناسبة حسب نوع الملاحظة
    final iconColor = themeColor == Colors.blue ? Colors.blue.shade700 : Colors.orange.shade700;
    final textColor = themeColor == Colors.blue ? Colors.blue.shade800 : Colors.orange.shade800;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            themeColor.withOpacity(0.05),
            themeColor.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: themeColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.sticky_note_2_outlined,
                size: 18,
                color: iconColor,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}