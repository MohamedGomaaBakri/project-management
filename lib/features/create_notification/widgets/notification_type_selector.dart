import 'package:flutter/material.dart';
import 'package:shehabapp/l10n/app_localizations.dart';

class NotificationTypeSelector extends StatelessWidget {
  final int selectedType;
  final Function(int) onTypeChanged;

  const NotificationTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.notifications_active_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.notificationTypeLabel,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4F46E5),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildTypeCard(
                    context,
                    type: 1,
                    label: l10n.notificationTypeStop,
                    icon: Icons.stop_circle_outlined,
                    isSelected: selectedType == 1,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTypeCard(
                    context,
                    type: 2,
                    label: l10n.notificationTypeGeneral,
                    icon: Icons.info_outline,
                    isSelected: selectedType == 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeCard(
    BuildContext context, {
    required int type,
    required String label,
    required IconData icon,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onTypeChanged(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF4F46E5) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF4F46E5).withOpacity(0.3),
                    spreadRadius: 0,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[600],
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
