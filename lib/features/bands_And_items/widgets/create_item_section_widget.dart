import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shehabapp/core/models/items_model/item.dart';
import 'package:shehabapp/l10n/app_localizations.dart';

class CreateItemSectionWidget extends StatelessWidget {
  final List<Item> items;
  final bool isArabic;
  final Item? selectedItem;
  final TextEditingController executedQtyController;
  final ValueChanged<Item?> onItemChanged;

  final bool isEnabled;

  const CreateItemSectionWidget({
    super.key,
    required this.items,
    required this.isArabic,
    required this.selectedItem,
    required this.executedQtyController,
    required this.onItemChanged,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final item = selectedItem;
    final restQty = item?.restQty;
    final unitName = item != null
        ? (isArabic
            ? (item.unitNameA ?? '')
            : (item.unitNameE ?? item.unitNameA ?? ''))
        : '—';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Item Dropdown ─────────────────────────────────────
        _FieldLabel(label: l10n.selectItem, required: true),
        const SizedBox(height: 6),
        Container(
          decoration: _inputDecoration(
            hasFocus: item != null,
            focusColor: const Color(0xFFF97316),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Item>(
              value: item,
              isExpanded: true,
              hint: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  l10n.selectItem,
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
              ),
              icon: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(Icons.arrow_drop_down_rounded,
                    color: Colors.grey[400]),
              ),
              borderRadius: BorderRadius.circular(14),
              items: items.map((it) {
                final name = isArabic
                    ? (it.itemNameA ?? '')
                    : (it.itemNameE?.toString() ?? it.itemNameA ?? '');
                return DropdownMenuItem<Item>(
                  value: it,
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
              onChanged: onItemChanged,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ── Unit (auto-filled) ────────────────────────────────
        _FieldLabel(label: l10n.unitLabel, required: false),
        const SizedBox(height: 6),
        _AutoFilledField(
          value: unitName,
          icon: Icons.straighten_rounded,
          color: const Color(0xFFF97316),
          autofilledLabel: l10n.autofilled,
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
          controller: executedQtyController,
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
              color: Color(0xFFF97316),
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
              borderSide:
                  const BorderSide(color: Color(0xFFF97316), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: Color(0xFFEF4444), width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: Color(0xFFEF4444), width: 1.5),
            ),
          ),
          validator: (value) {
            if (!isEnabled) return null;
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
        color: hasFocus
            ? focusColor.withValues(alpha: 0.6)
            : Colors.grey.shade200,
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
