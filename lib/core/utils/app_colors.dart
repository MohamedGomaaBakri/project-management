import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF4F46E5); // لون بنفسجي مقترح
  static const Color accentColor = Color(0xFF4F46E5);
  static const Color backgroundColor = Colors.white;
  static const Color textFieldFillColor = Color(0xFFF5F5F5);
  static const Color textColor = Colors.black87;
  static const Color hintColor = Colors.grey;
  static const Color errorColor = Colors.redAccent;
  static const Color successColor = Colors.green;
  static Color getStatusColor(int? flag) {
    switch (flag) {
      case 1:
        return successColor;
      case -1:
        return errorColor;
      case 0:
        return Colors.orange.shade700; // تحت الإجراء
      default:
        return hintColor;
    }
  }
}
