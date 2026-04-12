import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shehabapp/core/models/bands_model/item.dart';
import 'package:shehabapp/l10n/app_localizations.dart';

class CreateBandSectionWidget extends StatefulWidget {
  final List<Band> bands;
  final bool isArabic;
  final Band? selectedBand;
  final DateTime? selectedDate;
  final TextEditingController executedQtyController;
  final ValueChanged<Band?> onBandChanged;

  final bool isEnabled;

  const CreateBandSectionWidget({
    super.key,
    required this.bands,
    required this.isArabic,
    required this.selectedBand,
    required this.selectedDate,
    required this.executedQtyController,
    required this.onBandChanged,
    required this.isEnabled,
  });

  @override
  State<CreateBandSectionWidget> createState() =>
      _CreateBandSectionWidgetState();
}

class _CreateBandSectionWidgetState extends State<CreateBandSectionWidget> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final band = widget.selectedBand;
    final restQty = band?.restQty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Band Dropdown ─────────────────────────────────────
        _FieldLabel(label: l10n.selectBand, required: true),
        const SizedBox(height: 6),
        Container(
          decoration: _inputDecoration(
            hasFocus: band != null,
            focusColor: const Color(0xFF4F46E5),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Band>(
              value: band,
              isExpanded: true,
              hint: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  l10n.selectBand,
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
              ),
              icon: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(Icons.arrow_drop_down_rounded,
                    color: Colors.grey[400]),
              ),
              borderRadius: BorderRadius.circular(14),
              items: widget.bands.map((b) {
                final name = widget.isArabic
                    ? (b.bandName ?? '')
                    : (b.bandNameE ?? b.bandName ?? '');
                return DropdownMenuItem<Band>(
                  value: b,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1E293B),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList(),
              onChanged: widget.onBandChanged,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ── Remaining Qty (auto-filled) ────────────────────────
        _FieldLabel(label: l10n.remainingQtyLabel, required: false),
        const SizedBox(height: 6),
        _AutoFilledField(
          value: restQty != null ? restQty.toString() : '—',
          icon: Icons.inventory_2_outlined,
          color: const Color(0xFF10B981),
          autofilledLabel: l10n.autofilled,
        ),
        const SizedBox(height: 16),

        // ── Executed Qty ──────────────────────────────────────
        _FieldLabel(label: l10n.executedQty, required: true),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.executedQtyController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: l10n.executedQtyHint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            filled: true,
            fillColor: Colors.grey[50],
            prefixIcon: const Icon(
              Icons.production_quantity_limits_rounded,
              color: Color(0xFF4F46E5),
              size: 20,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
            ),
          ),
          validator: (value) {
            if (!widget.isEnabled) return null;
            if (value == null || value.trim().isEmpty) {
              return l10n.executedQtyValidation;
            }
            final qty = double.tryParse(value.trim());
            if (qty == null || qty <= 0) {
              return l10n.executedQtyMustBePositive;
            }
            if (restQty != null && qty > restQty) {
              return l10n.executedQtyExceedsRemaining;
            }
            return null;
          },
        ),
      ],
    );
  }

  BoxDecoration _inputDecoration({
    required bool hasFocus,
    required Color focusColor,
  }) {
    return BoxDecoration(
      color: Colors.grey[50],
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: hasFocus ? focusColor.withValues(alpha: 0.6) : Colors.grey.shade200,
        width: hasFocus ? 1.5 : 1.0,
      ),
    );
  }
}

// ─────────────────────────────────── helpers ───────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String label;
  final bool required;
  const _FieldLabel({required this.label, required this.required});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF475569),
        ),
        children: required
            ? const [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Color(0xFFEF4444)),
                ),
              ]
            : [],
      ),
    );
  }
}

class _AutoFilledField extends StatelessWidget {
  final String value;
  final IconData icon;
  final Color color;
  final String autofilledLabel;

  const _AutoFilledField({
    required this.value,
    required this.icon,
    required this.color,
    required this.autofilledLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              autofilledLabel,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
