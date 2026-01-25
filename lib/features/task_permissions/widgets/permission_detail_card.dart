import 'package:flutter/material.dart';
import 'package:shehabapp/l10n/app_localizations.dart';
import 'error_dialog.dart';

class PermissionDetailCard extends StatelessWidget {
  final String title;
  final List<DetailItem> items;

  const PermissionDetailCard({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: items.map((item) => _buildDetailRow(item)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(DetailItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              item.label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: item.isCheckbox
                ? _buildToggleSwitch(item)
                : Text(
                    item.value ?? '-',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleSwitch(DetailItem item) {
    final bool isEnabled = item.value == '1' || item.value == 'true';

    // Determine if switch can be changed:
    // - Can only change to true if attpermitcheck == 1 AND doneFlag == 0
    // - Cannot change from true to false (if already true, it's disabled)
    // - Cannot change to true if attpermitcheck == 0
    final bool canChangeToTrue = item.attpermitcheck == 1 && !isEnabled;
    final bool isSwitchEnabled =
        canChangeToTrue && item.onToggleChanged != null;

    return Builder(
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: !isSwitchEnabled && !isEnabled
              ? () {
                  // Show error dialog when switch is disabled
                  _showPermissionError(context, item);
                }
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Status text
              Text(
                isEnabled
                    ? AppLocalizations.of(context)!.enabled
                    : AppLocalizations.of(context)!.disabled,
                style: TextStyle(
                  fontSize: 14,
                  color: isEnabled
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 12),
              // Switch
              Transform.scale(
                scale: 0.8,
                alignment: Alignment.centerRight,
                child: Switch(
                  value: isEnabled,
                  onChanged: isSwitchEnabled
                      ? (bool newValue) {
                          // Only allow changing to true if attpermitcheck == 1
                          // Never allow changing from true to false
                          if (newValue && item.attpermitcheck == 1) {
                            item.onToggleChanged!(newValue);
                          }
                        }
                      : null,
                  activeColor: const Color(0xFF10B981),
                  activeTrackColor: const Color(0xFF10B981).withOpacity(0.5),
                  inactiveThumbColor: const Color(0xFFEF4444),
                  inactiveTrackColor: const Color(0xFFEF4444).withOpacity(0.5),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPermissionError(BuildContext context, DetailItem item) {
    final l10n = AppLocalizations.of(context)!;

    // Determine the error message based on attpermitcheck value
    String title;
    String message;
    IconData icon;

    if (item.attpermitcheck == 0) {
      title = l10n.permissionNotAllowedTitle;
      message = l10n.permissionNotAllowedMessage;
      icon = Icons.lock_outline;
    } else if (item.value == '1' || item.value == 'true') {
      title = l10n.permissionAlreadyEnabledTitle;
      message = l10n.permissionAlreadyEnabledMessage;
      icon = Icons.check_circle_outline;
    } else {
      title = l10n.permissionNotAvailableTitle;
      message = l10n.permissionNotAvailableMessage;
      icon = Icons.info_outline;
    }

    // Show the beautiful error dialog
    PermissionErrorDialog.show(
      context,
      title: title,
      message: message,
      icon: icon,
    );
  }
}

class DetailItem {
  final String label;
  final String? value;
  final bool isCheckbox;
  final int? attpermitcheck;
  final ValueChanged<bool>? onToggleChanged;

  DetailItem({
    required this.label,
    this.value,
    this.isCheckbox = false,
    this.attpermitcheck,
    this.onToggleChanged,
  });
}
