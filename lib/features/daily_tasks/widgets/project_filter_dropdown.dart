import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:shehabapp/core/models/projects_model.dart';
import '../../../../l10n/app_localizations.dart';

class ProjectFilterDropdown extends StatelessWidget {
  final String? selectedProject;
  final List<Project> projects;
  final ValueChanged<String?> onChanged;

  const ProjectFilterDropdown({
    super.key,
    required this.selectedProject,
    required this.projects,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Find the currently selected project object based on the ID
    final selectedProjectItem = selectedProject != null && projects.isNotEmpty
        ? projects.cast<Project?>().firstWhere(
            (element) => element?.projectId.toString() == selectedProject,
            orElse: () => null,
          )
        : null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownSearch<Project>(
        popupProps: PopupProps.menu(
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              hintText: l10n.search,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
          ),
          menuProps: MenuProps(borderRadius: BorderRadius.circular(12)),
        ),
        items: (filter, loadProps) {
          return Future.value(
            projects.where((element) {
              final keyword = filter.toLowerCase();
              final name = (element.nameA ?? '').toLowerCase();
              final id = element.projectId.toString();
              return name.contains(keyword) || id.contains(keyword);
            }).toList(),
          );
        },
        itemAsString: (Project u) => '${u.nameA} - ${u.projectId}',
        compareFn: (item1, item2) => item1.projectId == item2.projectId,
        selectedItem: selectedProjectItem,
        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
            labelText: l10n.projectFilter,
            hintText: l10n.selectProject,
            prefixIcon: const Icon(
              Icons.folder_open,
              color: Color(0xFF4F46E5),
              size: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
        onChanged: (Project? data) {
          if (data != null) {
            onChanged(data.projectId.toString());
          } else {
            onChanged(null);
          }
        },
      ),
    );
  }
}
