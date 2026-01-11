import 'package:flutter/material.dart';
import 'package:shehabapp/core/models/project_categories_count.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart'; // لاستخدامها لاحقًا إذا أردت حفظ حالة تسجيل الدخول

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _currentUser;
  ProjectCategoriesCount? _projectCategoriesCount;
  bool _isLoading = false;
  String? _errorMessage;
  // متغير جديد لتتبع حالة التحقق الأولي
  bool _isAuthChecked = false;

  User? get currentUser => _currentUser;
  ProjectCategoriesCount? get projectCategoriesCount => _projectCategoriesCount;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthChecked => _isAuthChecked;

  // لتخزين بيانات المستخدم بعد تسجيل الدخول بنجاح
  void _setCurrentUser(User? user) async {
    _currentUser = user;
    if (user != null) {
      // يمكنك هنا حفظ بعض بيانات المستخدم في SharedPreferences إذا أردت
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('usersCode', user.usersCode);
      await prefs.setString('userName', user.usersName);
    }
    notifyListeners();
  }

  // الدالة التي تحفظ بيانات المستخدم عند تسجيل الدخول بنجاح
  Future<void> _saveAuthData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('usersCode', user.usersCode);
    await prefs.setString('userName', user.usersName);
  }

  Future<bool> login(String usersCode, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.login(usersCode, password);
      if (user != null) {
        _setCurrentUser(user);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'رمز المستخدم أو كلمة المرور غير صحيحة.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء محاولة تسجيل الدخول. حاول مرة أخرى.';
      print('Login error in provider: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // --== الدالة الجديدة للتحقق من تسجيل الدخول التلقائي ==--
  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    // إذا لم نجد كود المستخدم، فهذا يعني أنه لم يسجل دخوله من قبل
    if (!prefs.containsKey('usersCode')) {
      _isAuthChecked = true;
      notifyListeners();
      return;
    }

    final savedUsersCode = prefs.getInt('usersCode')!.toString();

    try {
      // نحاول جلب بيانات المستخدم الكاملة باستخدام الكود المحفوظ
      final user = await _authService.getUser(savedUsersCode);
      if (user != null) {
        _currentUser = user;
      }
    } catch (e) {
      // في حالة حدوث خطأ (مثل عدم وجود انترنت)، لا نسجل دخول المستخدم
      print("Auto-login failed: $e");
      _currentUser = null;
    }

    _isAuthChecked = true;
    notifyListeners();
  }

  Future<void> logout() async {
    _setCurrentUser(null);
    // يمكنك هنا حذف بيانات المستخدم من SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }

  Future<void> getProjectCategoriesCount({required String usersCode}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final projectCategoriesCount = await _authService
          .getProjectCategoriesCount(usersCode: usersCode);
      if (projectCategoriesCount != null) {
        _projectCategoriesCount = projectCategoriesCount;
        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage = 'لم يتم العثور على بيانات تصنيفات المشاريع.';
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage =
          'حدث خطأ أثناء جلب بيانات تصنيفات المشاريع. حاول مرة أخرى.';
      print('Error getting project categories count in provider: $e');
      _isLoading = false;
      _projectCategoriesCount = null;
      notifyListeners();
    }
  }
}
