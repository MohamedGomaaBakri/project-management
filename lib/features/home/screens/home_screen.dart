
import 'package:flutter/material.dart';
import 'package:shehabapp/features/attendance/screens/attendance_main_screen.dart';
import 'package:shehabapp/features/loans/screens/loan_requests_list_screen.dart';
import 'package:shehabapp/features/loans/screens/my_requests/my_loan_requests_list_screen.dart';
import 'package:shehabapp/features/permissions/screens/my_requests/my_permission_requests_list_screen.dart';
import 'package:shehabapp/features/permissions/screens/permission_requests_list_screen.dart';
import 'package:shehabapp/features/resignations/screens/my_requests/my_resignation_requests_list_screen.dart';
import 'package:shehabapp/features/resignations/screens/resignation_requests_list_screen.dart';
import 'package:shehabapp/features/resume_work/screens/my_requests/my_resume_work_requests_list_screen.dart';
import 'package:shehabapp/features/resume_work/screens/resume_work_requests_list_screen.dart';
import 'package:shehabapp/features/vacations/screens/my_requests/my_vacation_requests_list_screen.dart';
import 'package:shehabapp/features/vacations/screens/vacation_requests_list_screen.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/home_provider.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/utils/app_colors.dart';

import '../../auth/screens/login_screen.dart';

import '../../cancel_salary_confirmation/screens/cancel_salary_confirmation_requests_list_screen.dart';
import '../../cancel_salary_confirmation/screens/my_requests/my_cancel_salary_confirmation_requests_list_screen.dart';
import '../../car_movement/screens/car_movement_requests_list_screen.dart';
import '../../car_movement/screens/my_requests/my_car_movement_requests_list_screen.dart';
import '../../employee_transfer/screens/employee_transfer_requests_list_screen.dart';
import '../../employee_transfer/screens/my_requests/my_employee_transfer_requests_list_screen.dart';
import '../../purchases/screens/purchase_orders_list_screen.dart';
import '../../salary_confirmation/screens/my_requests/my_salary_confirmation_requests_list_screen.dart';
import '../../salary_confirmation/screens/salary_confirmation_requests_list_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _mainAnimController;
  late AnimationController _sliderAnimController;
  late PageController _pageController;
  int _currentPage = 0;

  // للتحكم في عرض الخيارات الفرعية
  bool _showApprovalsOptions = false;
  bool _showMyRequestsOptions = false;
  late AnimationController _approvalsAnimController;
  late AnimationController _myRequestsAnimController;

  @override
  void initState() {
    super.initState();
    print("[HomeScreen] initState called");

    // تهيئة animation controllers
    _mainAnimController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();

    _sliderAnimController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _approvalsAnimController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _myRequestsAnimController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _pageController = PageController(
      viewportFraction: 0.85,
      initialPage: 0,
    );

    _pageController.addListener(() {
      if (_pageController.page != null) {
        int next = _pageController.page!.round();
        if (_currentPage != next) {
          setState(() {
            _currentPage = next;
          });
        }
      }
    });

    // تحميل البيانات بعد بناء الواجهة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("[HomeScreen] addPostFrameCallback called");
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.currentUser != null && mounted) {
        print("[HomeScreen] Current user exists, loading notifications...");
        Provider.of<HomeProvider>(context, listen: false)
            .loadNotifications(authProvider.currentUser!.usersCode)
            .then((_) {
          if (mounted) {
            print("[HomeScreen] Notifications loaded (or attempt finished).");
          }
        });
      } else {
        print(
            "[HomeScreen] No current user or widget not mounted in addPostFrameCallback.");
      }
    });
  }

  @override
  void dispose() {
    _mainAnimController.dispose();
    _sliderAnimController.dispose();
    _approvalsAnimController.dispose();
    _myRequestsAnimController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  List<MenuItemData> _getMenuItems(AppLocalizations localizations) {
    return [
      MenuItemData(
        title: localizations.purchasesO,
        icon: Icons.playlist_add_check_circle_rounded,
        color: const Color(0xFF2196F3),
        route: '/purchase-orders',
      ),
      MenuItemData(
        title: localizations.purchasesR,
        icon: Icons.add_shopping_cart_rounded,
        color: const Color(0xFF9C27B0),
        route: '/schedule',
      ),
    ];
  }

  void _toggleApprovalsOptions() {
    setState(() {
      if (_showMyRequestsOptions) {
        _showMyRequestsOptions = false;
        _myRequestsAnimController.reverse();
      }
      _showApprovalsOptions = !_showApprovalsOptions;
      if (_showApprovalsOptions) {
        _approvalsAnimController.forward();
      } else {
        _approvalsAnimController.reverse();
      }
    });
  }

  void _toggleMyRequestsOptions() {
    setState(() {
      if (_showApprovalsOptions) {
        _showApprovalsOptions = false;
        _approvalsAnimController.reverse();
      }
      _showMyRequestsOptions = !_showMyRequestsOptions;
      if (_showMyRequestsOptions) {
        _myRequestsAnimController.forward();
      } else {
        _myRequestsAnimController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("[HomeScreen] build called");
    final localizations = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context);
    final homeProvider = Provider.of<HomeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final user = authProvider.currentUser;

    if (user == null) {
      print("[HomeScreen] User is null, navigating to LoginScreen.");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
        }
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    print("[HomeScreen] Building UI for user: ${user.usersName}");
    print(
        "[HomeScreen] homeProvider.isLoadingNotifications: ${homeProvider.isLoadingNotifications}");
    print(
        "[HomeScreen] homeProvider.notificationError: ${homeProvider.notificationError}");
    print(
        "[HomeScreen] homeProvider.notificationInfo: ${homeProvider.notificationInfo != null}");

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(localizations, localeProvider),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    _buildCategoryTitle(
                        localizations.humanResources, Icons.groups_2_rounded, user.compEmpCode),
                    const SizedBox(height: 24),
                    _buildMainCards(localizations),
                    _buildSubOptions(localizations),
                    const Spacer(),
                    _buildUserInfo(
                        localeProvider.locale.languageCode == 'ar'
                            ? user.usersName ?? user.usersName
                            : user.usersNameE ?? user.usersNameE,
                        localeProvider.locale.languageCode == 'ar'
                            ? user.jobDesc ?? user.jobDesc
                            : user.jobDescE ?? user.jobDescE,
                        user.compEmpCode
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations localizations, LocaleProvider localeProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF4F46E5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isSmallScreen = constraints.maxWidth < 400;

            return Row(
              children: [
                // الجزء الأيسر
                Expanded(
                  flex: isSmallScreen ? 3 : 2,
                  child: Row(
                    children: [
                      const HeroIcon(),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          localizations.appName,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 18 : 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                // الجزء الأيمن
                Expanded(
                  flex: isSmallScreen ? 2 : 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // زر تسجيل الخروج
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (c) => const LoginScreen()));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.logout,
                            color: Color(0xFF1E3A8A),
                            size: 16,
                          ),
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 8 : 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(25),
                            onTap: () {
                              localeProvider.toggleLocale();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: isSmallScreen ? 12 : 16,
                                  vertical: isSmallScreen ? 8 : 10
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.language,
                                    color: Colors.white,
                                    size: isSmallScreen ? 18 : 20,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    localeProvider.locale.languageCode == 'en' ? 'العربية' : 'English',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: isSmallScreen ? 12 : 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryTitle(String title, IconData icon, int userid) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF1E3A8A),
            size: 24,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A8A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainCards(AppLocalizations localizations) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildMainCard(
              title: localizations.myProfile, // طلباتي
              icon:Icons.list_alt ,
              color: const Color(0xFF4CAF50),
              isActive: _showApprovalsOptions,
              onTap: _toggleApprovalsOptions,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildMainCard(
              title: localizations.humanResources, // الموافقات المطلوبة
              icon: Icons.approval,
              color: const Color(0xFF320385).withOpacity(.8),
              isActive: _showMyRequestsOptions,
              onTap: _toggleMyRequestsOptions,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainCard({
    required String title,
    required IconData icon,
    required Color color,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 180,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isActive
                  ? [color, color.withOpacity(0.8)]
                  : [color.withOpacity(0.9), color.withOpacity(0.7)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(isActive ? 0.6 : 0.4),
                blurRadius: isActive ? 15 : 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background decorative elements
              Positioned(
                right: -30,
                top: -30,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                left: -20,
                bottom: -20,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Main content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(isActive ? 0.3 : 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        size: 42,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    AnimatedRotation(
                      turns: isActive ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubOptions(AppLocalizations localizations) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      height: _showApprovalsOptions || _showMyRequestsOptions ? 280 : 0,
      curve: Curves.easeInOut,
      child: ClipRect(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Row(
                  children: [
                    // العمود الأيسر - خيارات الموافقات
                    Expanded(
                      child: _showApprovalsOptions
                          ? SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(-0.5, 0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _approvalsAnimController,
                          curve: Curves.easeOutBack,
                        )),
                        child: FadeTransition(
                          opacity: _approvalsAnimController,
                          child: _buildVerticalOptionsColumn([
                            SubOptionData(
                              title: localizations.vacationInfo,
                              icon: Icons.flight_takeoff_rounded,
                              color: const Color(0xFF2196F3),
                              onTap: () => Navigator.of(context).pushNamed(VacationRequestsListScreen.routeName),
                            ),
                            SubOptionData(
                              title: localizations.loanInfo,
                              icon: Icons.account_balance_wallet,
                              color: const Color(0xFF4CAF50),
                              onTap: () => Navigator.of(context).pushNamed(LoanRequestsListScreen.routeName),
                            ),
                            SubOptionData(
                              title: localizations.resignationInfo,
                              icon: Icons.exit_to_app,
                              color: const Color(0xFFFFA000),
                              onTap: () => Navigator.of(context).pushNamed(ResignationRequestsListScreen.routeName),
                            ),
                            SubOptionData(
                              title: localizations.permissionInfo,
                              icon: Icons.grid_view_rounded,
                              color: const Color(0xFF8F7CB9),
                              onTap: () => Navigator.of(context).pushNamed(PermissionRequestsListScreen.routeName),
                            ),
                            SubOptionData(
                              title: localizations.resumeWorkInfo,
                              icon: Icons.restart_alt_sharp,
                              color: const Color(0xFF9F299D),
                              onTap: () => Navigator.of(context).pushNamed(ResumeWorkRequestsListScreen.routeName),
                            ),
                            /*
                            SubOptionData(
                              title: localizations.employeeTransferInfo,
                              icon: Icons.transfer_within_a_station,
                              color: const Color(0xFF3669A2),
                              onTap: () => Navigator.of(context).pushNamed(EmployeeTransferRequestsListScreen.routeName),
                            ),
                            SubOptionData(
                              title: localizations.carMovementInfo,
                              icon: Icons.directions_car_sharp,
                              color: const Color(0xFF8A822F),
                              onTap: () => Navigator.of(context).pushNamed(CarMovementRequestsListScreen.routeName),
                            ),
                            SubOptionData(
                              title: localizations.salaryConfirmationInfo,
                              icon: Icons.confirmation_num,
                              color: const Color(0xFF23F618),
                              onTap: () => Navigator.of(context).pushNamed(SalaryConfirmationRequestsListScreen.routeName),
                            ),
                            SubOptionData(
                              title: localizations.cancelSalaryConfirmationInfo,
                              icon: Icons.close,
                              color: const Color(0xFF830920),
                              onTap: () => Navigator.of(context).pushNamed(CancelSalaryConfirmationRequestsListScreen.routeName),
                            ),
                            */


                          ]),
                        ),
                      )
                          : const SizedBox(),
                    ),
                    const SizedBox(width: 16),
                    // العمود الأيمن - طلباتي
                    Expanded(
                      child: _showMyRequestsOptions
                          ? SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.5, 0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _myRequestsAnimController,
                          curve: Curves.easeOutBack,
                        )),
                        child: FadeTransition(
                          opacity: _myRequestsAnimController,
                          child: _buildVerticalOptionsColumn([
                            SubOptionData(
                              title: localizations.vacationInfo,
                              icon: Icons.flight_takeoff_rounded,
                              color: const Color(0xFF2196F3),
                              onTap: () => Navigator.of(context).pushNamed(MyVacationRequestsListScreen.routeName),
                            ),
                            SubOptionData(
                              title: localizations.loanInfo,
                              icon: Icons.account_balance_wallet,
                              color: const Color(0xFF4CAF50),
                              onTap: () => Navigator.of(context).pushNamed(MyLoanRequestsListScreen.routeName),
                            ),
                            SubOptionData(
                              title: localizations.resignationInfo,
                              icon: Icons.exit_to_app,
                              color: const Color(0xFFFFA000),
                              onTap: () => Navigator.of(context).pushNamed(MyResignationRequestsListScreen.routeName),
                            ),
                            SubOptionData(
                              title: localizations.permissionInfo,
                              icon: Icons.grid_view_rounded,
                              color: const Color(0xFF8F7CB9),
                              onTap: () => Navigator.of(context).pushNamed(MyPermissionRequestsListScreen.routeName),
                            ),
                            SubOptionData(
                              title: localizations.resumeWorkInfo,
                              icon: Icons.restart_alt_sharp,
                              color: const Color(0xFF9F299D),
                              onTap: () => Navigator.of(context).pushNamed(MyResumeWorkRequestsListScreen.routeName),
                            ),
                            /*
                            SubOptionData(
                              title: localizations.employeeTransferInfo,
                              icon: Icons.transfer_within_a_station,
                              color: const Color(0xFF3669A2),
                              onTap: () => Navigator.of(context).pushNamed(MyEmployeeTransferRequestsListScreen.routeName),
                            ),
                            SubOptionData(
                              title: localizations.carMovementInfo,
                              icon: Icons.directions_car_sharp,
                              color: const Color(0xFF8A822F),
                              onTap: () => Navigator.of(context).pushNamed(MyCarMovementRequestsListScreen.routeName),
                            ),
                            SubOptionData(
                              title: localizations.salaryConfirmationInfo,
                              icon: Icons.confirmation_num,
                              color: const Color(0xFF23F618),
                                onTap: () => Navigator.of(context).pushNamed(MySalaryConfirmationRequestsListScreen.routeName),
                            ),
                            SubOptionData(
                              title: localizations.cancelSalaryConfirmationInfo,
                              icon: Icons.close,
                              color: const Color(0xFF830920),
                              onTap: () => Navigator.of(context).pushNamed(MyCancelSalaryConfirmationRequestsListScreen.routeName),
                            ),

                             */

                          ]),
                        ),
                      )
                          : const SizedBox(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalOptionsColumn(List<SubOptionData> options) {
    return Column(
      children: options.map((option) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _buildSubOptionCard(option),
      )).toList(),
    );
  }

  Widget _buildSubOptionCard(SubOptionData option) {
    return GestureDetector(
      onTap: option.onTap,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              option.color.withOpacity(0.8),
              option.color.withOpacity(0.6),
            ],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: option.color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -15,
              top: -15,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    option.icon,
                    size: 28,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    option.title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(String? name, String? title, int compEmpCode) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed('/user-profile', arguments: compEmpCode);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.person,
                color: Color(0xFF1E3A8A),
                size: 40,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      " ${name ?? ''} ",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${title ?? ''}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                      textDirection: TextDirection.rtl,
                    )
                  ],
                ),
              ),
              const SizedBox(width: 5),
              const Icon(Icons.arrow_back_ios),
            ],
          ),
        ));
  }
}

class HeroIcon extends StatefulWidget {
  const HeroIcon({super.key});

  @override
  _HeroIconState createState() => _HeroIconState();
}

class _HeroIconState extends State<HeroIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: (_controller.value * 2 * math.pi) / 20,
          child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3 + (_controller.value * 0.2)),
                    blurRadius: 10,
                    spreadRadius: _controller.value * 2,
                  ),
                ],
              ),
              child: const CircleAvatar(
                maxRadius: 15,
                backgroundImage: AssetImage("assets/images/ascon.jpg"),
              )
          ),
        );
      },
    );
  }
}

class MenuItemData {
  final String title;
  final IconData icon;
  final Color color;
  final String route;
  final int? notificationCount;

  MenuItemData({
    required this.title,
    required this.icon,
    required this.color,
    required this.route,
    this.notificationCount,
  });
}

class SubOptionData {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  SubOptionData({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}