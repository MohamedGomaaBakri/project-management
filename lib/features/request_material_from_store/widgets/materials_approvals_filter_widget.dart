import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shehabapp/core/models/material_projects_model.dart' as mp;
import 'package:shehabapp/features/request_material_from_store/widgets/materials_filter_widget.dart';
import 'package:shehabapp/l10n/app_localizations.dart';

class MaterialsApprovalsFilterWidget extends StatelessWidget {
  final DateTime? selectedDate;
  final AuthFilterStatus selectedAuth;
  final mp.Items? selectedProject;
  final List<mp.Items> projects;

  final ValueChanged<DateTime?> onDateChanged;
  final ValueChanged<AuthFilterStatus> onAuthChanged;
  final ValueChanged<mp.Items?> onProjectChanged;
  final VoidCallback onSearchPressed;
  final VoidCallback onResetPressed;

  const MaterialsApprovalsFilterWidget({
    super.key,
    required this.selectedDate,
    required this.selectedAuth,
    required this.selectedProject,
    required this.projects,
    required this.onDateChanged,
    required this.onAuthChanged,
    required this.onProjectChanged,
    required this.onSearchPressed,
    required this.onResetPressed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.filter_list_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.filterBy,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4F46E5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Date Picker
          _DateField(
            l10n: l10n,
            selectedDate: selectedDate,
            onDateChanged: onDateChanged,
          ),
          const SizedBox(height: 16),

          // Project Dropdown
          _ProjectDropdownField(
            l10n: l10n,
            selectedProject: selectedProject,
            projects: projects,
            isArabic: isArabic,
            onProjectChanged: onProjectChanged,
          ),
          const SizedBox(height: 16),

          // Auth Radio Group
          _AuthRadioGroup(
            l10n: l10n,
            selectedAuth: selectedAuth,
            onChanged: onAuthChanged,
          ),
          const SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: _SearchBtn(l10n: l10n, onPressed: onSearchPressed),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: onResetPressed,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      side: const BorderSide(color: Colors.redAccent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.refresh),
                    label: Text(
                      l10n.reset,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final AppLocalizations l10n;
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onDateChanged;

  const _DateField({
    required this.l10n,
    required this.selectedDate,
    required this.onDateChanged,
  });

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF4F46E5),
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) onDateChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final formatted = selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(selectedDate!)
        : null;

    return GestureDetector(
      onTap: () => _pickDate(context),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: selectedDate != null
                ? const Color(0xFF4F46E5)
                : Colors.grey.shade300,
            width: selectedDate != null ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: selectedDate != null
              ? const Color(0xFF4F46E5).withOpacity(0.04)
              : Colors.grey.shade50,
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 20,
              color: selectedDate != null
                  ? const Color(0xFF4F46E5)
                  : Colors.grey.shade500,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                formatted ?? l10n.filterDateHint,
                style: TextStyle(
                  fontSize: 15,
                  color: formatted != null
                      ? const Color(0xFF1F2937)
                      : Colors.grey.shade500,
                  fontWeight: formatted != null
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ),
            if (selectedDate != null)
              GestureDetector(
                onTap: () => onDateChanged(null),
                child: const Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: Color(0xFF4F46E5),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProjectDropdownField extends StatelessWidget {
  final AppLocalizations l10n;
  final mp.Items? selectedProject;
  final List<mp.Items> projects;
  final bool isArabic;
  final ValueChanged<mp.Items?> onProjectChanged;

  const _ProjectDropdownField({
    required this.l10n,
    required this.selectedProject,
    required this.projects,
    required this.isArabic,
    required this.onProjectChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasSelection = selectedProject != null;

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: hasSelection ? const Color(0xFF4F46E5) : Colors.grey.shade300,
          width: hasSelection ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: hasSelection
            ? const Color(0xFF4F46E5).withOpacity(0.04)
            : Colors.grey.shade50,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<mp.Items>(
          value: selectedProject,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: hasSelection
                ? const Color(0xFF4F46E5)
                : Colors.grey.shade500,
          ),
          hint: Row(
            children: [
              Icon(Icons.business_center_rounded, size: 20, color: Colors.grey.shade500),
              const SizedBox(width: 12),
              Text(
                isArabic ? 'المشروع' : 'Project',
                style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
              ),
            ],
          ),
          onChanged: onProjectChanged,
          items: projects.map((project) {
            final name = isArabic
                ? (project.nameA ?? '')
                : (project.nameE ?? project.nameA ?? '');
            final display = '${project.contractNo ?? ''} - $name';
            return DropdownMenuItem<mp.Items>(
              value: project,
              child: Row(
                children: [
                  const Icon(
                    Icons.business_center_rounded,
                    size: 18,
                    color: Color(0xFF4F46E5),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      display,
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          selectedItemBuilder: (context) => projects.map((project) {
            return Row(
              children: [
                const Icon(
                  Icons.business_center_rounded,
                  size: 20,
                  color: Color(0xFF4F46E5),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    project.contractNo ?? '',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _AuthRadioGroup extends StatelessWidget {
  final AppLocalizations l10n;
  final AuthFilterStatus selectedAuth;
  final ValueChanged<AuthFilterStatus> onChanged;

  const _AuthRadioGroup({
    required this.l10n,
    required this.selectedAuth,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: const Color(0xFF4F46E5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              l10n.filterApprovalStatus,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF374151),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            _AuthRadioChip(
              label: l10n.filterAll,
              value: AuthFilterStatus.all,
              groupValue: selectedAuth,
              onChanged: onChanged,
              activeColor: const Color(0xFF4F46E5),
            ),
            _AuthRadioChip(
              label: l10n.filterApproved,
              value: AuthFilterStatus.approved,
              groupValue: selectedAuth,
              onChanged: onChanged,
              activeColor: Colors.green,
            ),
            _AuthRadioChip(
              label: l10n.filterNotApproved,
              value: AuthFilterStatus.notApproved,
              groupValue: selectedAuth,
              onChanged: onChanged,
              activeColor: Colors.orange,
            ),
            _AuthRadioChip(
              label: l10n.filterRejected,
              value: AuthFilterStatus.rejected,
              groupValue: selectedAuth,
              onChanged: onChanged,
              activeColor: Colors.red,
            ),
          ],
        ),
      ],
    );
  }
}

class _AuthRadioChip extends StatelessWidget {
  final String label;
  final AuthFilterStatus value;
  final AuthFilterStatus groupValue;
  final ValueChanged<AuthFilterStatus> onChanged;
  final Color activeColor;

  const _AuthRadioChip({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.12) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? activeColor : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? activeColor : Colors.grey.shade400,
                  width: isSelected ? 4 : 1.5,
                ),
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 6),
            Text(
               label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? activeColor : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBtn extends StatefulWidget {
  final AppLocalizations l10n;
  final VoidCallback onPressed;

  const _SearchBtn({required this.l10n, required this.onPressed});

  @override
  State<_SearchBtn> createState() => _SearchBtnState();
}

class _SearchBtnState extends State<_SearchBtn> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        Future.delayed(const Duration(milliseconds: 100), widget.onPressed);
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(_isPressed ? 0.97 : 1.0),
        height: 50,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: const Color(0xFF4F46E5).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search, color: Colors.white, size: 22),
            const SizedBox(width: 8),
            Text(
              widget.l10n.search,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
