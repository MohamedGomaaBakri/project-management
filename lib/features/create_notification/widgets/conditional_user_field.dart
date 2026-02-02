import 'package:flutter/material.dart';
import 'package:shehabapp/core/models/users_model.dart';
import 'package:shehabapp/l10n/app_localizations.dart';

class ConditionalUserField extends StatelessWidget {
  final String? userName;
  final List<Items>? users;
  final Items? selectedUser;
  final Function(Items?) onUserChanged;
  final bool isLoading;

  const ConditionalUserField({
    super.key,
    required this.userName,
    required this.users,
    required this.selectedUser,
    required this.onUserChanged,
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
                    Icons.account_circle_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.user,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: userName != null
                    ? Colors.green[300]!
                    : selectedUser != null
                    ? const Color(0xFF4F46E5)
                    : Colors.grey[300]!,
                width: 1.5,
              ),
            ),
            child: _buildContent(context, l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, AppLocalizations l10n) {
    // If userName exists, show as read-only text
    if (userName != null && userName!.isNotEmpty) {
      return Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green[600], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              userName!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      );
    }

    // Otherwise, show dropdown
    if (isLoading) {
      return const Center(
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Color(0xFF4F46E5),
          ),
        ),
      );
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton<Items>(
        isExpanded: true,
        value: selectedUser,
        hint: Text(
          l10n.selectUser,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
        items: users?.map((user) {
          return DropdownMenuItem<Items>(
            value: user,
            child: Text(
              user.usersName ?? user.usersNameE ?? 'N/A',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          );
        }).toList(),
        onChanged: onUserChanged,
      ),
    );
  }
}
