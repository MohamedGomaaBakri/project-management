import 'package:flutter/material.dart';
import 'package:shehabapp/core/models/projects_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../daily_tasks/widgets/project_filter_dropdown.dart';
import '../../daily_tasks/widgets/contract_number_filter.dart';
import '../../daily_tasks/widgets/sec_number_filter.dart';
import '../../daily_tasks/widgets/status_filter_radio.dart';
import '../../daily_tasks/widgets/search_button_widget.dart';

const Color _kGreen1 = Color(0xFF16A34A);

class SafeFilterSectionWidget extends StatelessWidget {
  final String? selectedProject;
  final List<Project> projects;
  final ValueChanged<String?> onProjectChanged;
  final TextEditingController contractController;
  final TextEditingController secController;
  final TaskStatus selectedStatus;
  final ValueChanged<TaskStatus> onStatusChanged;
  final VoidCallback onSearchPressed;
  final VoidCallback onResetPressed;
  final bool isSearchEnabled;

  const SafeFilterSectionWidget({
    super.key,
    required this.selectedProject,
    required this.projects,
    required this.onProjectChanged,
    required this.contractController,
    required this.secController,
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.onSearchPressed,
    required this.onResetPressed,
    this.isSearchEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 800;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _kGreen1.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_kGreen1, Color(0xFF059669)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.filter_list,
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
                  color: _kGreen1,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Filter Fields
          if (isLargeScreen)
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ProjectFilterDropdown(
                        selectedProject: selectedProject,
                        projects: projects,
                        onChanged: onProjectChanged,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ContractNumberFilter(
                        controller: contractController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: SecNumberFilter(controller: secController)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatusFilterRadio(
                        selectedStatus: selectedStatus,
                        onChanged: onStatusChanged,
                      ),
                    ),
                  ],
                ),
              ],
            )
          else
            Column(
              children: [
                ProjectFilterDropdown(
                  selectedProject: selectedProject,
                  projects: projects,
                  onChanged: onProjectChanged,
                ),
                const SizedBox(height: 16),
                ContractNumberFilter(controller: contractController),
                const SizedBox(height: 16),
                SecNumberFilter(controller: secController),
                const SizedBox(height: 16),
                StatusFilterRadio(
                  selectedStatus: selectedStatus,
                  onChanged: onStatusChanged,
                ),
              ],
            ),

          const SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: SearchButtonWidget(
                  onPressed: onSearchPressed,
                  isEnabled: isSearchEnabled,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
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
