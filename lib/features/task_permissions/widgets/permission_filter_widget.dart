import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

enum PermissionStatus { all, active, expired }

class PermissionFilterWidget extends StatelessWidget {
  final PermissionStatus selectedStatus;
  final ValueChanged<PermissionStatus> onStatusChanged;
  final VoidCallback onSearchPressed;
  final VoidCallback onResetPressed;

  const PermissionFilterWidget({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.onSearchPressed,
    required this.onResetPressed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.filter_list,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.filterBy,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4F46E5),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Status Filter
          Text(
            l10n.permissionStatus,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),

          // Radio Buttons
          Row(
            children: [
              _buildRadioOption(context, l10n.allStatus, PermissionStatus.all),
              _buildRadioOption(
                context,
                l10n.activeStatus,
                PermissionStatus.active,
              ),
              _buildRadioOption(
                context,
                l10n.expiredStatus,
                PermissionStatus.expired,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: onSearchPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.search),
                    label: Text(
                      l10n.search,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: onResetPressed,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      side: const BorderSide(color: Colors.redAccent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.refresh),
                    label: Text(
                      l10n.reset,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(
    BuildContext context,
    String label,
    PermissionStatus value,
  ) {
    return InkWell(
      onTap: () => onStatusChanged(value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            Radio<PermissionStatus>(
              value: value,
              groupValue: selectedStatus,
              onChanged: (PermissionStatus? newValue) {
                if (newValue != null) {
                  onStatusChanged(newValue);
                }
              },
              activeColor: const Color(0xFF4F46E5),
            ),
            // const SizedBox(width: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                fontWeight: selectedStatus == value
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
