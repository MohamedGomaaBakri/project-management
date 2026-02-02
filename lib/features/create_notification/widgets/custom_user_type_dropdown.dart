import 'package:flutter/material.dart';
import 'package:shehabapp/core/models/users_type_model.dart' as user_type;
import 'package:shehabapp/l10n/app_localizations.dart';

class CustomUserTypeDropdown extends StatelessWidget {
  final List<user_type.Items>? userTypes;
  final user_type.Items? selectedUserType;
  final Function(user_type.Items?) onChanged;
  final bool isLoading;

  const CustomUserTypeDropdown({
    super.key,
    required this.userTypes,
    required this.selectedUserType,
    required this.onChanged,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.selectUserType,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4F46E5),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selectedUserType != null
                    ? const Color(0xFF4F46E5)
                    : Colors.grey[300]!,
                width: 1.5,
              ),
            ),
            child: isLoading
                ? const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF4F46E5),
                        ),
                      ),
                    ),
                  )
                : DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      isExpanded: true,
                      value: selectedUserType?.code,
                      hint: Text(
                        l10n.selectUserType,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey[600],
                      ),
                      items: userTypes
                          ?.fold<Map<int, user_type.Items>>({}, (map, item) {
                            // Use code as unique key to avoid duplicates
                            if (item.code != null) {
                              map[item.code!] = item;
                            }
                            return map;
                          })
                          .values
                          .map((userType) {
                            return DropdownMenuItem<int>(
                              value: userType.code,
                              child: Text(
                                userType.nameA ?? userType.nameE ?? 'N/A',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          })
                          .toList(),
                      onChanged: (int? code) {
                        if (code != null && userTypes != null) {
                          final selected = userTypes!.firstWhere(
                            (item) => item.code == code,
                            orElse: () => user_type.Items(),
                          );
                          onChanged(selected);
                        } else {
                          onChanged(null);
                        }
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
