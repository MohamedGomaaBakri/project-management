import 'package:flutter/material.dart';
import 'package:shehabapp/core/models/task_and_approvals_model.dart';
import 'package:shehabapp/features/request_material_from_store/views/one_task_details_view.dart';
import 'package:shehabapp/l10n/app_localizations.dart';

/// Data table that displays the material-request items.
///
/// Column mapping:
///   م        → [Items.serial]
///   البند    → [Items.bandNameA] / [Items.bandNameE]  (locale-aware)
///   الكمية   → [Items.quantity]
///   الفرقة   → [Items.teamsNameA] / [Items.teamsNameE] (locale-aware)
///   الحالة   → [Items.authStatusA] / [Items.authStatusE] (locale-aware)
///
/// Row background colours (authFlag):
///   0 → light yellow (غير معتمد)
///   1 → light green  (معتمد)
///   2 → light red    (مرفوض)
class TasksDataTableWidget extends StatelessWidget {
  final List<Items> items;

  const TasksDataTableWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (items.isEmpty) {
      return _EmptyState(l10n: l10n);
    }

    final size = MediaQuery.of(context).size;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

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
              columnSpacing: 20,
              horizontalMargin: 16,
              headingRowColor: WidgetStateProperty.all(
                const Color(0xFF4F46E5).withOpacity(0.06),
              ),
              columns: [
                _col(l10n.colSerial, Icons.tag),
                _col(l10n.colBand, Icons.layers_rounded),
                _col(l10n.colQuantity, Icons.inventory_2_rounded),
                _col(l10n.colTeam, Icons.groups_rounded),
                _col(l10n.colStatus, Icons.verified_rounded),
              ],
              rows: items.asMap().entries.map((entry) {
                return _buildRow(
                  context,
                  entry.value,
                  isArabic: isArabic,
                  l10n: l10n,
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  // ── Column builder ──────────────────────────────────────────────────────

  DataColumn _col(String label, IconData icon) {
    return DataColumn(
      label: Row(
        children: [
          Icon(icon, size: 17, color: const Color(0xFF4F46E5)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Color(0xFF4F46E5),
            ),
          ),
        ],
      ),
    );
  }

  // ── Row builder ─────────────────────────────────────────────────────────

  DataRow _buildRow(
    BuildContext context,
    Items item, {
    required bool isArabic,
    required AppLocalizations l10n,
  }) {
    final bandName = isArabic
        ? (item.bandNameA ?? '')
        : (item.bandNameE ?? '');
    final teamName = isArabic
        ? (item.teamsNameA ?? '')
        : (item.teamsNameE ?? '');
    final statusName = isArabic
        ? (item.authStatusA ?? '')
        : (item.authStatusE ?? '');

    // Row background based on authFlag
    final rowColor = _rowColor(item.authFlag);
    // Status badge colour
    final badgeColor = _badgeColor(item.authFlag);

    return DataRow(
      color: WidgetStateProperty.all(rowColor),
      onSelectChanged: (_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OneTaskDetailsView(initialItem: item),
          ),
        );
      },
      cells: [
        // م — serial
        DataCell(
          Text(
            item.serial?.toString() ?? '-',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
        ),

        // البند — band name
        DataCell(
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 180),
            child: Text(
              bandName,
              style: TextStyle(fontSize: 13, color: Colors.grey[800]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),

        // الكمية — quantity
        DataCell(
          Text(
            item.quantity?.toString() ?? '-',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
        ),

        // الفرقة — team name
        DataCell(
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 160),
            child: Text(
              teamName,
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),

        // الحالة — auth status badge
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: badgeColor.withOpacity(0.5)),
            ),
            child: Text(
              statusName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: badgeColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────

  Color _rowColor(int? authFlag) {
    switch (authFlag) {
      case 0:
        return Colors.amber.shade50;
      case 1:
        return Colors.green.shade50;
      case 2:
        return Colors.red.shade50;
      default:
        return Colors.white;
    }
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

// ── Empty state ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final AppLocalizations l10n;
  const _EmptyState({required this.l10n});

  @override
  Widget build(BuildContext context) {
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
              l10n.noRecordsFound,
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
