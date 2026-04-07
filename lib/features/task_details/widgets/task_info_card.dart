import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../l10n/app_localizations.dart';

class TaskInfoCard extends StatelessWidget {
  final String? projectNameAr;
  final String? projectNameEn;
  final String? processNameAr;
  final String? processNameEn;
  final String? contractNo;
  final dynamic procPeriod;
  final dynamic procStartDate;
  final dynamic procEndDate;

  const TaskInfoCard({
    super.key,
    this.projectNameAr,
    this.projectNameEn,
    this.processNameAr,
    this.processNameEn,
    this.contractNo,
    this.procPeriod,
    this.procStartDate,
    this.procEndDate,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isArabic = localeProvider.locale.languageCode == 'ar';

    // Fallback to Arabic if English is null
    String displayProjectName = isArabic
        ? (projectNameAr ?? '')
        : (projectNameEn ?? projectNameAr ?? '');

    final displayProcessName = isArabic
        ? processNameAr
        : (processNameEn ?? processNameAr);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withValues(alpha: 0.1),

            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (contractNo != null && contractNo!.isNotEmpty) ...[
              _buildInfoRow(
                context,
                icon: Icons.tag,
                label: l10n.internalNumber,
                value: contractNo,
                gradientColors: [
                  const Color(0xFFEC4899),
                  const Color(0xFFF472B6),
                ],
              ),
              const SizedBox(height: 16),
            ],
            _buildInfoRow(
              context,
              icon: Icons.account_tree_rounded,
              label: l10n.projectName,
              value: displayProjectName,
              gradientColors: [
                const Color(0xFF4F46E5),
                const Color(0xFF6366F1),
              ],
            ),

            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              icon: Icons.settings_suggest_rounded,
              label: l10n.processName,
              value: displayProcessName,
              gradientColors: [
                const Color(0xFF7C3AED),
                const Color(0xFF8B5CF6),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              icon: Icons.timelapse_rounded,
              label: isArabic ? 'مدة العملية' : 'Process Period',
              value: procPeriod?.toString(),
              gradientColors: [
                const Color(0xFF14B8A6),
                const Color(0xFF2DD4BF),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              icon: Icons.event_available_rounded,
              label: isArabic ? 'تاريخ بداية العملية' : 'Process Start Date',
              value: _formatDate(procStartDate, isArabic: isArabic),
              gradientColors: [
                const Color(0xFF10B981),
                const Color(0xFF34D399),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              icon: Icons.event_busy_rounded,
              label: isArabic ? 'تاريخ نهاية العملية' : 'Process End Date',
              value: _formatDate(procEndDate, isArabic: isArabic),
              gradientColors: [
                const Color(0xFFF59E0B),
                const Color(0xFFFBBF24),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    String? value,
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
          child: Icon(icon, color: Colors.white, size: 24),
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
                value ?? '',
                style: TextStyle(
                  fontSize: 16,
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

  String _formatDate(dynamic rawValue, {required bool isArabic}) {
    if (rawValue == null) return '';
    final value = rawValue.toString().trim();
    if (value.isEmpty) return '';

    final parsedDate = DateTime.tryParse(value);
    if (parsedDate == null) return value;

    final locale = isArabic ? 'ar' : 'en';
    return DateFormat('dd MMM yyyy', locale).format(parsedDate);
  }
}
