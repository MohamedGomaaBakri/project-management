import 'package:flutter/material.dart';
import 'package:shehabapp/core/models/materials_model.dart';
import 'package:shehabapp/l10n/app_localizations.dart';
import 'package:shehabapp/features/request_material_from_store/views/one_dibursement_request_details_view.dart';
/// Data table that displays the material-request items.
///
/// Column mapping:
///   م        → [Items.serial]
///   الصنف    → [Items.itemNameA] / [Items.itemNameE]  (locale-aware)
///   الكمية   → [Items.quantity]
///   الحالة   → [Items.statusNameA] / [Items.statusNameE] (locale-aware)
///   الاعتماد → [Items.authNameA] / [Items.authNameE] (locale-aware)
///
/// Row background colours (authFlag):
///   0 → light yellow (غير معتمد)
///   1 → light green  (معتمد)
///   2 → light red    (مرفوض)
class MaterialsDataTableWidget extends StatelessWidget {
  final List<Items> items;
  final void Function(Items)? onRowTapped;

  const MaterialsDataTableWidget({
    super.key,
    required this.items,
    this.onRowTapped,
  });

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
                _col(l10n.item, Icons.layers_rounded),
                _col(l10n.colQuantity, Icons.inventory_2_rounded),
                _col(l10n.status, Icons.info_outline_rounded),
                _col(l10n.authStatus, Icons.verified_rounded),
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
    final itemName = isArabic ? (item.itemNameA ?? '') : (item.itemNameE ?? '');
    final statusName = isArabic
        ? (item.statusNameA ?? '')
        : (item.statusNameE ?? '');
    final authName = isArabic
        ? (item.authNameA ?? '')
        : (item.authNameE ?? '');

    // Row background based on authFlag
    final rowColor = _rowColor(item.authFlag);
    // Status badge colour
    final authBadgeColor = _badgeColor(item.authFlag);
    final statusBadgeColor = _statusBadgeColor(item.statusFlag);

    return DataRow(
      color: WidgetStateProperty.all(rowColor),
      onSelectChanged: (_) {
        if (onRowTapped != null) {
          onRowTapped!(item);
        } else {
          Navigator.pushNamed(
            context,
            OneDibursementRequestDetailsView.routeName,
            arguments: item,
          );
        }
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

        // الصنف — item name
        DataCell(
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 180),
            child: Text(
              itemName,
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

        // الحالة — status badge
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusBadgeColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: statusBadgeColor.withOpacity(0.5)),
            ),
            child: Text(
              statusName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: statusBadgeColor,
              ),
            ),
          ),
        ),

        // الاعتماد — auth status badge
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: authBadgeColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: authBadgeColor.withOpacity(0.5)),
            ),
            child: Text(
              authName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: authBadgeColor,
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
  
  Color _statusBadgeColor(int? statusFlag) {
    switch (statusFlag) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.green;
      case 2:
        return Colors.red;
      default:
        return Colors.blue;
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
