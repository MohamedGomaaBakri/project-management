import 'package:flutter/material.dart';

class PermissionActionButtons extends StatelessWidget {
  final VoidCallback onRenewPressed;
  final VoidCallback onAttachmentsPressed;

  const PermissionActionButtons({
    super.key,
    required this.onRenewPressed,
    required this.onAttachmentsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Expanded(
        //   child: _buildActionButton(
        //     label: 'تجديد',
        //     icon: Icons.refresh,
        //     gradient: const LinearGradient(
        //       colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
        //     ),
        //     onPressed: onRenewPressed,
        //   ),
        // ),
        // const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            label: 'المرفقات',
            icon: Icons.attach_file,
            gradient: const LinearGradient(
              colors: [Color(0xFF059669), Color(0xFF10B981)],
            ),
            onPressed: onAttachmentsPressed,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: gradient,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
