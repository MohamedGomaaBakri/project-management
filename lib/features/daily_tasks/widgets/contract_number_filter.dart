import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../l10n/app_localizations.dart';

class ContractNumberFilter extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const ContractNumberFilter({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.text,
        // inputFormatters: [FilteringTextInputFormatter.],
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: l10n.contractNumber,
          hintText: l10n.enterContractNumber,
          prefixIcon: const Icon(
            Icons.numbers,
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
        style: TextStyle(color: Colors.grey[800], fontSize: 14),
      ),
    );
  }
}
