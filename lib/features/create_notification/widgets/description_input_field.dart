import 'package:flutter/material.dart';
import 'package:shehabapp/l10n/app_localizations.dart';

class DescriptionInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;

  const DescriptionInputField({
    super.key,
    required this.controller,
    this.errorText,
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
                    Icons.description_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.notificationDescription,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4F46E5),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: errorText != null
                    ? Colors.red[300]!
                    : controller.text.isNotEmpty
                    ? const Color(0xFF4F46E5)
                    : Colors.grey[300]!,
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: controller,
                  maxLines: 5,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: l10n.enterDescription,
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(12),
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (errorText != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red[600],
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            errorText!,
                            style: TextStyle(
                              color: Colors.red[600],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
