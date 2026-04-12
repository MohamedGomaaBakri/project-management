import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shehabapp/core/models/band_and_items_model/item.dart';
import 'package:shehabapp/features/bands_And_items/widgets/band_section_widget.dart';
import 'package:shehabapp/features/bands_And_items/widgets/item_section_widget.dart';

class BandAndItemCard extends StatelessWidget {
  const BandAndItemCard({
    super.key,
    required this.data,
    required this.isArabic,
  });

  final BandAndItem data;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final bandName = _localizedText(
      isArabicText: data.bandNameA,
      englishText: data.bandNameE,
    );
    final itemName = _localizedText(
      isArabicText: data.itemNameA,
      englishText: data.itemNameE?.toString(),
    );
    final unitName = _localizedText(
      isArabicText: data.unitNameA,
      englishText: data.unitNameE,
    );
    final formattedTransactionDate = _formatDate(data.trnsDate);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF4F46E5).withValues(alpha: 0.10),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withValues(alpha: 0.10),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _TypeBadge(
                  icon: Icons.category_rounded,
                  label: isArabic ? 'بند' : 'Band',
                  gradient: const [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                ),
                const SizedBox(width: 8),
                _TypeBadge(
                  icon: Icons.inventory_2_rounded,
                  label: isArabic ? 'صنف' : 'Item',
                  gradient: const [Color(0xFF10B981), Color(0xFF06B6D4)],
                ),
                const Spacer(),
                if (data.serial != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F46E5).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF4F46E5).withValues(alpha: 0.1),
                      ),
                    ),
                    child: Text(
                      '#${data.serial}',
                      style: const TextStyle(
                        color: Color(0xFF4F46E5),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFEEF2FF),
                    border: Border.all(
                      color: const Color(0xFF4F46E5).withValues(alpha: 0.14),
                    ),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    size: 18,
                    color: Color(0xFF4F46E5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            BandSectionWidget(
              bandName: bandName.isEmpty ? '-' : bandName,
              bandSerial: data.bandSerial,
              transactionDate: formattedTransactionDate,
              bandQty: data.bandQty,
              bandRestQty: data.bandRestQty,
            ),
            const SizedBox(height: 14),
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    const Color(0xFF4F46E5).withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            ItemSectionWidget(
              itemName: itemName.isEmpty ? '-' : itemName,
              itemSerial: data.itemSerial,
              unitName: unitName,
              itemQty: data.itemQty,
              itemRestQty: data.itemRestQty,
            ),
          ],
        ),
      ),
    );
  }

  String _localizedText({
    required String? isArabicText,
    required String? englishText,
  }) {
    final ar = isArabicText?.trim() ?? '';
    final en = englishText?.trim() ?? '';

    if (isArabic) {
      if (ar.isNotEmpty) return ar;
      if (en.isNotEmpty) return en;
      return '';
    }

    if (en.isNotEmpty) return en;
    if (ar.isNotEmpty) return ar;
    return '';
  }

  String? _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.trim().isEmpty) return rawDate;
    final parsed = DateTime.tryParse(rawDate);
    if (parsed == null) return rawDate;
    return DateFormat('dd MMM yyyy').format(parsed);
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({
    required this.icon,
    required this.label,
    required this.gradient,
  });

  final IconData icon;
  final String label;
  final List<Color> gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
