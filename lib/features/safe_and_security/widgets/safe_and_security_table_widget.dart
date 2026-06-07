import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shehabapp/core/models/safe_and_security_data_model.dart';
import '../../../l10n/app_localizations.dart';

const Color _kGreen1 = Color(0xFF16A34A);
const Color _kGreen2 = Color(0xFF059669);

class SafeAndSecurityTableWidget extends StatelessWidget {
  final List<Items> items;

  const SafeAndSecurityTableWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;

    if (items.isEmpty) {
      return _buildEmptyState(l10n);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _kGreen1.withValues(alpha: 0.08),
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
                _kGreen1.withValues(alpha: 0.07),
              ),
              columns: [
                _buildColumn(l10n.internalNumber, Icons.tag),
                _buildColumn(l10n.explanation, Icons.shield_outlined),
                _buildColumn(l10n.executionDate, Icons.calendar_today),
                _buildColumn(l10n.status, Icons.check_circle),
              ],
              rows: items.asMap().entries.map((entry) {
                return _buildRow(context, entry.value, entry.key, l10n);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  DataColumn _buildColumn(String label, IconData icon) {
    return DataColumn(
      label: Row(
        children: [
          Icon(icon, size: 18, color: _kGreen1),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: _kGreen1,
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildRow(
    BuildContext context,
    Items item,
    int index,
    AppLocalizations l10n,
  ) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final safeName = isArabic ? item.safeNameA : item.safeNameE;

    String formattedDate = '';
    if (item.doneDate != null && item.doneDate.toString().isNotEmpty) {
      try {
        final date = DateTime.parse(item.doneDate.toString());
        formattedDate = DateFormat('yyyy-MM-dd').format(date);
      } catch (e) {
        formattedDate = item.doneDate.toString();
      }
    }

    return DataRow(
      // ✅ Navigate disabled — detail screen not yet built
      color: WidgetStateProperty.resolveWith<Color?>((states) {
        return item.doneFlag == 1 ? Colors.green[50] : Colors.red[50];
      }),
      cells: [
        // 1. ContractNo
        DataCell(
          Text(
            item.contractNo?.toString() ?? '',
            style: TextStyle(fontSize: 13, color: Colors.grey[800]),
          ),
        ),
        // 2. SafeName
        DataCell(
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200),
            child: Text(
              safeName?.toString() ?? '',
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        // 3. DoneDate
        DataCell(
          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                formattedDate,
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
        // 4. DoneFlag status
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: item.doneFlag == 1
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: item.doneFlag == 1 ? Colors.green : Colors.orange,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item.doneFlag == 1 ? Icons.check_circle : Icons.pending,
                  size: 14,
                  color: item.doneFlag == 1 ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 4),
                Text(
                  item.doneFlag == 1 ? l10n.done : l10n.authStatusPending,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color:
                        item.doneFlag == 1 ? Colors.green : Colors.orange,
                  ),
                ),
              ],
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
            color: _kGreen1.withValues(alpha: 0.08),
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
                color: _kGreen1.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.health_and_safety_outlined,
                size: 48,
                color: _kGreen1,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noTasksFound,
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
