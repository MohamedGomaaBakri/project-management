import 'package:flutter/material.dart';

class FormActionButtonsWidget extends StatelessWidget {
  final VoidCallback onSavePressed;
  // final VoidCallback onAttachmentsPressed;
  final bool isLoading;

  const FormActionButtonsWidget({
    super.key,
    required this.onSavePressed,
    // required this.onAttachmentsPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            label: 'حفظ',
            icon: Icons.save,
            gradient: const LinearGradient(
              colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
            ),
            onPressed: isLoading ? null : onSavePressed,
            isLoading: isLoading,
          ),
        ),
        // const SizedBox(width: 12),
        // Expanded(
        //   child: _buildActionButton(
        //     label: 'المرفقات',
        //     icon: Icons.attach_file,
        //     gradient: const LinearGradient(
        //       colors: [Color(0xFF059669), Color(0xFF10B981)],
        //     ),
        //     onPressed: isLoading ? null : onAttachmentsPressed,
        //   ),
        // ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: onPressed != null ? gradient : null,
        color: onPressed == null ? Colors.grey[300] : null,
        boxShadow: onPressed != null
            ? [
                BoxShadow(
                  color: const Color(0xFF4F46E5).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: isLoading
                ? const Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : Row(
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
