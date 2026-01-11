
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shehabapp/features/workshops/screens/workOrderDetailsScreen.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/providers/locale_provider.dart';
import '../models/workshops_models.dart';

// =============================================================================
// SCREEN 1: WorkshopsScreen (Main List - The Table)
// =============================================================================

class WorkshopsScreen extends StatefulWidget {
  static const String routeName = '/workshops';
  const WorkshopsScreen({super.key});

  @override
  State<WorkshopsScreen> createState() => _WorkshopsScreenState();
}

class _WorkshopsScreenState extends State<WorkshopsScreen> with SingleTickerProviderStateMixin {
  List<WorkOrderModel> _workOrders = [];
  bool _isLoading = true;
  String? _errorMessage;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _fetchWorkOrders();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchWorkOrders() async {
    const String apiUrl = "http://195.201.246.251:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/MneWorkOrdersMastVO1";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = data['items'] ?? [];
        setState(() {
          _workOrders = items.map((e) => WorkOrderModel.fromJson(e)).toList();
          // ترتيب البيانات من الأحدث إلى الأقدم
          _workOrders.sort((a, b) {
            try {
              // محاولة تحويل التاريخ للمقارنة
              DateTime dateA = _parseDate(a.trnsDate);
              DateTime dateB = _parseDate(b.trnsDate);
              return dateB.compareTo(dateA); // ترتيب تنازلي (الأحدث أولاً)
            } catch (e) {
              return 0; // في حالة فشل التحويل، يبقى الترتيب كما هو
            }
          });
          _isLoading = false;
        });
        _animationController.forward();
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // دالة مساعدة لتحويل التاريخ من أي صيغة
  DateTime _parseDate(String dateString) {
    try {
      // محاولة تحويل التاريخ بصيغ مختلفة
      // مثال: "2024-12-04" أو "04/12/2024" أو "04-12-2024"
      dateString = dateString.trim();

      if (dateString.contains('-')) {
        return DateTime.parse(dateString);
      } else if (dateString.contains('/')) {
        List<String> parts = dateString.split('/');
        if (parts.length == 3) {
          // افترض الصيغة dd/MM/yyyy أو MM/dd/yyyy
          int day = int.parse(parts[0]);
          int month = int.parse(parts[1]);
          int year = int.parse(parts[2]);
          return DateTime(year, month, day);
        }
      }
      return DateTime.now();
    } catch (e) {
      return DateTime.now();
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
          l10n.workshopsModule ?? "الورش والصيانة",
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
          : _errorMessage != null
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
          : _workOrders.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              l10n.noData ?? "لا توجد بيانات",
              style: TextStyle(color: Colors.grey[600], fontSize: 18),
            ),
          ],
        ),
      )
          : FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // --- Enhanced Header Card ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      primaryColor.withOpacity(0.1),
                      accentColor.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: primaryColor.withOpacity(0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [primaryColor, accentColor],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.engineering,
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
                            l10n.workshopsModule ?? "أوامر العمل",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${_workOrders.length} ${l10n.workOrders ?? 'أمر'}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- Enhanced Table ---
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width - 32,
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.grey[200],
                        ),
                        child: DataTable(
                          headingRowColor: MaterialStateProperty.all(
                            primaryColor.withOpacity(0.05),
                          ),
                          headingRowHeight: 56,
                          dataRowHeight: 72,
                          columnSpacing: 20,
                          horizontalMargin: 20,
                          columns: [
                            DataColumn(
                              label: _buildHeaderLabel(
                                l10n.reqNo ?? "رقم الطلب",
                                Icons.confirmation_number_outlined,
                                primaryColor,
                              ),
                            ),
                            DataColumn(
                              label: _buildHeaderLabel(
                                l10n.workOrderNo ?? "أمر العمل",
                                Icons.assignment_outlined,
                                primaryColor,
                              ),
                            ),
                            DataColumn(
                              label: _buildHeaderLabel(
                                l10n.date ?? "التاريخ",
                                Icons.calendar_today_outlined,
                                primaryColor,
                              ),
                            ),
                            DataColumn(
                              label: _buildHeaderLabel(
                                l10n.status ?? "الحالة",
                                Icons.info_outline,
                                primaryColor,
                              ),
                            ),
                          ],
                          rows: _workOrders.asMap().entries.map((entry) {
                            final order = entry.value;
                            final isEven = entry.key.isEven;

                            return DataRow(
                              color: MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return primaryColor.withOpacity(0.1);
                                  }
                                  return isEven ? Colors.grey[50] : Colors.white;
                                },
                              ),
                              onSelectChanged: (selected) {
                                if (selected == true) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WorkOrderDetailsScreen(
                                        altKey: order.altKey,
                                      ),
                                    ),
                                  );
                                }
                              },
                              cells: [
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          primaryColor.withOpacity(0.1),
                                          accentColor.withOpacity(0.1),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: primaryColor.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      order.reqCode,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    order.altKey,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[800],
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.event,
                                        size: 16,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        order.trnsDate,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  _buildStatusChip(
                                    order.getStatus(isArabic),
                                    order.statusDescE.toLowerCase() == 'delivered',
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderLabel(String text, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status, bool isDelivered) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDelivered
              ? [Colors.green[50]!, Colors.green[100]!]
              : [Colors.orange[50]!, Colors.orange[100]!],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isDelivered ? Colors.green : Colors.orange,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDelivered ? Colors.green : Colors.orange).withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isDelivered ? Colors.green : Colors.orange,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              color: isDelivered ? Colors.green[800] : Colors.orange[800],
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}