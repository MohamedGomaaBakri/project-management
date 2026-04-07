import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../l10n/app_localizations.dart';

class NotesInputWidget extends StatelessWidget {
  final TextEditingController notesController;
  final TextEditingController replyController;
  final bool isReplyReadOnly;
  final TextEditingController? procQtyController;

  const NotesInputWidget({
    super.key,
    required this.notesController,
    required this.replyController,
    this.isReplyReadOnly = false,
    this.procQtyController,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              context,
              controller: notesController,
              label: l10n.notesField,
              hint: l10n.notesHint,
              icon: Icons.note_alt_outlined,
              gradientColors: [
                const Color(0xFF10B981),
                const Color(0xFF059669),
              ],
            ),
            const SizedBox(height: 20),
            _buildTextField(
              context,
              controller: replyController,
              label: l10n.notificationReply,
              hint: l10n.notificationReplyHint,
              icon: Icons.reply_rounded,
              isReadOnly: isReplyReadOnly,
              gradientColors: [
                const Color(0xFF3B82F6),
                const Color(0xFF2563EB),
              ],
            ),
            if (procQtyController != null) ...[
              const SizedBox(height: 20),
              _buildTextField(
                context,
                controller: procQtyController!,
                label: l10n.quantity,
                hint: l10n.enterQuantity,
                icon: Icons.pin_outlined,
                keyboardType: TextInputType.number,
                maxLines: 1,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                gradientColors: [
                  const Color(0xFFF59E0B),
                  const Color(0xFFD97706),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required List<Color> gradientColors,
    bool isReadOnly = false,
    TextInputType keyboardType = TextInputType.multiline,
    int maxLines = 3,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: gradientColors[0].withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF4F46E5).withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: controller,
            enabled: !isReadOnly,
            maxLines: maxLines,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            style: TextStyle(
              fontSize: 14,
              color: isReadOnly ? Colors.grey[600] : Colors.grey[800],
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }
}
