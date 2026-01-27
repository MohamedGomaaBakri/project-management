import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/task_permission_model.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../permission_details_view.dart';

class PermissionDataTableWidget extends StatelessWidget {
  final List<Permission> permissions;
  final VoidCallback? onDataChanged;

  const PermissionDataTableWidget({
    super.key,
    required this.permissions,
    this.onDataChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;

    if (permissions.isEmpty) {
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
                _buildDataColumn(l10n.permissionType, Icons.category),
                _buildDataColumn(l10n.fromDate, Icons.calendar_today),
                _buildDataColumn(l10n.toDate, Icons.event),
                _buildDataColumn(l10n.permissionNumber, Icons.numbers),
                _buildDataColumn(l10n.done, Icons.check_circle),
              ],
              rows: permissions.asMap().entries.map((entry) {
                final index = entry.key;
                final permission = entry.value;
                return _buildDataRow(context, permission, index, onDataChanged);
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
    Permission permission,
    int index,
    VoidCallback? onDataChanged,
  ) {
    final isArabic =
        Provider.of<LocaleProvider>(
          context,
          listen: false,
        ).locale.languageCode ==
        'ar';

    return DataRow(
      onSelectChanged: (_) async {
        // Navigate to permission details and wait for result
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PermissionDetailsView(permission: permission),
          ),
        );

        // If result is true, reload data
        if (result == true && onDataChanged != null) {
          onDataChanged();
        }
      },
      color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        // If permission is done (doneFlag = 1) → light green
        if (permission.doneFlag == 1) {
          return Colors.green[50];
        }
        // If permission is not done (doneFlag = 0) → light red
        if (permission.doneFlag == 0) {
          return Colors.red[50];
        }
        // Default
        return Colors.grey[50];
      }),
      cells: [
        DataCell(
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 150),
              child: Text(
                isArabic
                    ? (permission.typeNameA ?? '-')
                    : (permission.typeNameE ?? permission.typeNameA ?? '-'),
                style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  _formatDate(permission.startDate),
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ),
        DataCell(
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  _formatDate(permission.endDate),
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              permission.permitNo ?? '-',
              style: TextStyle(fontSize: 13, color: Colors.grey[800]),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataCell(
          Center(
            child: Checkbox(
              value: permission.doneFlag == 1,
              onChanged: null, // Read-only checkbox
              activeColor: const Color(0xFF4F46E5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return '-';

    // If date contains 'T', split and take the date part only
    if (date.contains('T')) {
      return date.split('T')[0];
    }

    return date;
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
              l10n.noPermissionsFound,
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
