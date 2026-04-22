import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shehabapp/core/models/teams_model.dart' as teams_model;
import 'package:shehabapp/features/request_material_from_store/widgets/tasks_filter_widget.dart';
import 'package:shehabapp/l10n/app_localizations.dart';

/// Filter card used in [ApprovalsView].
///
/// Differences from [TasksFilterWidget]:
///   - No team dropdown in [TasksFilterWidget] — this one adds a team picker.
///   - The team list is supplied as [teams] from the provider.
class ApprovalsFilterWidget extends StatelessWidget {
  final DateTime? selectedDate;
  final AuthFilterStatus selectedAuth;
  final teams_model.Items? selectedTeam;
  final List<teams_model.Items> teams;

  final ValueChanged<DateTime?> onDateChanged;
  final ValueChanged<AuthFilterStatus> onAuthChanged;
  final ValueChanged<teams_model.Items?> onTeamChanged;
  final VoidCallback onSearchPressed;
  final VoidCallback onResetPressed;

  const ApprovalsFilterWidget({
    super.key,
    required this.selectedDate,
    required this.selectedAuth,
    required this.selectedTeam,
    required this.teams,
    required this.onDateChanged,
    required this.onAuthChanged,
    required this.onTeamChanged,
    required this.onSearchPressed,
    required this.onResetPressed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ───────────────────────────────────────────────────────
          _ApprovalsFilterHeader(l10n: l10n),
          const SizedBox(height: 20),

          // ── Date Picker ──────────────────────────────────────────────────
          _ApprovalsDateField(
            l10n: l10n,
            selectedDate: selectedDate,
            onDateChanged: onDateChanged,
          ),
          const SizedBox(height: 16),

          // ── Team Dropdown ────────────────────────────────────────────────
          _TeamDropdownField(
            l10n: l10n,
            selectedTeam: selectedTeam,
            teams: teams,
            isArabic: Localizations.localeOf(context).languageCode == 'ar',
            onTeamChanged: onTeamChanged,
          ),
          const SizedBox(height: 16),

          // ── Auth Status Chips ────────────────────────────────────────────
          _ApprovalsAuthRadioGroup(
            l10n: l10n,
            selectedAuth: selectedAuth,
            onChanged: onAuthChanged,
          ),
          const SizedBox(height: 20),

          // ── Action Buttons ───────────────────────────────────────────────
          _ApprovalsFilterActions(
            l10n: l10n,
            onSearchPressed: onSearchPressed,
            onResetPressed: onResetPressed,
          ),
        ],
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _ApprovalsFilterHeader extends StatelessWidget {
  final AppLocalizations l10n;
  const _ApprovalsFilterHeader({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF10B981), Color(0xFF059669)],
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
            color: Color(0xFF059669),
          ),
        ),
      ],
    );
  }
}

// ── Date Field ────────────────────────────────────────────────────────────────

class _ApprovalsDateField extends StatelessWidget {
  final AppLocalizations l10n;
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onDateChanged;

  const _ApprovalsDateField({
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
            primary: Color(0xFF10B981),
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
                ? const Color(0xFF10B981)
                : Colors.grey.shade300,
            width: selectedDate != null ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: selectedDate != null
              ? const Color(0xFF10B981).withOpacity(0.04)
              : Colors.grey.shade50,
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 20,
              color: selectedDate != null
                  ? const Color(0xFF10B981)
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
                  color: Color(0xFF10B981),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Team Dropdown ─────────────────────────────────────────────────────────────

class _TeamDropdownField extends StatelessWidget {
  final AppLocalizations l10n;
  final teams_model.Items? selectedTeam;
  final List<teams_model.Items> teams;
  final bool isArabic;
  final ValueChanged<teams_model.Items?> onTeamChanged;

  const _TeamDropdownField({
    required this.l10n,
    required this.selectedTeam,
    required this.teams,
    required this.isArabic,
    required this.onTeamChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasSelection = selectedTeam != null;

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: hasSelection ? const Color(0xFF10B981) : Colors.grey.shade300,
          width: hasSelection ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: hasSelection
            ? const Color(0xFF10B981).withOpacity(0.04)
            : Colors.grey.shade50,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<teams_model.Items>(
          value: selectedTeam,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: hasSelection
                ? const Color(0xFF10B981)
                : Colors.grey.shade500,
          ),
          hint: Row(
            children: [
              Icon(Icons.groups_rounded, size: 20, color: Colors.grey.shade500),
              const SizedBox(width: 12),
              Text(
                l10n.approvalsFilterTeamHint,
                style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
              ),
            ],
          ),
          onChanged: onTeamChanged,
          items: teams.map((team) {
            final name = isArabic
                ? (team.teamNameA ?? team.bandName ?? '')
                : (team.teamNameE ??
                      team.teamNameA ??
                      team.bandNameE ??
                      team.bandName ??
                      '');
            return DropdownMenuItem<teams_model.Items>(
              value: team,
              child: Row(
                children: [
                  const Icon(
                    Icons.groups_rounded,
                    size: 18,
                    color: Color(0xFF10B981),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '$name - ${team.teamNo}',
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          selectedItemBuilder: (context) => teams.map((team) {
            final name = isArabic
                ? (team.teamNameA ?? team.bandName ?? '')
                : (team.teamNameE ??
                      team.teamNameA ??
                      team.bandNameE ??
                      team.bandName ??
                      '');
            return Row(
              children: [
                const Icon(
                  Icons.groups_rounded,
                  size: 20,
                  color: Color(0xFF10B981),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    name,
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

// ── Auth Radio Group ──────────────────────────────────────────────────────────

class _ApprovalsAuthRadioGroup extends StatelessWidget {
  final AppLocalizations l10n;
  final AuthFilterStatus selectedAuth;
  final ValueChanged<AuthFilterStatus> onChanged;

  const _ApprovalsAuthRadioGroup({
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
                color: const Color(0xFF10B981),
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
            _ApprovalsChip(
              label: l10n.filterAll,
              value: AuthFilterStatus.all,
              groupValue: selectedAuth,
              onChanged: onChanged,
              activeColor: const Color(0xFF10B981),
            ),
            _ApprovalsChip(
              label: l10n.filterApproved,
              value: AuthFilterStatus.approved,
              groupValue: selectedAuth,
              onChanged: onChanged,
              activeColor: Colors.green,
            ),
            _ApprovalsChip(
              label: l10n.filterNotApproved,
              value: AuthFilterStatus.notApproved,
              groupValue: selectedAuth,
              onChanged: onChanged,
              activeColor: Colors.orange,
            ),
            _ApprovalsChip(
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

class _ApprovalsChip extends StatelessWidget {
  final String label;
  final AuthFilterStatus value;
  final AuthFilterStatus groupValue;
  final ValueChanged<AuthFilterStatus> onChanged;
  final Color activeColor;

  const _ApprovalsChip({
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

// ── Action Buttons ────────────────────────────────────────────────────────────

class _ApprovalsFilterActions extends StatelessWidget {
  final AppLocalizations l10n;
  final VoidCallback onSearchPressed;
  final VoidCallback onResetPressed;

  const _ApprovalsFilterActions({
    required this.l10n,
    required this.onSearchPressed,
    required this.onResetPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ApprovalsSearchBtn(l10n: l10n, onPressed: onSearchPressed),
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
    );
  }
}

class _ApprovalsSearchBtn extends StatefulWidget {
  final AppLocalizations l10n;
  final VoidCallback onPressed;

  const _ApprovalsSearchBtn({required this.l10n, required this.onPressed});

  @override
  State<_ApprovalsSearchBtn> createState() => _ApprovalsSearchBtnState();
}

class _ApprovalsSearchBtnState extends State<_ApprovalsSearchBtn> {
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
            colors: [Color(0xFF10B981), Color(0xFF059669)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: const Color(0xFF10B981).withOpacity(0.3),
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
