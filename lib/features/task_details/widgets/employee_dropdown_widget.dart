import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/user_model.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../l10n/app_localizations.dart';

class EmployeeDropdownWidget extends StatelessWidget {
  final List<User> users;
  final String? defaultEmployeeCode;
  final String? selectedEmployeeCode;
  final Function(String?) onChanged;

  const EmployeeDropdownWidget({
    super.key,
    required this.users,
    this.defaultEmployeeCode,
    this.selectedEmployeeCode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isArabic = localeProvider.locale.languageCode == 'ar';

    // Determine the initially selected user
    final initialCode = selectedEmployeeCode ?? defaultEmployeeCode;
    final selectedUser = initialCode != null && users.isNotEmpty
        ? users.cast<User?>().firstWhere(
            (u) => u?.usersCode.toString() == initialCode,
            orElse: () => null,
          )
        : null;

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
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFEC4899), Color(0xFFF97316)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFEC4899).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    l10n.assignedEmployee,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF4F46E5).withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: DropdownSearch<User>(
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
                    users.where((user) {
                      final keyword = filter.toLowerCase();
                      final nameAr = (user.usersName ?? '').toLowerCase();
                      final nameEn = (user.usersNameE ?? '').toLowerCase();
                      final code = user.usersCode.toString();
                      return nameAr.contains(keyword) ||
                          nameEn.contains(keyword) ||
                          code.contains(keyword);
                    }).toList(),
                  );
                },
                itemAsString: (User u) {
                  final userName = isArabic
                      ? u.usersName
                      : (u.usersNameE ?? u.usersName);
                  return '$userName (${u.usersCode})';
                },
                compareFn: (item1, item2) => item1.usersCode == item2.usersCode,
                selectedItem: selectedUser,
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    hintText: l10n.selectEmployee,
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    suffixIcon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF4F46E5),
                    ),
                  ),
                ),
                onChanged: (User? data) {
                  if (data != null) {
                    onChanged(data.usersCode.toString());
                  } else {
                    onChanged(null);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
