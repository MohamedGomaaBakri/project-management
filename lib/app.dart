import 'package:flutter/material.dart';
import 'package:shehabapp/core/providers/daily_tasks_provider.dart';
import 'package:shehabapp/core/providers/hr_provider.dart';
import 'package:shehabapp/core/providers/notification_provider.dart';
import 'package:shehabapp/core/providers/task_permission_provider.dart';
import 'package:shehabapp/features/attendance/providers/attendance_provider.dart';
import 'package:shehabapp/core/providers/management_provider.dart';
import 'package:shehabapp/features/attendance/screens/attendance_main_screen.dart';
import 'package:shehabapp/features/attendance/screens/attendance_months_list_screen.dart';
import 'package:shehabapp/features/attendance/screens/checked_attendance_months_list_screen.dart';
import 'package:shehabapp/features/auth/screens/auth_wrapper.dart';
import 'package:shehabapp/features/auth/screens/project_categories.dart';
import 'package:shehabapp/features/create_notification/notifications_view.dart';
import 'package:shehabapp/features/daily_tasks/daily_tasks_screen.dart';
import 'package:shehabapp/features/display_notifications/display_notifications_view.dart';
import 'package:shehabapp/features/loans/screens/loan_request_details_screen.dart';
import 'package:shehabapp/features/loans/screens/loan_requests_list_screen.dart';
import 'package:shehabapp/features/management/views/management_view.dart';
import 'package:shehabapp/features/request_material_from_store/views/task_and_approval_selection_view.dart';
import 'package:shehabapp/features/request_material_from_store/views/tasks_data_view.dart';
import 'package:shehabapp/features/request_material_from_store/views/approvals_view.dart';
import 'package:shehabapp/features/request_material_from_store/views/approval_detail_view.dart';
import 'package:shehabapp/features/request_material_from_store/views/one_task_details_view.dart';
import 'package:shehabapp/features/request_material_from_store/views/add_task_view.dart';
import 'package:shehabapp/core/providers/request_material_from_store_provider.dart';
import 'package:shehabapp/features/management/views/mng_daily_tasks_view.dart';
import 'package:shehabapp/features/management/views/mng_notification_details_view.dart';
import 'package:shehabapp/features/management/views/mng_notification_view.dart';
import 'package:shehabapp/features/management/views/mng_permissions_view.dart';
import 'package:shehabapp/features/permissions/screens/my_requests/my_permission_requests_list_screen.dart';
import 'package:shehabapp/features/permissions/screens/my_requests/new_permission_request_screen.dart';
import 'package:shehabapp/features/permissions/screens/permission_request_details_screen.dart';
import 'package:shehabapp/features/permissions/screens/permission_requests_list_screen.dart';
import 'package:shehabapp/features/resignations/screens/resignation_request_details_screen.dart';
import 'package:shehabapp/features/resignations/screens/resignation_requests_list_screen.dart';
import 'package:shehabapp/features/task_details/project_details_view.dart';
import 'package:shehabapp/features/task_details/task_details_view.dart';

import 'package:shehabapp/features/vacations/screens/vacation_request_details_screen.dart';
import 'package:shehabapp/features/vacations/screens/vacation_requests_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:shehabapp/core/providers/home_provider.dart';
import 'package:shehabapp/core/providers/purchase_provider.dart';
import 'package:shehabapp/core/providers/user_provider.dart';
import 'package:shehabapp/features/purchases/screens/purchase_order_details_screen.dart';
import 'package:shehabapp/features/user_profile/screens/user_profile_screen.dart';
import 'core/providers/auth_provider.dart';
import 'core/utils/app_strings.dart';
import 'core/utils/app_colors.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/cancel_salary_confirmation/screens/cancel_salary_confirmation_request_details_screen.dart';
import 'features/cancel_salary_confirmation/screens/cancel_salary_confirmation_requests_list_screen.dart';
import 'features/cancel_salary_confirmation/screens/my_requests/my_cancel_salary_confirmation_requests_list_screen.dart';
import 'features/cancel_salary_confirmation/screens/my_requests/new_cancel_salary_confirmation_request_screen.dart';
import 'features/car_movement/screens/car_movement_request_details_screen.dart';
import 'features/car_movement/screens/car_movement_requests_list_screen.dart';
import 'features/car_movement/screens/my_requests/my_car_movement_requests_list_screen.dart';
import 'features/car_movement/screens/my_requests/new_car_movement_request_screen.dart';
import 'features/employee_transfer/screens/employee_transfer_request_details_screen.dart';
import 'features/employee_transfer/screens/employee_transfer_requests_list_screen.dart';
import 'features/employee_transfer/screens/my_requests/my_employee_transfer_requests_list_screen.dart';
import 'features/employee_transfer/screens/my_requests/new_employee_transfer_request_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/purchases/screens/purchase_orders_list_screen.dart';

// --== شاشات جديدة ==--

// ---== إضافة imports شاشات "طلباتي" الجديدة ==---
import 'features/resume_work/screens/my_requests/my_resume_work_requests_list_screen.dart';
import 'features/resume_work/screens/my_requests/new_resume_work_request_screen.dart';
import 'features/resume_work/screens/resume_work_request_details_screen.dart';
import 'features/resume_work/screens/resume_work_requests_list_screen.dart';
import 'features/salary_confirmation/screens/my_requests/my_salary_confirmation_requests_list_screen.dart';
import 'features/salary_confirmation/screens/my_requests/new_salary_confirmation_request_screen.dart';
import 'features/salary_confirmation/screens/salary_confirmation_request_details_screen.dart';
import 'features/salary_confirmation/screens/salary_confirmation_requests_list_screen.dart';
import 'features/vacations/screens/my_requests/my_vacation_requests_list_screen.dart';
import 'features/vacations/screens/my_requests/new_vacation_request_screen.dart';
import 'features/loans/screens/my_requests/my_loan_requests_list_screen.dart';
import 'features/loans/screens/my_requests/new_loan_request_screen.dart';
import 'features/resignations/screens/my_requests/my_resignation_requests_list_screen.dart';
import 'features/resignations/screens/my_requests/new_resignation_request_screen.dart';

import 'package:flutter_localizations/flutter_localizations.dart'; // <-- إضافة جديدة

import 'core/providers/locale_provider.dart';
import 'core/providers/band_items_provider.dart';
import 'l10n/app_localizations.dart';

//import 'navigation/app_router.dart'; // سننشئه لاحقًا

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => DailyTasksProvider()),
        ChangeNotifierProvider(create: (_) => TaskPermissionProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PurchaseProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(
          create: (_) => HrProvider(),
        ), // <-- الإضافة الجديدة
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => ManagementProvider()),

        ChangeNotifierProvider(create: (_) => BandItemsProvider()),
        ChangeNotifierProvider(
          create: (_) => RequestMaterialFromStoreProvider(),
        ),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            title: AppStrings.appName,
            debugShowCheckedModeBanner: false,
            locale: localeProvider.locale,
            supportedLocales: const [
              Locale('ar', ''), // Arabic
              Locale('en', ''), // English
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              primaryColor: AppColors.primaryColor,
              scaffoldBackgroundColor: AppColors.backgroundColor,
              fontFamily: 'Cairo', // الخط الافتراضي للتطبيق
              appBarTheme: const AppBarTheme(
                backgroundColor: AppColors.primaryColor,
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.white),
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primaryColor,
                  textStyle: const TextStyle(fontFamily: 'Cairo'),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: AppColors.hintColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: AppColors.primaryColor,
                    width: 2,
                  ),
                ),
                labelStyle: const TextStyle(
                  color: AppColors.textColor,
                  fontFamily: 'Cairo',
                ),
                hintStyle: const TextStyle(
                  color: AppColors.hintColor,
                  fontFamily: 'Cairo',
                ),
              ),
              colorScheme: ColorScheme.fromSwatch().copyWith(
                secondary: AppColors.accentColor,
              ),
            ),
            // initialRoute: LoginScreen.routeName, // يمكن استخدامه إذا لم يكن هناك منطق تحقق
            home: const AuthWrapper(),
            routes: {
              LoginScreen.routeName: (context) => const LoginScreen(),
              ProjectCategories.routeName: (context) =>
                  const ProjectCategories(),
              HomeScreen.routeName: (context) => const HomeScreen(),
              UserProfileScreen.routeName: (context) => UserProfileScreen(
                compEmpCode: ModalRoute.of(context)!.settings.arguments as int,
              ), // تعديل هذا إذا كنت تستخدم onGenerateRoute بشكل كامل
              PurchaseOrdersListScreen.routeName: (context) =>
                  const PurchaseOrdersListScreen(),
              PurchaseOrderDetailsScreen.routeName: (context) =>
                  const PurchaseOrderDetailsScreen(), // <--- أضف هذا السطر
              // Daily Tasks Screen
              DailyTasksScreen.routeName: (context) => const DailyTasksScreen(),
              // Task Details Screen
              TaskDetailsView.routeName: (context) => const TaskDetailsView(),
              // Project Details Screen
              ProjectDetailsView.routeName: (context) =>
                  const ProjectDetailsView(),
              NotificationsView.routeName: (context) => NotificationsView(
                projectId: ModalRoute.of(context)!.settings.arguments as int,
                partId: ModalRoute.of(context)!.settings.arguments as int,
                flowId: ModalRoute.of(context)!.settings.arguments as int,
                procId: ModalRoute.of(context)!.settings.arguments as int,
              ),
              DisplayNotificationsView.routeName: (context) =>
                  DisplayNotificationsView(
                    userCode: ModalRoute.of(context)!.settings.arguments as int,
                  ),
              ManagementView.routeName: (context) => const ManagementView(),
              TaskAndApprovalSelectionView.routeName: (context) =>
                  const TaskAndApprovalSelectionView(),
              TasksDataView.routeName: (context) => const TasksDataView(),
              AddTaskView.routeName: (context) => const AddTaskView(),
              ApprovalsView.routeName: (context) => const ApprovalsView(),
              ApprovalDetailView.routeName: (context) =>
                  ApprovalDetailView(
                    initialItem: ModalRoute.of(context)!.settings.arguments
                        as dynamic,
                  ),
              MngNotificationView.routeName: (context) =>
                  const MngNotificationView(),
              MngNotificationDetailsView.routeName: (context) {
                final String altKey =
                    ModalRoute.of(context)!.settings.arguments as String;
                return MngNotificationDetailsView(altKey: altKey);
              },
              MngPermissionsView.routeName: (context) =>
                  const MngPermissionsView(),
              MngDailyTasksView.routeName: (context) =>
                  const MngDailyTasksView(),
              // --== مسارات جديدة ==--
              VacationRequestsListScreen.routeName: (context) =>
                  const VacationRequestsListScreen(),
              VacationRequestDetailsScreen.routeName: (context) =>
                  const VacationRequestDetailsScreen(),
              PermissionRequestsListScreen.routeName: (context) =>
                  const PermissionRequestsListScreen(),
              PermissionRequestDetailsScreen.routeName: (context) =>
                  const PermissionRequestDetailsScreen(),
              LoanRequestsListScreen.routeName: (context) =>
                  const LoanRequestsListScreen(),
              LoanRequestDetailsScreen.routeName: (context) =>
                  const LoanRequestDetailsScreen(),
              ResignationRequestsListScreen.routeName: (context) =>
                  const ResignationRequestsListScreen(),
              ResignationRequestDetailsScreen.routeName: (context) =>
                  const ResignationRequestDetailsScreen(),

              ResumeWorkRequestsListScreen.routeName: (context) =>
                  const ResumeWorkRequestsListScreen(),
              ResumeWorkRequestDetailsScreen.routeName: (context) =>
                  const ResumeWorkRequestDetailsScreen(),

              EmployeeTransferRequestsListScreen.routeName: (context) =>
                  const EmployeeTransferRequestsListScreen(),
              EmployeeTransferRequestDetailsScreen.routeName: (context) =>
                  const EmployeeTransferRequestDetailsScreen(),

              CarMovementRequestsListScreen.routeName: (context) =>
                  const CarMovementRequestsListScreen(),
              CarMovementRequestDetailsScreen.routeName: (context) =>
                  const CarMovementRequestDetailsScreen(),

              SalaryConfirmationRequestsListScreen.routeName: (context) =>
                  const SalaryConfirmationRequestsListScreen(),
              SalaryConfirmationRequestDetailsScreen.routeName: (context) =>
                  const SalaryConfirmationRequestDetailsScreen(),

              CancelSalaryConfirmationRequestsListScreen.routeName: (context) =>
                  const CancelSalaryConfirmationRequestsListScreen(),
              CancelSalaryConfirmationRequestDetailsScreen.routeName:
                  (context) =>
                      const CancelSalaryConfirmationRequestDetailsScreen(),

              // --== مسارات "طلباتي" الجديدة ==--
              MyVacationRequestsListScreen.routeName: (context) =>
                  const MyVacationRequestsListScreen(),
              NewVacationRequestScreen.routeName: (context) =>
                  const NewVacationRequestScreen(),
              MyPermissionRequestsListScreen.routeName: (context) =>
                  const MyPermissionRequestsListScreen(),
              NewPermissionRequestScreen.routeName: (context) =>
                  const NewPermissionRequestScreen(),
              MyLoanRequestsListScreen.routeName: (context) =>
                  const MyLoanRequestsListScreen(),
              NewLoanRequestScreen.routeName: (context) =>
                  const NewLoanRequestScreen(),
              MyResignationRequestsListScreen.routeName: (context) =>
                  const MyResignationRequestsListScreen(),
              NewResignationRequestScreen.routeName: (context) =>
                  const NewResignationRequestScreen(),

              MyResumeWorkRequestsListScreen.routeName: (context) =>
                  const MyResumeWorkRequestsListScreen(),
              NewResumeWorkRequestScreen.routeName: (context) =>
                  const NewResumeWorkRequestScreen(),

              MyEmployeeTransferRequestsListScreen.routeName: (context) =>
                  const MyEmployeeTransferRequestsListScreen(),
              NewEmployeeTransferRequestScreen.routeName: (context) =>
                  const NewEmployeeTransferRequestScreen(),

              MyCarMovementRequestsListScreen.routeName: (context) =>
                  const MyCarMovementRequestsListScreen(),
              NewCarMovementRequestScreen.routeName: (context) =>
                  const NewCarMovementRequestScreen(),

              MySalaryConfirmationRequestsListScreen.routeName: (context) =>
                  const MySalaryConfirmationRequestsListScreen(),
              NewSalaryConfirmationRequestScreen.routeName: (context) =>
                  const NewSalaryConfirmationRequestScreen(),

              MyCancelSalaryConfirmationRequestsListScreen.routeName:
                  (context) =>
                      const MyCancelSalaryConfirmationRequestsListScreen(),
              NewCancelSalaryConfirmationRequestScreen.routeName: (context) =>
                  const NewCancelSalaryConfirmationRequestScreen(),

              // ---== مسارات الحضور والانصراف الجديدة ==---
              AttendanceMainScreen.routeName: (context) =>
                  const AttendanceMainScreen(),
              AttendanceMonthsListScreen.routeName: (context) =>
                  const AttendanceMonthsListScreen(),

              // ---== إضافة جديدة ==---
              CheckedAttendanceMonthsListScreen.routeName: (context) =>
                  const CheckedAttendanceMonthsListScreen(),
            },
            onGenerateRoute: (settings) {
              // استخدام onGenerateRoute لتمرير arguments
              if (settings.name == UserProfileScreen.routeName) {
                final compEmpCode =
                    settings.arguments as int; // تأكد من أنك تمرر int
                return MaterialPageRoute(
                  builder: (context) {
                    return UserProfileScreen(compEmpCode: compEmpCode);
                  },
                );
              }
              // يمكنك إضافة مسارات أخرى هنا إذا لزم الأمر
              return null; // دع routes العادية تتعامل مع الباقي
            },

            // يمكنك استخدام onGenerateRoute لإدارة المسارات بشكل أكثر ديناميكية
            // onGenerateRoute: AppRouter.generateRoute,
          );
        },
      ),
    );
  }
}
