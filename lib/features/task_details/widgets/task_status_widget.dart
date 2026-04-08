import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../bands_And_items/views/band_and_items_view.dart';
import 'error_dialog.dart';

class TaskStatusWidget extends StatefulWidget {
  final int? doneFlag;
  final String? doneDate;
  final VoidCallback onExecute;
  final int? attFlagCheck;
  final int? attPermitCheck;
  final int? attNotifCheck;
  final int? attBandCheck;
  final TextEditingController? notesController;
  final String? selectedEmployeeCode;
  final String? defaultEmployeeCode;
  final Function(int doneFlag, String doneDate)? onStatusUpdated;
  final VoidCallback? onItemsAndCategoriesTap;

  const TaskStatusWidget({
    super.key,
    this.doneFlag,
    this.doneDate,
    required this.onExecute,
    this.attFlagCheck,
    this.attPermitCheck,
    this.attNotifCheck,
    this.attBandCheck,
    this.notesController,
    this.selectedEmployeeCode,
    this.defaultEmployeeCode,
    this.onStatusUpdated,
    this.onItemsAndCategoriesTap,
  });

  @override
  State<TaskStatusWidget> createState() => _TaskStatusWidgetState();
}

class _TaskStatusWidgetState extends State<TaskStatusWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late int _currentDoneFlag;
  late String _currentDoneDate;

  @override
  void initState() {
    super.initState();
    _currentDoneFlag = widget.doneFlag ?? 0;
    _currentDoneDate = widget.doneDate ?? '';
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDate(String date) {
    if (date.isEmpty) return '--/--/----';

    try {
      // Try to parse as DateTime first (handles formats like "2026-01-28 13:12:48" or "2026-01-28")
      DateTime parsedDate;

      // Check if date contains time component
      if (date.contains(' ')) {
        // Format: "YYYY-MM-DD HH:MM:SS"
        parsedDate = DateTime.parse(date);
      } else if (date.contains('-')) {
        // Format: "YYYY-MM-DD"
        parsedDate = DateTime.parse(date);
      } else if (date.contains('/')) {
        // Already formatted as DD/MM/YYYY, return as is
        return date;
      } else {
        return date;
      }

      // Format as DD/MM/YYYY
      final day = parsedDate.day.toString().padLeft(2, '0');
      final month = parsedDate.month.toString().padLeft(2, '0');
      final year = parsedDate.year.toString();

      return '$day/$month/$year';
    } catch (e) {
      // If parsing fails, try manual split
      try {
        final parts = date.split('-');
        if (parts.length >= 3) {
          final year = parts[0];
          final month = parts[1];
          final day = parts[2].split(' ')[0]; // Remove time if exists
          return '$day/$month/$year';
        }
      } catch (_) {}

      return date;
    }
  }

  Future<void> _handleExecuteValidation() async {
    final l10n = AppLocalizations.of(context)!;

    // Check attFlagCheck (attachments)
    if (widget.attFlagCheck == 0) {
      await ErrorDialog.show(context, l10n.errorAttachmentsRequired);
      return;
    }

    // Check attPermitCheck (permissions)
    if (widget.attPermitCheck == 0) {
      await ErrorDialog.show(context, l10n.errorPermissionsRequired);
      return;
    }

    // Check attNotifCheck (notification reply)
    if (widget.attNotifCheck == 0) {
      await ErrorDialog.show(context, l10n.errorNotificationReplyRequired);
      return;
    }

    // Check attBandCheck (band)
    if (widget.attBandCheck == 0) {
      await ErrorDialog.show(context, l10n.errorBandRequired);
      return;
    }

    // Check notes (remarks)
    final notesText = widget.notesController?.text ?? '';
    if (notesText.trim().isEmpty) {
      await ErrorDialog.show(context, l10n.errorNotesRequired);
      return;
    }

    // Check assigned employee
    // إذا كان هناك موظف افتراضي من API، مش لازم المستخدم يختار
    // إذا مفيش موظف افتراضي، لازم المستخدم يختار
    final hasDefaultEmployee =
        widget.defaultEmployeeCode != null &&
        widget.defaultEmployeeCode!.isNotEmpty;
    final hasSelectedEmployee =
        widget.selectedEmployeeCode != null &&
        widget.selectedEmployeeCode!.isNotEmpty;

    if (!hasDefaultEmployee && !hasSelectedEmployee) {
      await ErrorDialog.show(context, l10n.errorEmployeeRequired);
      return;
    }

    // All validations passed - update status
    final now = DateTime.now();
    final formattedDate =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    setState(() {
      _currentDoneFlag = 1;
      _currentDoneDate = formattedDate;
    });

    // Notify parent widget about status update
    if (widget.onStatusUpdated != null) {
      widget.onStatusUpdated!(1, formattedDate);
    }

    // Call original onExecute
    widget.onExecute();
  }

  void _handleItemsAndCategoriesTap() {
    if (widget.onItemsAndCategoriesTap != null) {
      widget.onItemsAndCategoriesTap!();
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const BandAndItemsView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final itemsAndCategoriesText = isArabic
        ? 'البنود والأصناف'
        : 'Items & Categories';
    final isCompleted = _currentDoneFlag == 1;

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
        child: Row(
          children: [
            // Execute + Items/Categories Buttons
            Expanded(
              child: Column(
                children: [
                  GestureDetector(
                    onTapDown: (_) {
                      _controller.forward();
                    },
                    onTapUp: (_) {
                      _controller.reverse();
                      _handleExecuteValidation();
                    },
                    onTapCancel: () {
                      _controller.reverse();
                    },
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4F46E5).withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.play_circle_outline_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.executeButton,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _handleItemsAndCategoriesTap,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFF97316), Color(0xFFEC4899)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFF97316).withOpacity(0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.inventory_2_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                itemsAndCategoriesText,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                                // maxLines: 1,
                                // overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // Status Checkbox
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isCompleted
                    ? const Color(0xFF10B981).withOpacity(0.1)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isCompleted
                      ? const Color(0xFF10B981)
                      : Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    isCompleted
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: isCompleted
                        ? const Color(0xFF10B981)
                        : Colors.grey[400],
                    size: 28,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isCompleted ? l10n.taskCompleted : l10n.taskNotCompleted,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isCompleted
                          ? const Color(0xFF10B981)
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // Date Display
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF3B82F6).withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    color: Color(0xFF3B82F6),
                    size: 24,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDate(_currentDoneDate),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3B82F6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
