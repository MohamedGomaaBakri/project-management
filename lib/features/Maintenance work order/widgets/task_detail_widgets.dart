import 'package:flutter/material.dart';
import 'package:shehabapp/l10n/app_localizations.dart';

/// A styled section card used on the details screen.
/// Wraps children in a white card with a coloured accent on the leading edge.
class DetailSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accentColor;
  final List<Widget> children;

  const DetailSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.10),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.06),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: accentColor, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
              ],
            ),
          ),
          // Children
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}

/// A single read-only info row: label on top, value below.
class DetailInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? valueColor;

  const DetailInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[500],
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Value
          Text(
            value.isEmpty ? '—' : value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: valueColor ?? Colors.grey[800],
            ),
          ),
          const Divider(height: 18, thickness: 0.6),
        ],
      ),
    );
  }
}

/// Editable quantity + notes fields used when authFlag allows editing.
class EditableFieldsWidget extends StatelessWidget {
  final TextEditingController quantityController;
  final TextEditingController notesController;
  final bool isReadOnly;
  final AppLocalizations l10n;

  const EditableFieldsWidget({
    super.key,
    required this.quantityController,
    required this.notesController,
    required this.isReadOnly,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StyledField(
          controller: quantityController,
          label: l10n.detailQuantity,
          hint: l10n.quantityHint,
          icon: Icons.inventory_2_rounded,
          keyboardType: TextInputType.number,
          isReadOnly: isReadOnly,
        ),
        const SizedBox(height: 16),
        _StyledField(
          controller: notesController,
          label: l10n.detailNotes,
          hint: l10n.notesHintDetails,
          icon: Icons.notes_rounded,
          keyboardType: TextInputType.multiline,
          maxLines: 4,
          isReadOnly: isReadOnly,
        ),
      ],
    );
  }
}

class _StyledField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final int maxLines;
  final bool isReadOnly;

  const _StyledField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.keyboardType,
    this.maxLines = 1,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = const Color(0xFF4F46E5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.grey[500]),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[500],
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: isReadOnly,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(
            fontSize: 15,
            color: isReadOnly ? Colors.grey[500] : Colors.grey[800],
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            filled: true,
            fillColor: isReadOnly ? Colors.grey[100] : Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: activeColor, width: 1.5),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
          ),
        ),
      ],
    );
  }
}

/// Auth-status badge chip shown in the approval section.
class AuthStatusBadge extends StatelessWidget {
  final int? authFlag;
  final String statusText;

  const AuthStatusBadge({
    super.key,
    required this.authFlag,
    required this.statusText,
  });

  Color get _color {
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

  IconData get _icon {
    switch (authFlag) {
      case 0:
        return Icons.hourglass_top_rounded;
      case 1:
        return Icons.check_circle_rounded;
      case 2:
        return Icons.cancel_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 16, color: _color),
          const SizedBox(width: 8),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _color,
            ),
          ),
        ],
      ),
    );
  }
}
