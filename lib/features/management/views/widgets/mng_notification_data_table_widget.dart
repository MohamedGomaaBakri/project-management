import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/models/create_notification_model.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/providers/locale_provider.dart';
import 'package:provider/provider.dart';
import '../mng_notification_details_view.dart';

class MngNotificationDataTableWidget extends StatelessWidget {
  final List<Items> notifications;

  const MngNotificationDataTableWidget({
    super.key,
    required this.notifications,
  });

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';

    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('yyyy-MM-dd HH:mm').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  String _getLocalizedText(
    BuildContext context,
    String? arabicText,
    dynamic englishText,
  ) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final isArabic = localeProvider.locale.languageCode == 'ar';

    if (isArabic) {
      return arabicText ?? '';
    } else {
      if (englishText == null) return arabicText ?? '';
      return englishText.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;

    if (notifications.isEmpty) {
      return _buildEmptyState(l10n);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: size.width - 48),
            child: DataTable(
              headingRowHeight: 56,
              dataRowMaxHeight: 64,
              columnSpacing: 24,
              horizontalMargin: 20,
              headingRowColor: WidgetStateProperty.all(
                const Color(0xFF4F46E5).withOpacity(0.05),
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[200]!, width: 1),
                ),
              ),
              columns: [
                _buildDataColumn(l10n.serialNumber, Icons.numbers),
                _buildDataColumn(l10n.contractNumber, Icons.numbers),
                _buildDataColumn(l10n.userType, Icons.person),
                _buildDataColumn(l10n.notificationType, Icons.notifications),
                _buildDataColumn(l10n.notificationDate, Icons.calendar_today),
                _buildDataColumn(l10n.replyStatus, Icons.check_circle),
              ],
              rows: notifications.asMap().entries.map((entry) {
                final notification = entry.value;
                return _buildDataRow(context, notification, l10n);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  DataColumn _buildDataColumn(String label, IconData icon) {
    return DataColumn(
      label: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF4F46E5)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF4F46E5),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildDataRow(
    BuildContext context,
    Items notification,
    AppLocalizations l10n,
  ) {
    return DataRow(
      color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (notification.doneFlag == 1) {
          return Colors.green[50];
        }
        if (notification.doneFlag == 0) {
          return Colors.red[50];
        }
        return Colors.grey[50];
      }),
      onSelectChanged: (_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MngNotificationDetailsView(altKey: notification.altKey ?? ''),
          ),
        );
      },
      cells: [
        DataCell(
          Text(
            notification.noteSer?.toString() ?? '',
            style: TextStyle(fontSize: 13, color: Colors.grey[800]),
          ),
        ),
        DataCell(
          Text(
            notification.contractNo?.toString() ?? '',
            style: TextStyle(fontSize: 13, color: Colors.grey[800]),
          ),
        ),
        DataCell(
          Text(
            _getLocalizedText(
              context,
              notification.userTypeName,
              notification.userTypeNameE,
            ),
            style: TextStyle(fontSize: 13, color: Colors.grey[800]),
          ),
        ),
        DataCell(
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200),
            child: Text(
              _getLocalizedText(
                context,
                notification.noteTypeName,
                notification.noteTypeNameE,
              ),
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataCell(
          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                _formatDate(notification.noteDate),
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
        DataCell(
          Checkbox(
            value: notification.doneFlag == 1,
            onChanged: null,
            activeColor: const Color(0xFF4F46E5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF4F46E5).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.inbox_outlined,
                size: 48,
                color: Color(0xFF4F46E5),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noNotificationsFound,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
