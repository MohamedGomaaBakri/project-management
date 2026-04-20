import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get appName;

  /// No description provided for @loginTitle.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get loginTitle;

  /// No description provided for @userCodeHint.
  ///
  /// In ar, this message translates to:
  /// **'رقم المستخدم'**
  String get userCodeHint;

  /// No description provided for @passwordHint.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get passwordHint;

  /// No description provided for @login.
  ///
  /// In ar, this message translates to:
  /// **'دخول'**
  String get login;

  /// No description provided for @welcome.
  ///
  /// In ar, this message translates to:
  /// **'أهلاً بك'**
  String get welcome;

  /// No description provided for @services.
  ///
  /// In ar, this message translates to:
  /// **'الخدمات المتاحة'**
  String get services;

  /// No description provided for @purchases.
  ///
  /// In ar, this message translates to:
  /// **'المشتريات '**
  String get purchases;

  /// No description provided for @purchasesO.
  ///
  /// In ar, this message translates to:
  /// **'أوامر الشراء  '**
  String get purchasesO;

  /// No description provided for @purchasesR.
  ///
  /// In ar, this message translates to:
  /// **'طلبات الشراء  '**
  String get purchasesR;

  /// No description provided for @humanResources.
  ///
  /// In ar, this message translates to:
  /// **'طلباتي'**
  String get humanResources;

  /// No description provided for @custody.
  ///
  /// In ar, this message translates to:
  /// **'العهد'**
  String get custody;

  /// No description provided for @maintenance.
  ///
  /// In ar, this message translates to:
  /// **'الصيانة'**
  String get maintenance;

  /// No description provided for @about.
  ///
  /// In ar, this message translates to:
  /// **'حول التطبيق'**
  String get about;

  /// No description provided for @myProfile.
  ///
  /// In ar, this message translates to:
  /// **'الموافقة المطلوبة'**
  String get myProfile;

  /// No description provided for @logout.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get logout;

  /// No description provided for @personalInfo.
  ///
  /// In ar, this message translates to:
  /// **'المعلومات الشخصية'**
  String get personalInfo;

  /// No description provided for @jobInfo.
  ///
  /// In ar, this message translates to:
  /// **'المعلومات الوظيفية'**
  String get jobInfo;

  /// No description provided for @financialInfo.
  ///
  /// In ar, this message translates to:
  /// **'المعلومات المالية'**
  String get financialInfo;

  /// No description provided for @vacationInfo.
  ///
  /// In ar, this message translates to:
  /// **'طلبات الإجازات'**
  String get vacationInfo;

  /// No description provided for @loanInfo.
  ///
  /// In ar, this message translates to:
  /// **'طلبات السلف'**
  String get loanInfo;

  /// No description provided for @resignationInfo.
  ///
  /// In ar, this message translates to:
  /// **'طلبات الاستقالة'**
  String get resignationInfo;

  /// No description provided for @attendanceInfo.
  ///
  /// In ar, this message translates to:
  /// **'الحضور والانصراف'**
  String get attendanceInfo;

  /// No description provided for @ticketsInfo.
  ///
  /// In ar, this message translates to:
  /// **'معلومات تذاكر السفر'**
  String get ticketsInfo;

  /// No description provided for @department.
  ///
  /// In ar, this message translates to:
  /// **'الإدارة'**
  String get department;

  /// No description provided for @job.
  ///
  /// In ar, this message translates to:
  /// **'الوظيفة'**
  String get job;

  /// No description provided for @nationality.
  ///
  /// In ar, this message translates to:
  /// **'الجنسية'**
  String get nationality;

  /// No description provided for @gender.
  ///
  /// In ar, this message translates to:
  /// **'الجنس'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In ar, this message translates to:
  /// **'ذكر'**
  String get male;

  /// No description provided for @female.
  ///
  /// In ar, this message translates to:
  /// **'أنثى'**
  String get female;

  /// No description provided for @systemTitle.
  ///
  /// In ar, this message translates to:
  /// **'نظام إدارة المشاريع'**
  String get systemTitle;

  /// No description provided for @systemWelcomeMessage.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بك في نظام إدارة المشاريع'**
  String get systemWelcomeMessage;

  /// No description provided for @loginSuccessMessage.
  ///
  /// In ar, this message translates to:
  /// **'تم تسجيل الدخول بنجاح'**
  String get loginSuccessMessage;

  /// No description provided for @loginErrorMessage.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ في تسجيل الدخول. يرجى المحاولة مرة أخرى'**
  String get loginErrorMessage;

  /// No description provided for @continueButton.
  ///
  /// In ar, this message translates to:
  /// **'متابعة'**
  String get continueButton;

  /// No description provided for @forgotPassword.
  ///
  /// In ar, this message translates to:
  /// **'نسيت كلمة المرور؟'**
  String get forgotPassword;

  /// No description provided for @noAccountText.
  ///
  /// In ar, this message translates to:
  /// **'ليس لديك حساب؟'**
  String get noAccountText;

  /// No description provided for @signUpText.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل جديد'**
  String get signUpText;

  /// No description provided for @userCodeValidationError.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال رقم المستخدم'**
  String get userCodeValidationError;

  /// No description provided for @passwordValidationError.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال كلمة المرور'**
  String get passwordValidationError;

  /// No description provided for @passwordLengthError.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور قصيرة جداً'**
  String get passwordLengthError;

  /// No description provided for @profileDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الملف الشخصي'**
  String get profileDetails;

  /// No description provided for @basicInformation.
  ///
  /// In ar, this message translates to:
  /// **'المعلومات الأساسية'**
  String get basicInformation;

  /// No description provided for @employeeCode.
  ///
  /// In ar, this message translates to:
  /// **'كود الموظف (الشركة):'**
  String get employeeCode;

  /// No description provided for @employeeName.
  ///
  /// In ar, this message translates to:
  /// **'اسم الموظف:'**
  String get employeeName;

  /// No description provided for @jobTitle.
  ///
  /// In ar, this message translates to:
  /// **'المسمى الوظيفي:'**
  String get jobTitle;

  /// No description provided for @salaryAndAllowances.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الراتب والبدلات'**
  String get salaryAndAllowances;

  /// No description provided for @basicSalary.
  ///
  /// In ar, this message translates to:
  /// **'الراتب الأساسي:'**
  String get basicSalary;

  /// No description provided for @transportationAllowance.
  ///
  /// In ar, this message translates to:
  /// **'بدل النقل:'**
  String get transportationAllowance;

  /// No description provided for @workNatureAllowance.
  ///
  /// In ar, this message translates to:
  /// **'بدل طبيعة عمل:'**
  String get workNatureAllowance;

  /// No description provided for @foodAllowance.
  ///
  /// In ar, this message translates to:
  /// **'بدل طعام:'**
  String get foodAllowance;

  /// No description provided for @extra.
  ///
  /// In ar, this message translates to:
  /// **'إضافي:'**
  String get extra;

  /// No description provided for @otherAllowances.
  ///
  /// In ar, this message translates to:
  /// **'بدلات أخرى:'**
  String get otherAllowances;

  /// No description provided for @otherDeductions.
  ///
  /// In ar, this message translates to:
  /// **'خصومات أخرى:'**
  String get otherDeductions;

  /// No description provided for @allowance1.
  ///
  /// In ar, this message translates to:
  /// **'بدل 1:'**
  String get allowance1;

  /// No description provided for @allowance2.
  ///
  /// In ar, this message translates to:
  /// **'بدل 2:'**
  String get allowance2;

  /// No description provided for @allowance3.
  ///
  /// In ar, this message translates to:
  /// **'بدل 3:'**
  String get allowance3;

  /// No description provided for @housingInformation.
  ///
  /// In ar, this message translates to:
  /// **'معلومات السكن'**
  String get housingInformation;

  /// No description provided for @housingAllowanceMonths.
  ///
  /// In ar, this message translates to:
  /// **'شهور بدل السكن:'**
  String get housingAllowanceMonths;

  /// No description provided for @housingAllowanceAmount.
  ///
  /// In ar, this message translates to:
  /// **'مبلغ بدل السكن:'**
  String get housingAllowanceAmount;

  /// No description provided for @workScheduleAndVacation.
  ///
  /// In ar, this message translates to:
  /// **'معلومات الدوام والإجازات'**
  String get workScheduleAndVacation;

  /// No description provided for @normalWorkingDays.
  ///
  /// In ar, this message translates to:
  /// **'أيام الدوام العادية:'**
  String get normalWorkingDays;

  /// No description provided for @unauthorizedAbsenceDays.
  ///
  /// In ar, this message translates to:
  /// **'أيام الغياب غير المسموح بها:'**
  String get unauthorizedAbsenceDays;

  /// No description provided for @vacationEvery.
  ///
  /// In ar, this message translates to:
  /// **'إجازة كل (شهر/سنة):'**
  String get vacationEvery;

  /// No description provided for @travelTicketsInformation.
  ///
  /// In ar, this message translates to:
  /// **'معلومات تذاكر السفر'**
  String get travelTicketsInformation;

  /// No description provided for @ticketsAmount.
  ///
  /// In ar, this message translates to:
  /// **'مبلغ التذاكر:'**
  String get ticketsAmount;

  /// No description provided for @ticketsEvery.
  ///
  /// In ar, this message translates to:
  /// **'تذاكر كل (شهر/سنة):'**
  String get ticketsEvery;

  /// No description provided for @ticketsType.
  ///
  /// In ar, this message translates to:
  /// **'نوع التذاكر:'**
  String get ticketsType;

  /// No description provided for @travelCity.
  ///
  /// In ar, this message translates to:
  /// **'مدينة السفر:'**
  String get travelCity;

  /// No description provided for @airline.
  ///
  /// In ar, this message translates to:
  /// **'شركة الطيران:'**
  String get airline;

  /// No description provided for @notAvailable.
  ///
  /// In ar, this message translates to:
  /// **'غير متوفر'**
  String get notAvailable;

  /// No description provided for @noUserDataFound.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم العثور على بيانات للمستخدم.'**
  String get noUserDataFound;

  /// No description provided for @invalidFormat.
  ///
  /// In ar, this message translates to:
  /// **'تنسيق غير صالح'**
  String get invalidFormat;

  /// No description provided for @underAction.
  ///
  /// In ar, this message translates to:
  /// **'قيد الإجراء'**
  String get underAction;

  /// No description provided for @notSpecified.
  ///
  /// In ar, this message translates to:
  /// **'غير محدد'**
  String get notSpecified;

  /// No description provided for @supplierName.
  ///
  /// In ar, this message translates to:
  /// **'اسم المورد'**
  String get supplierName;

  /// No description provided for @orderNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم الأمر'**
  String get orderNumber;

  /// No description provided for @orderDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الأمر'**
  String get orderDate;

  /// No description provided for @approved.
  ///
  /// In ar, this message translates to:
  /// **'معتمد'**
  String get approved;

  /// No description provided for @rejected.
  ///
  /// In ar, this message translates to:
  /// **'مرفوض'**
  String get rejected;

  /// No description provided for @orderDetailsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الأمر'**
  String get orderDetailsTitle;

  /// No description provided for @errorLoadingOrder.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في تحميل تفاصيل الأمر.'**
  String get errorLoadingOrder;

  /// No description provided for @approvals.
  ///
  /// In ar, this message translates to:
  /// **'الاعتمادات'**
  String get approvals;

  /// No description provided for @items.
  ///
  /// In ar, this message translates to:
  /// **'الأصناف'**
  String get items;

  /// No description provided for @orderNumberLabel.
  ///
  /// In ar, this message translates to:
  /// **'رقم الأمر:'**
  String get orderNumberLabel;

  /// No description provided for @orderDateLabel.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الأمر:'**
  String get orderDateLabel;

  /// No description provided for @supplierNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'اسم المورد:'**
  String get supplierNameLabel;

  /// No description provided for @totalOrderAmount.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي الكلي للأمر:'**
  String get totalOrderAmount;

  /// No description provided for @calculatingTotal.
  ///
  /// In ar, this message translates to:
  /// **'جاري حساب الإجمالي...'**
  String get calculatingTotal;

  /// No description provided for @takeAction.
  ///
  /// In ar, this message translates to:
  /// **'اتخاذ قرار'**
  String get takeAction;

  /// No description provided for @actionDialogTitle.
  ///
  /// In ar, this message translates to:
  /// **'اتخاذ قرار بشأن أمر الشراء'**
  String get actionDialogTitle;

  /// No description provided for @statementLabel.
  ///
  /// In ar, this message translates to:
  /// **'البيان (ملاحظات للإجراء الحالي)'**
  String get statementLabel;

  /// No description provided for @statementHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل ملاحظاتك هنا (اختياري)...'**
  String get statementHint;

  /// No description provided for @submittingAction.
  ///
  /// In ar, this message translates to:
  /// **'جاري إرسال الإجراء...'**
  String get submittingAction;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @reject.
  ///
  /// In ar, this message translates to:
  /// **'رفض'**
  String get reject;

  /// No description provided for @approve.
  ///
  /// In ar, this message translates to:
  /// **'اعتماد'**
  String get approve;

  /// No description provided for @actionErrorIncompleteData.
  ///
  /// In ar, this message translates to:
  /// **'خطأ: لا يمكن اتخاذ إجراء، البيانات غير مكتملة.'**
  String get actionErrorIncompleteData;

  /// No description provided for @waitForAuthDetails.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء الانتظار حتى يتم تحميل تفاصيل الاعتماد...'**
  String get waitForAuthDetails;

  /// No description provided for @approvalSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم الاعتماد بنجاح.'**
  String get approvalSuccess;

  /// No description provided for @rejectionSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم تسجيل الرفض بنجاح.'**
  String get rejectionSuccess;

  /// No description provided for @unexpectedError.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ غير متوقع.'**
  String get unexpectedError;

  /// No description provided for @errorLoadingApprovals.
  ///
  /// In ar, this message translates to:
  /// **'خطأ تحميل الاعتمادات:'**
  String get errorLoadingApprovals;

  /// No description provided for @noApprovalData.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بيانات اعتماد لهذا الأمر.'**
  String get noApprovalData;

  /// No description provided for @noRegisteredApprovals.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد اعتمادات مسجلة لهذا الأمر.'**
  String get noRegisteredApprovals;

  /// No description provided for @approvalChain.
  ///
  /// In ar, this message translates to:
  /// **'سلسلة الاعتمادات:'**
  String get approvalChain;

  /// No description provided for @unknownUser.
  ///
  /// In ar, this message translates to:
  /// **'غير معروف'**
  String get unknownUser;

  /// No description provided for @dateLabel.
  ///
  /// In ar, this message translates to:
  /// **'التاريخ:'**
  String get dateLabel;

  /// No description provided for @notesLabel.
  ///
  /// In ar, this message translates to:
  /// **'الملاحظات:'**
  String get notesLabel;

  /// No description provided for @authStatusPending.
  ///
  /// In ar, this message translates to:
  /// **'قيد الإجراء'**
  String get authStatusPending;

  /// No description provided for @authStatusApproved.
  ///
  /// In ar, this message translates to:
  /// **'معتمد'**
  String get authStatusApproved;

  /// No description provided for @authStatusRejected.
  ///
  /// In ar, this message translates to:
  /// **'مرفوض'**
  String get authStatusRejected;

  /// No description provided for @authStatusUndefined.
  ///
  /// In ar, this message translates to:
  /// **'غير محددة'**
  String get authStatusUndefined;

  /// No description provided for @errorLoadingServices.
  ///
  /// In ar, this message translates to:
  /// **'خطأ تحميل الخدمات:'**
  String get errorLoadingServices;

  /// No description provided for @noServiceData.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد خدمات لهذا الأمر.'**
  String get noServiceData;

  /// No description provided for @noRegisteredServices.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد خدمات مسجلة لهذا الأمر.'**
  String get noRegisteredServices;

  /// No description provided for @service.
  ///
  /// In ar, this message translates to:
  /// **'الخدمة'**
  String get service;

  /// No description provided for @unit.
  ///
  /// In ar, this message translates to:
  /// **'الوحدة'**
  String get unit;

  /// No description provided for @quantity.
  ///
  /// In ar, this message translates to:
  /// **'كمية'**
  String get quantity;

  /// No description provided for @cost.
  ///
  /// In ar, this message translates to:
  /// **'تكلفة'**
  String get cost;

  /// No description provided for @tax.
  ///
  /// In ar, this message translates to:
  /// **'ضريبة'**
  String get tax;

  /// No description provided for @total.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي'**
  String get total;

  /// No description provided for @errorLoadingItems.
  ///
  /// In ar, this message translates to:
  /// **'خطأ تحميل الأصناف:'**
  String get errorLoadingItems;

  /// No description provided for @noItemData.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد أصناف لهذا الأمر.'**
  String get noItemData;

  /// No description provided for @noRegisteredItems.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد أصناف مسجلة لهذا الأمر.'**
  String get noRegisteredItems;

  /// No description provided for @item.
  ///
  /// In ar, this message translates to:
  /// **'الصنف'**
  String get item;

  /// No description provided for @description.
  ///
  /// In ar, this message translates to:
  /// **'الشرح'**
  String get description;

  /// No description provided for @price.
  ///
  /// In ar, this message translates to:
  /// **'سعر'**
  String get price;

  /// No description provided for @purchaseOrdersTitle.
  ///
  /// In ar, this message translates to:
  /// **'أوامر الشراء'**
  String get purchaseOrdersTitle;

  /// No description provided for @retry.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get retry;

  /// No description provided for @noPurchaseOrders.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد أوامر شراء حاليًا.'**
  String get noPurchaseOrders;

  /// No description provided for @refresh.
  ///
  /// In ar, this message translates to:
  /// **'تحديث'**
  String get refresh;

  /// No description provided for @vacationRequestsTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلبات الإجازة'**
  String get vacationRequestsTitle;

  /// No description provided for @noVacationRequests.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبات إجازة حالياً.'**
  String get noVacationRequests;

  /// No description provided for @vacationRequestDetailsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل طلب الإجازة'**
  String get vacationRequestDetailsTitle;

  /// No description provided for @noRequestSelected.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم تحديد الطلب.'**
  String get noRequestSelected;

  /// No description provided for @vacationActionDialogTitle.
  ///
  /// In ar, this message translates to:
  /// **'اتخاذ قرار بشأن طلب الإجازة'**
  String get vacationActionDialogTitle;

  /// No description provided for @anErrorOccurred.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ'**
  String get anErrorOccurred;

  /// No description provided for @requestFor.
  ///
  /// In ar, this message translates to:
  /// **'طلب  لـ: {employeeName}'**
  String requestFor(Object employeeName);

  /// No description provided for @vacationTypeLabel.
  ///
  /// In ar, this message translates to:
  /// **'نوع الإجازة:'**
  String get vacationTypeLabel;

  /// No description provided for @startDateLabel.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ البداية:'**
  String get startDateLabel;

  /// No description provided for @endDateLabel.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ النهاية:'**
  String get endDateLabel;

  /// No description provided for @durationLabel.
  ///
  /// In ar, this message translates to:
  /// **'المدة:'**
  String get durationLabel;

  /// No description provided for @daysUnit.
  ///
  /// In ar, this message translates to:
  /// **'أيام'**
  String get daysUnit;

  /// No description provided for @noRegisteredApprovalsForRequest.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد اعتمادات مسجلة لهذا الطلب.'**
  String get noRegisteredApprovalsForRequest;

  /// No description provided for @myVacationRequestsTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلبات الإجازة الخاصة بي'**
  String get myVacationRequestsTitle;

  /// No description provided for @newRequest.
  ///
  /// In ar, this message translates to:
  /// **'طلب جديد'**
  String get newRequest;

  /// No description provided for @newVacationRequestTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلب إجازة جديد'**
  String get newVacationRequestTitle;

  /// No description provided for @requestData.
  ///
  /// In ar, this message translates to:
  /// **'بيانات الطلب'**
  String get requestData;

  /// No description provided for @vacationType.
  ///
  /// In ar, this message translates to:
  /// **'نوع الإجازة'**
  String get vacationType;

  /// No description provided for @vacationTypeAnnual.
  ///
  /// In ar, this message translates to:
  /// **'سنوية'**
  String get vacationTypeAnnual;

  /// No description provided for @vacationTypeRegular.
  ///
  /// In ar, this message translates to:
  /// **'عادية'**
  String get vacationTypeRegular;

  /// No description provided for @vacationTypeUnpaid.
  ///
  /// In ar, this message translates to:
  /// **'بدون مرتب'**
  String get vacationTypeUnpaid;

  /// No description provided for @vacationStartDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ بداية الإجازة'**
  String get vacationStartDate;

  /// No description provided for @vacationEndDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ نهاية الإجازة'**
  String get vacationEndDate;

  /// No description provided for @durationInDays.
  ///
  /// In ar, this message translates to:
  /// **'المدة (أيام)'**
  String get durationInDays;

  /// No description provided for @notes.
  ///
  /// In ar, this message translates to:
  /// **'الملاحظات'**
  String get notes;

  /// No description provided for @saving.
  ///
  /// In ar, this message translates to:
  /// **'جاري الحفظ...'**
  String get saving;

  /// No description provided for @saveRequest.
  ///
  /// In ar, this message translates to:
  /// **'حفظ الطلب'**
  String get saveRequest;

  /// No description provided for @selectVacationTypeValidation.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء اختيار نوع الإجازة'**
  String get selectVacationTypeValidation;

  /// No description provided for @selectDate.
  ///
  /// In ar, this message translates to:
  /// **'اختر تاريخ'**
  String get selectDate;

  /// No description provided for @selectDateValidation.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء اختيار التاريخ'**
  String get selectDateValidation;

  /// No description provided for @requestSentSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال الطلب بنجاح.'**
  String get requestSentSuccessfully;

  /// No description provided for @vacationRequest.
  ///
  /// In ar, this message translates to:
  /// **'طلب إجازة'**
  String get vacationRequest;

  /// No description provided for @from.
  ///
  /// In ar, this message translates to:
  /// **'من:'**
  String get from;

  /// No description provided for @to.
  ///
  /// In ar, this message translates to:
  /// **'إلى:'**
  String get to;

  /// No description provided for @requestDateLabel.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الطلب:'**
  String get requestDateLabel;

  /// No description provided for @requestDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الطلب'**
  String get requestDetails;

  /// No description provided for @close.
  ///
  /// In ar, this message translates to:
  /// **'إغلاق'**
  String get close;

  /// No description provided for @requestInfo.
  ///
  /// In ar, this message translates to:
  /// **'معلومات الطلب'**
  String get requestInfo;

  /// No description provided for @fromDate.
  ///
  /// In ar, this message translates to:
  /// **'من تاريخ'**
  String get fromDate;

  /// No description provided for @toDate.
  ///
  /// In ar, this message translates to:
  /// **'إلى تاريخ'**
  String get toDate;

  /// No description provided for @loanRequestsTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلبات السلف'**
  String get loanRequestsTitle;

  /// No description provided for @noLoanRequests.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبات سلف حالياً.'**
  String get noLoanRequests;

  /// No description provided for @loanRequestDetailsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل طلب السلفة'**
  String get loanRequestDetailsTitle;

  /// No description provided for @loanActionDialogTitle.
  ///
  /// In ar, this message translates to:
  /// **'اتخاذ قرار بشأن طلب السلفة'**
  String get loanActionDialogTitle;

  /// No description provided for @requestForLoan.
  ///
  /// In ar, this message translates to:
  /// **'طلب سلفة لـ: {employeeName}'**
  String requestForLoan(Object employeeName);

  /// No description provided for @loanTypeLabel.
  ///
  /// In ar, this message translates to:
  /// **'نوع السلفة:'**
  String get loanTypeLabel;

  /// No description provided for @descriptionLabel.
  ///
  /// In ar, this message translates to:
  /// **'الوصف:'**
  String get descriptionLabel;

  /// No description provided for @loanStartDateLabel.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ البدء:'**
  String get loanStartDateLabel;

  /// No description provided for @myLoanRequestsTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلبات السلف الخاصة بي'**
  String get myLoanRequestsTitle;

  /// No description provided for @newLoanRequestTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلب سلفة جديد'**
  String get newLoanRequestTitle;

  /// No description provided for @loanType.
  ///
  /// In ar, this message translates to:
  /// **'نوع السلفة'**
  String get loanType;

  /// No description provided for @totalLoanAmount.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي السلفة'**
  String get totalLoanAmount;

  /// No description provided for @installmentsCount.
  ///
  /// In ar, this message translates to:
  /// **'عدد الأقساط'**
  String get installmentsCount;

  /// No description provided for @installmentValue.
  ///
  /// In ar, this message translates to:
  /// **'قيمة القسط'**
  String get installmentValue;

  /// No description provided for @repaymentStartDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ بداية السداد'**
  String get repaymentStartDate;

  /// No description provided for @selectLoanTypeValidation.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء اختيار نوع السلفة'**
  String get selectLoanTypeValidation;

  /// No description provided for @fieldRequiredValidation.
  ///
  /// In ar, this message translates to:
  /// **'هذا الحقل مطلوب'**
  String get fieldRequiredValidation;

  /// No description provided for @loanRequestSentSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال الطلب بنجاح.'**
  String get loanRequestSentSuccessfully;

  /// No description provided for @loanRequest.
  ///
  /// In ar, this message translates to:
  /// **'طلب سلفة'**
  String get loanRequest;

  /// No description provided for @loanValueLabel.
  ///
  /// In ar, this message translates to:
  /// **'قيمة السلفة:'**
  String get loanValueLabel;

  /// No description provided for @installmentValueLabel.
  ///
  /// In ar, this message translates to:
  /// **'قيمة القسط:'**
  String get installmentValueLabel;

  /// No description provided for @installmentsCountLabel.
  ///
  /// In ar, this message translates to:
  /// **'عدد الأقساط:'**
  String get installmentsCountLabel;

  /// No description provided for @repaymentDateLabel.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ السداد:'**
  String get repaymentDateLabel;

  /// No description provided for @resignationRequestsTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلبات الاستقالة'**
  String get resignationRequestsTitle;

  /// No description provided for @noResignationRequests.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبات استقالة حالياً.'**
  String get noResignationRequests;

  /// No description provided for @resignationRequestDetailsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل طلب الاستقالة'**
  String get resignationRequestDetailsTitle;

  /// No description provided for @resignationActionDialogTitle.
  ///
  /// In ar, this message translates to:
  /// **'اتخاذ قرار بشأن طلب الاستقالة'**
  String get resignationActionDialogTitle;

  /// No description provided for @requestForResignation.
  ///
  /// In ar, this message translates to:
  /// **'طلب استقالة لـ: {employeeName}'**
  String requestForResignation(Object employeeName);

  /// No description provided for @serviceEndDateLabel.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ نهاية الخدمة:'**
  String get serviceEndDateLabel;

  /// No description provided for @lastWorkDayLabel.
  ///
  /// In ar, this message translates to:
  /// **'آخر يوم عمل:'**
  String get lastWorkDayLabel;

  /// No description provided for @reasonsLabel.
  ///
  /// In ar, this message translates to:
  /// **'السبب'**
  String get reasonsLabel;

  /// No description provided for @myResignationRequestsTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلبات الاستقالة الخاصة بي'**
  String get myResignationRequestsTitle;

  /// No description provided for @newResignationRequestTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلب استقالة جديد'**
  String get newResignationRequestTitle;

  /// No description provided for @resignationEndDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ نهاية العمل (الاستقالة)'**
  String get resignationEndDate;

  /// No description provided for @lastWorkDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ آخر يوم عمل'**
  String get lastWorkDate;

  /// No description provided for @reasonsForLeaving.
  ///
  /// In ar, this message translates to:
  /// **'أسباب ترك العمل'**
  String get reasonsForLeaving;

  /// No description provided for @resignationRequest.
  ///
  /// In ar, this message translates to:
  /// **'طلب استقالة'**
  String get resignationRequest;

  /// No description provided for @resignationDateLabel.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الاستقالة:'**
  String get resignationDateLabel;

  /// No description provided for @resignationRequestSentSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال طلب الاستقالة بنجاح.'**
  String get resignationRequestSentSuccessfully;

  /// No description provided for @attendanceAndDeparture.
  ///
  /// In ar, this message translates to:
  /// **'الحضور والإنصراف'**
  String get attendanceAndDeparture;

  /// No description provided for @newRecord.
  ///
  /// In ar, this message translates to:
  /// **'جديد'**
  String get newRecord;

  /// No description provided for @checkIn.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل حضور'**
  String get checkIn;

  /// No description provided for @checkOut.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل انصراف'**
  String get checkOut;

  /// No description provided for @newRecordDialogTitle.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل جديد'**
  String get newRecordDialogTitle;

  /// No description provided for @ok.
  ///
  /// In ar, this message translates to:
  /// **'موافق'**
  String get ok;

  /// No description provided for @checkInSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم تسجيل الحضور بنجاح.'**
  String get checkInSuccess;

  /// No description provided for @checkOutSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم تسجيل الانصراف بنجاح.'**
  String get checkOutSuccess;

  /// No description provided for @errorOccurred.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ'**
  String get errorOccurred;

  /// No description provided for @attendanceLog.
  ///
  /// In ar, this message translates to:
  /// **'سجل الحضور'**
  String get attendanceLog;

  /// No description provided for @viewMonthlyLog.
  ///
  /// In ar, this message translates to:
  /// **'عرض سجل الحضور والانصراف الشهري'**
  String get viewMonthlyLog;

  /// No description provided for @checkedAttendance.
  ///
  /// In ar, this message translates to:
  /// **'الحضور الذي تم التحقق منه'**
  String get checkedAttendance;

  /// No description provided for @viewCheckedLog.
  ///
  /// In ar, this message translates to:
  /// **'عرض كشف الحضور بعد المراجعة'**
  String get viewCheckedLog;

  /// No description provided for @attendanceLogTitle.
  ///
  /// In ar, this message translates to:
  /// **'سجل الحضور'**
  String get attendanceLogTitle;

  /// No description provided for @noAttendanceLogAvailable.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد سجل حضور متاح.'**
  String get noAttendanceLogAvailable;

  /// No description provided for @detailsLinkNotAvailable.
  ///
  /// In ar, this message translates to:
  /// **'رابط التفاصيل غير متاح لهذا الشهر.'**
  String get detailsLinkNotAvailable;

  /// No description provided for @noDataForThisMonth.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بيانات حضور لهذا الشهر.'**
  String get noDataForThisMonth;

  /// No description provided for @noRecordsForThisDay.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد سجلات لهذا اليوم.'**
  String get noRecordsForThisDay;

  /// No description provided for @checkInLabel.
  ///
  /// In ar, this message translates to:
  /// **'دخول:'**
  String get checkInLabel;

  /// No description provided for @checkOutLabel.
  ///
  /// In ar, this message translates to:
  /// **'خروج:'**
  String get checkOutLabel;

  /// No description provided for @checkedAttendanceLogTitle.
  ///
  /// In ar, this message translates to:
  /// **'كشف الحضور المعتمد'**
  String get checkedAttendanceLogTitle;

  /// No description provided for @noCheckedLogAvailable.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد كشوفات معتمدة متاحة.'**
  String get noCheckedLogAvailable;

  /// No description provided for @noDetailsForThisSheet.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد تفاصيل لهذا الكشف.'**
  String get noDetailsForThisSheet;

  /// No description provided for @date.
  ///
  /// In ar, this message translates to:
  /// **'التاريخ'**
  String get date;

  /// No description provided for @day.
  ///
  /// In ar, this message translates to:
  /// **'اليوم'**
  String get day;

  /// No description provided for @entry.
  ///
  /// In ar, this message translates to:
  /// **'الدخول'**
  String get entry;

  /// No description provided for @exit.
  ///
  /// In ar, this message translates to:
  /// **'الخروج'**
  String get exit;

  /// No description provided for @delayInMinutes.
  ///
  /// In ar, this message translates to:
  /// **'التأخير(د)'**
  String get delayInMinutes;

  /// No description provided for @status.
  ///
  /// In ar, this message translates to:
  /// **'الحالة'**
  String get status;

  /// No description provided for @weekend.
  ///
  /// In ar, this message translates to:
  /// **'نهاية أسبوع'**
  String get weekend;

  /// No description provided for @absence.
  ///
  /// In ar, this message translates to:
  /// **'غياب'**
  String get absence;

  /// No description provided for @vacation.
  ///
  /// In ar, this message translates to:
  /// **'إجازة'**
  String get vacation;

  /// No description provided for @permissionInfo.
  ///
  /// In ar, this message translates to:
  /// **'طلبات الأذونات'**
  String get permissionInfo;

  /// No description provided for @noPermissionRequests.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبات أذونات حالياً.'**
  String get noPermissionRequests;

  /// No description provided for @newPermissionRequest.
  ///
  /// In ar, this message translates to:
  /// **'طلب إذن جديد'**
  String get newPermissionRequest;

  /// No description provided for @permissionRequestDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل طلب الإذن'**
  String get permissionRequestDetails;

  /// No description provided for @permissionTypeLabel.
  ///
  /// In ar, this message translates to:
  /// **'نوع الإذن'**
  String get permissionTypeLabel;

  /// No description provided for @reasonTypeLabel.
  ///
  /// In ar, this message translates to:
  /// **'نوع السبب'**
  String get reasonTypeLabel;

  /// No description provided for @permissionDateLabel.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الإذن'**
  String get permissionDateLabel;

  /// No description provided for @fromTimeLabel.
  ///
  /// In ar, this message translates to:
  /// **'من وقت'**
  String get fromTimeLabel;

  /// No description provided for @toTimeLabel.
  ///
  /// In ar, this message translates to:
  /// **'إلى وقت'**
  String get toTimeLabel;

  /// No description provided for @permissionTimeLabel.
  ///
  /// In ar, this message translates to:
  /// **'الوقت'**
  String get permissionTimeLabel;

  /// No description provided for @selectPermissionTypeValidation.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء اختيار نوع الإذن'**
  String get selectPermissionTypeValidation;

  /// No description provided for @selectReasonTypeValidation.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء اختيار نوع السبب'**
  String get selectReasonTypeValidation;

  /// No description provided for @selectPermissionDateValidation.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء اختيار تاريخ الإذن'**
  String get selectPermissionDateValidation;

  /// No description provided for @selectFromTimeValidation.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء اختيار وقت البدء'**
  String get selectFromTimeValidation;

  /// No description provided for @selectToTimeValidation.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء اختيار وقت الانتهاء'**
  String get selectToTimeValidation;

  /// No description provided for @permissionRequestSentSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال طلب الإذن بنجاح.'**
  String get permissionRequestSentSuccessfully;

  /// No description provided for @timeValidationError.
  ///
  /// In ar, this message translates to:
  /// **'وقت النهاية يجب أن يكون بعد وقت البداية.'**
  String get timeValidationError;

  /// No description provided for @permissionType1.
  ///
  /// In ar, this message translates to:
  /// **'استئذان'**
  String get permissionType1;

  /// No description provided for @permissionType2.
  ///
  /// In ar, this message translates to:
  /// **'نسيان بصمة حضور'**
  String get permissionType2;

  /// No description provided for @permissionType3.
  ///
  /// In ar, this message translates to:
  /// **'نسيان بصمة انصراف'**
  String get permissionType3;

  /// No description provided for @permissionType4.
  ///
  /// In ar, this message translates to:
  /// **'مهمة عمل خارجي'**
  String get permissionType4;

  /// No description provided for @reasonType1.
  ///
  /// In ar, this message translates to:
  /// **'خاصة'**
  String get reasonType1;

  /// No description provided for @reasonType2.
  ///
  /// In ar, this message translates to:
  /// **'طارئة'**
  String get reasonType2;

  /// No description provided for @reasonType3.
  ///
  /// In ar, this message translates to:
  /// **'اخري'**
  String get reasonType3;

  /// No description provided for @actionSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم الإجراء بنجاح'**
  String get actionSuccess;

  /// No description provided for @actionFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل تنفيذ الإجراء'**
  String get actionFailed;

  /// No description provided for @notesOptional.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات (اختياري)'**
  String get notesOptional;

  /// No description provided for @noDataAvailable.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بيانات'**
  String get noDataAvailable;

  /// No description provided for @sendRequest.
  ///
  /// In ar, this message translates to:
  /// **'إرسال الطلب'**
  String get sendRequest;

  /// No description provided for @selectTime.
  ///
  /// In ar, this message translates to:
  /// **'اختر الوقت'**
  String get selectTime;

  /// No description provided for @resumeWorkInfo.
  ///
  /// In ar, this message translates to:
  /// **'طلبات مباشرة العمل'**
  String get resumeWorkInfo;

  /// No description provided for @noResumeWorkRequests.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبات مباشرة عمل حالياً.'**
  String get noResumeWorkRequests;

  /// No description provided for @newResumeWorkRequest.
  ///
  /// In ar, this message translates to:
  /// **'طلب مباشرة عمل جديد'**
  String get newResumeWorkRequest;

  /// No description provided for @resumeWorkRequestDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل طلب مباشرة العمل'**
  String get resumeWorkRequestDetails;

  /// No description provided for @resumeWorkDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ مباشرة العمل'**
  String get resumeWorkDate;

  /// No description provided for @delayReason.
  ///
  /// In ar, this message translates to:
  /// **'سبب التأخير'**
  String get delayReason;

  /// No description provided for @selectStartDate.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء اختيار تاريخ بدء الإجازة'**
  String get selectStartDate;

  /// No description provided for @selectEndDate.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء اختيار تاريخ نهاية الإجازة'**
  String get selectEndDate;

  /// No description provided for @selectResumeDate.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء اختيار تاريخ مباشرة العمل'**
  String get selectResumeDate;

  /// No description provided for @resumeWorkRequestSentSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال طلب مباشرة العمل بنجاح.'**
  String get resumeWorkRequestSentSuccessfully;

  /// No description provided for @endDateAfterStartDateError.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ النهاية يجب أن يكون بعد تاريخ البدء.'**
  String get endDateAfterStartDateError;

  /// No description provided for @resumeDateAfterStartDateError.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ المباشرة يجب أن يكون بعد تاريخ بدء الإجازة.'**
  String get resumeDateAfterStartDateError;

  /// No description provided for @componyCode.
  ///
  /// In ar, this message translates to:
  /// **'كود الشركة'**
  String get componyCode;

  /// No description provided for @dCode.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهيكل الإداري'**
  String get dCode;

  /// No description provided for @resumeWorkActionDialogTitle.
  ///
  /// In ar, this message translates to:
  /// **'اتخاذ قرار بشأن مباشرة العمل'**
  String get resumeWorkActionDialogTitle;

  /// No description provided for @employeeTransferInfo.
  ///
  /// In ar, this message translates to:
  /// **'طلبات نقل موظف'**
  String get employeeTransferInfo;

  /// No description provided for @noEmployeeTransferRequests.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبات نقل حالياً.'**
  String get noEmployeeTransferRequests;

  /// No description provided for @newEmployeeTransferRequest.
  ///
  /// In ar, this message translates to:
  /// **'طلب نقل جديد'**
  String get newEmployeeTransferRequest;

  /// No description provided for @employeeTransferRequestDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل طلب النقل'**
  String get employeeTransferRequestDetails;

  /// No description provided for @transferDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ النقل'**
  String get transferDate;

  /// No description provided for @newCompanyCode.
  ///
  /// In ar, this message translates to:
  /// **'كود الشركة الجديد'**
  String get newCompanyCode;

  /// No description provided for @newDCode.
  ///
  /// In ar, this message translates to:
  /// **'كود الإدارة الجديد'**
  String get newDCode;

  /// No description provided for @newManagerCode.
  ///
  /// In ar, this message translates to:
  /// **'كود المدير الجديد'**
  String get newManagerCode;

  /// No description provided for @transferNotesAr.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات النقل (عربي)'**
  String get transferNotesAr;

  /// No description provided for @transferNotesEn.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات النقل (إنجليزي)'**
  String get transferNotesEn;

  /// No description provided for @selectTransferDate.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء اختيار تاريخ النقل'**
  String get selectTransferDate;

  /// No description provided for @employeeTransferRequestSentSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال طلب النقل بنجاح.'**
  String get employeeTransferRequestSentSuccessfully;

  /// No description provided for @numericFieldsError.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال أرقام صحيحة في حقول الأكواد.'**
  String get numericFieldsError;

  /// No description provided for @fieldRequired.
  ///
  /// In ar, this message translates to:
  /// **'هذا الحقل مطلوب'**
  String get fieldRequired;

  /// No description provided for @employeeTransferActionDialogTitle.
  ///
  /// In ar, this message translates to:
  /// **'اتخاذ قرار بشأن نقل الموظف'**
  String get employeeTransferActionDialogTitle;

  /// No description provided for @selectCompany.
  ///
  /// In ar, this message translates to:
  /// **'اختر الشركة'**
  String get selectCompany;

  /// No description provided for @selectDepartment.
  ///
  /// In ar, this message translates to:
  /// **'اختر الإدارة'**
  String get selectDepartment;

  /// No description provided for @carMovementInfo.
  ///
  /// In ar, this message translates to:
  /// **'طلبات تحريك سيارة'**
  String get carMovementInfo;

  /// No description provided for @noCarMovementRequests.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبات تحريك سيارة حالياً.'**
  String get noCarMovementRequests;

  /// No description provided for @newCarMovementRequest.
  ///
  /// In ar, this message translates to:
  /// **'طلب تحريك سيارة جديد'**
  String get newCarMovementRequest;

  /// No description provided for @carMovementRequestDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل طلب تحريك السيارة'**
  String get carMovementRequestDetails;

  /// No description provided for @carNoLabel.
  ///
  /// In ar, this message translates to:
  /// **'رقم السيارة'**
  String get carNoLabel;

  /// No description provided for @selectCarNoValidation.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال رقم السيارة'**
  String get selectCarNoValidation;

  /// No description provided for @carMovementRequestSentSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال طلب تحريك السيارة بنجاح.'**
  String get carMovementRequestSentSuccessfully;

  /// No description provided for @carMovementTimeLabel.
  ///
  /// In ar, this message translates to:
  /// **'وقت التحرك'**
  String get carMovementTimeLabel;

  /// No description provided for @carMovementDateLabel.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ التحرك'**
  String get carMovementDateLabel;

  /// No description provided for @selectCarMovementDateValidation.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء اختيار تاريخ التحرك'**
  String get selectCarMovementDateValidation;

  /// No description provided for @carMovementActionDialogTitle.
  ///
  /// In ar, this message translates to:
  /// **'اتخاذ قرار بشأن تحريك سيارة'**
  String get carMovementActionDialogTitle;

  /// No description provided for @salaryConfirmationInfo.
  ///
  /// In ar, this message translates to:
  /// **'طلبات تثبيت راتب'**
  String get salaryConfirmationInfo;

  /// No description provided for @noSalaryConfirmationRequests.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبات تثبيت راتب حالياً.'**
  String get noSalaryConfirmationRequests;

  /// No description provided for @newSalaryConfirmationRequest.
  ///
  /// In ar, this message translates to:
  /// **'طلب تثبيت راتب جديد'**
  String get newSalaryConfirmationRequest;

  /// No description provided for @salaryConfirmationRequestDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل طلب تثبيت الراتب'**
  String get salaryConfirmationRequestDetails;

  /// No description provided for @dCodeHint.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهيكل الإداري'**
  String get dCodeHint;

  /// No description provided for @selectRequestDate.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء اختيار تاريخ الطلب'**
  String get selectRequestDate;

  /// No description provided for @selectDCodeValidation.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال رقم الهيكل الإداري'**
  String get selectDCodeValidation;

  /// No description provided for @salaryConfirmationRequestSentSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال طلب تثبيت الراتب بنجاح.'**
  String get salaryConfirmationRequestSentSuccessfully;

  /// No description provided for @salaryConfirmationActionDialogTitle.
  ///
  /// In ar, this message translates to:
  /// **'اتخاذ قرار بشأن تثبيت الراتب'**
  String get salaryConfirmationActionDialogTitle;

  /// No description provided for @cancelSalaryConfirmationInfo.
  ///
  /// In ar, this message translates to:
  /// **'طلبات إلغاء تثبيت راتب'**
  String get cancelSalaryConfirmationInfo;

  /// No description provided for @noCancelSalaryConfirmationRequests.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبات إلغاء تثبيت راتب حالياً.'**
  String get noCancelSalaryConfirmationRequests;

  /// No description provided for @newCancelSalaryConfirmationRequest.
  ///
  /// In ar, this message translates to:
  /// **'طلب إلغاء تثبيت راتب جديد'**
  String get newCancelSalaryConfirmationRequest;

  /// No description provided for @cancelSalaryConfirmationRequestDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل طلب إلغاء تثبيت الراتب'**
  String get cancelSalaryConfirmationRequestDetails;

  /// No description provided for @cancelSalaryConfirmationRequestSentSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال طلب إلغاء تثبيت الراتب بنجاح.'**
  String get cancelSalaryConfirmationRequestSentSuccessfully;

  /// No description provided for @cancelSalaryConfirmationActionDialogTitle.
  ///
  /// In ar, this message translates to:
  /// **'اتخاذ قرار بشأن إلغاء تثبيت الراتب'**
  String get cancelSalaryConfirmationActionDialogTitle;

  /// No description provided for @requestForMyself.
  ///
  /// In ar, this message translates to:
  /// **'طلب لنفسي'**
  String get requestForMyself;

  /// No description provided for @requestForWorker.
  ///
  /// In ar, this message translates to:
  /// **'طلب لموظف اخر'**
  String get requestForWorker;

  /// No description provided for @workerName.
  ///
  /// In ar, this message translates to:
  /// **'اسم الموظف'**
  String get workerName;

  /// No description provided for @workerNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم الموظف'**
  String get workerNumber;

  /// No description provided for @selectWorkerError.
  ///
  /// In ar, this message translates to:
  /// **'من فضلك اختر الموظف أولاً'**
  String get selectWorkerError;

  /// No description provided for @permissionType5.
  ///
  /// In ar, this message translates to:
  /// **'انتداب خارجي'**
  String get permissionType5;

  /// No description provided for @permissionEndDateLabel.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الانتهاء'**
  String get permissionEndDateLabel;

  /// No description provided for @selectPermissionEndDateValidation.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء اختيار تاريخ الانتهاء'**
  String get selectPermissionEndDateValidation;

  /// No description provided for @homeTitle.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get homeTitle;

  /// No description provided for @welcomeSelectModule.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بك، اختر النظام للمتابعة'**
  String get welcomeSelectModule;

  /// No description provided for @selfServicesModule.
  ///
  /// In ar, this message translates to:
  /// **'ادارة المشاريع'**
  String get selfServicesModule;

  /// No description provided for @selfServicesDesc.
  ///
  /// In ar, this message translates to:
  /// **'نظام ادارة المشاريع'**
  String get selfServicesDesc;

  /// No description provided for @workshopsModule.
  ///
  /// In ar, this message translates to:
  /// **'الورش والصيانة'**
  String get workshopsModule;

  /// No description provided for @workshopsDesc.
  ///
  /// In ar, this message translates to:
  /// **'إدارة الصيانة والمركبات'**
  String get workshopsDesc;

  /// No description provided for @comingSoon.
  ///
  /// In ar, this message translates to:
  /// **'قريباً...'**
  String get comingSoon;

  /// No description provided for @workOrderNo.
  ///
  /// In ar, this message translates to:
  /// **'رقم أمر العمل'**
  String get workOrderNo;

  /// No description provided for @reqNo.
  ///
  /// In ar, this message translates to:
  /// **'رقم الطلب'**
  String get reqNo;

  /// No description provided for @details.
  ///
  /// In ar, this message translates to:
  /// **'التفاصيل'**
  String get details;

  /// No description provided for @store.
  ///
  /// In ar, this message translates to:
  /// **'المستودع'**
  String get store;

  /// No description provided for @technician.
  ///
  /// In ar, this message translates to:
  /// **'الفني'**
  String get technician;

  /// No description provided for @authStatus.
  ///
  /// In ar, this message translates to:
  /// **'الاعتماد'**
  String get authStatus;

  /// No description provided for @orderType.
  ///
  /// In ar, this message translates to:
  /// **'نوع الأمر'**
  String get orderType;

  /// No description provided for @techNotes.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات الفني'**
  String get techNotes;

  /// No description provided for @contactMethod.
  ///
  /// In ar, this message translates to:
  /// **'طريقة الاستلام'**
  String get contactMethod;

  /// No description provided for @user.
  ///
  /// In ar, this message translates to:
  /// **'المستخدم'**
  String get user;

  /// No description provided for @entryDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الإدخال'**
  String get entryDate;

  /// No description provided for @equipments.
  ///
  /// In ar, this message translates to:
  /// **'المعدات'**
  String get equipments;

  /// No description provided for @viewEquipments.
  ///
  /// In ar, this message translates to:
  /// **'عرض المعدات'**
  String get viewEquipments;

  /// No description provided for @equipmentCode.
  ///
  /// In ar, this message translates to:
  /// **'كود المعدة'**
  String get equipmentCode;

  /// No description provided for @serialNo.
  ///
  /// In ar, this message translates to:
  /// **'المسلسل'**
  String get serialNo;

  /// No description provided for @equipmentNo.
  ///
  /// In ar, this message translates to:
  /// **'رقم المعدة'**
  String get equipmentNo;

  /// No description provided for @noData.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بيانات'**
  String get noData;

  /// No description provided for @loading.
  ///
  /// In ar, this message translates to:
  /// **'جار التحميل...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ'**
  String get error;

  /// No description provided for @workOrders.
  ///
  /// In ar, this message translates to:
  /// **'أمر'**
  String get workOrders;

  /// No description provided for @dailyTasks.
  ///
  /// In ar, this message translates to:
  /// **'المهام اليومية'**
  String get dailyTasks;

  /// No description provided for @dailyTasksDesc.
  ///
  /// In ar, this message translates to:
  /// **'إدارة المهام اليومية'**
  String get dailyTasksDesc;

  /// No description provided for @notifications.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get notifications;

  /// No description provided for @notificationsDesc.
  ///
  /// In ar, this message translates to:
  /// **'عرض الإشعارات والتنبيهات'**
  String get notificationsDesc;

  /// No description provided for @management.
  ///
  /// In ar, this message translates to:
  /// **'الإدارة'**
  String get management;

  /// No description provided for @managementDesc.
  ///
  /// In ar, this message translates to:
  /// **'الإدارة والإشراف'**
  String get managementDesc;

  /// No description provided for @workOrderQuotation.
  ///
  /// In ar, this message translates to:
  /// **'طلب مواد من المخزن'**
  String get workOrderQuotation;

  /// No description provided for @workOrderQuotationDesc.
  ///
  /// In ar, this message translates to:
  /// **'إدارة طلبات المواد من المخزن'**
  String get workOrderQuotationDesc;

  /// No description provided for @workOrderProjects.
  ///
  /// In ar, this message translates to:
  /// **'امر عمل مشاريع'**
  String get workOrderProjects;

  /// No description provided for @workOrderProjectsDesc.
  ///
  /// In ar, this message translates to:
  /// **'إدارة أوامر عمل المشاريع'**
  String get workOrderProjectsDesc;

  /// No description provided for @workOrderMaintenance.
  ///
  /// In ar, this message translates to:
  /// **'امر عمل صيانة'**
  String get workOrderMaintenance;

  /// No description provided for @workOrderMaintenanceDesc.
  ///
  /// In ar, this message translates to:
  /// **'إدارة أوامر عمل الصيانة'**
  String get workOrderMaintenanceDesc;

  /// No description provided for @selectCategory.
  ///
  /// In ar, this message translates to:
  /// **'اختر الفئة للمتابعة'**
  String get selectCategory;

  /// No description provided for @filterBy.
  ///
  /// In ar, this message translates to:
  /// **'بيانات الاستعلام'**
  String get filterBy;

  /// No description provided for @projectFilter.
  ///
  /// In ar, this message translates to:
  /// **'المشروع'**
  String get projectFilter;

  /// No description provided for @selectProject.
  ///
  /// In ar, this message translates to:
  /// **'اختر المشروع'**
  String get selectProject;

  /// No description provided for @contractNumber.
  ///
  /// In ar, this message translates to:
  /// **'الرقم الداخلى'**
  String get contractNumber;

  /// No description provided for @enterContractNumber.
  ///
  /// In ar, this message translates to:
  /// **'أدخل الرقم الداخلى'**
  String get enterContractNumber;

  /// No description provided for @secNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم SEC'**
  String get secNumber;

  /// No description provided for @enterSecNumber.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقم SEC'**
  String get enterSecNumber;

  /// No description provided for @statusFilter.
  ///
  /// In ar, this message translates to:
  /// **'الحالة'**
  String get statusFilter;

  /// No description provided for @notDoneOnly.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم فقط'**
  String get notDoneOnly;

  /// No description provided for @doneOnly.
  ///
  /// In ar, this message translates to:
  /// **'تم فقط'**
  String get doneOnly;

  /// No description provided for @allStatus.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get allStatus;

  /// No description provided for @search.
  ///
  /// In ar, this message translates to:
  /// **'بحث'**
  String get search;

  /// No description provided for @reset.
  ///
  /// In ar, this message translates to:
  /// **'إعادة تعيين'**
  String get reset;

  /// No description provided for @stage.
  ///
  /// In ar, this message translates to:
  /// **'المرحلة'**
  String get stage;

  /// No description provided for @operation.
  ///
  /// In ar, this message translates to:
  /// **'العملية'**
  String get operation;

  /// No description provided for @explanation.
  ///
  /// In ar, this message translates to:
  /// **'الشرح'**
  String get explanation;

  /// No description provided for @done.
  ///
  /// In ar, this message translates to:
  /// **'تم'**
  String get done;

  /// No description provided for @noTasksFound.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد مهام'**
  String get noTasksFound;

  /// No description provided for @loadingTasks.
  ///
  /// In ar, this message translates to:
  /// **'جار تحميل المهام...'**
  String get loadingTasks;

  /// No description provided for @dailyTasksTitle.
  ///
  /// In ar, this message translates to:
  /// **'المهام اليومية'**
  String get dailyTasksTitle;

  /// No description provided for @taskDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل المهمة'**
  String get taskDetails;

  /// No description provided for @taskDetailsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل المهمة'**
  String get taskDetailsTitle;

  /// No description provided for @projectName.
  ///
  /// In ar, this message translates to:
  /// **'اسم المشروع'**
  String get projectName;

  /// No description provided for @processName.
  ///
  /// In ar, this message translates to:
  /// **'اسم العملية'**
  String get processName;

  /// No description provided for @assignedEmployee.
  ///
  /// In ar, this message translates to:
  /// **'موظف المرحلة التالية'**
  String get assignedEmployee;

  /// No description provided for @selectEmployee.
  ///
  /// In ar, this message translates to:
  /// **'اختر الموظف'**
  String get selectEmployee;

  /// No description provided for @notesField.
  ///
  /// In ar, this message translates to:
  /// **'الملاحظات'**
  String get notesField;

  /// No description provided for @notesHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل الملاحظات هنا...'**
  String get notesHint;

  /// No description provided for @notificationReply.
  ///
  /// In ar, this message translates to:
  /// **'الرد على الإشعار'**
  String get notificationReply;

  /// No description provided for @notificationReplyHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل ردك هنا...'**
  String get notificationReplyHint;

  /// No description provided for @executeButton.
  ///
  /// In ar, this message translates to:
  /// **'تنفيذ'**
  String get executeButton;

  /// No description provided for @taskCompleted.
  ///
  /// In ar, this message translates to:
  /// **'تمت'**
  String get taskCompleted;

  /// No description provided for @taskNotCompleted.
  ///
  /// In ar, this message translates to:
  /// **'لم تتم'**
  String get taskNotCompleted;

  /// No description provided for @completionDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الإكمال'**
  String get completionDate;

  /// No description provided for @projectButton.
  ///
  /// In ar, this message translates to:
  /// **'المشروع'**
  String get projectButton;

  /// No description provided for @attachmentsButton.
  ///
  /// In ar, this message translates to:
  /// **'المرفقات'**
  String get attachmentsButton;

  /// No description provided for @permissionsButton.
  ///
  /// In ar, this message translates to:
  /// **'التصاريح'**
  String get permissionsButton;

  /// No description provided for @createNotificationButton.
  ///
  /// In ar, this message translates to:
  /// **'عمل إشعار'**
  String get createNotificationButton;

  /// No description provided for @taskInformation.
  ///
  /// In ar, this message translates to:
  /// **'معلومات المهمة'**
  String get taskInformation;

  /// No description provided for @taskActions.
  ///
  /// In ar, this message translates to:
  /// **'إجراءات المهمة'**
  String get taskActions;

  /// No description provided for @errorAttachmentsRequired.
  ///
  /// In ar, this message translates to:
  /// **'يجب إضافة المرفقات'**
  String get errorAttachmentsRequired;

  /// No description provided for @errorPermissionsRequired.
  ///
  /// In ar, this message translates to:
  /// **'يجب إضافة التصاريح'**
  String get errorPermissionsRequired;

  /// No description provided for @errorNotificationReplyRequired.
  ///
  /// In ar, this message translates to:
  /// **'يجب الرد على الإشعار'**
  String get errorNotificationReplyRequired;

  /// No description provided for @errorNotesRequired.
  ///
  /// In ar, this message translates to:
  /// **'يجب إدخال الملاحظات'**
  String get errorNotesRequired;

  /// No description provided for @errorEmployeeRequired.
  ///
  /// In ar, this message translates to:
  /// **'يجب إسناد موظف'**
  String get errorEmployeeRequired;

  /// No description provided for @validationError.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في التحقق'**
  String get validationError;

  /// No description provided for @checkingPermissions.
  ///
  /// In ar, this message translates to:
  /// **'جاري التحقق من الصلاحيات...'**
  String get checkingPermissions;

  /// No description provided for @noProjectPermission.
  ///
  /// In ar, this message translates to:
  /// **'ليس لديك صلاحية لعرض هذا المشروع'**
  String get noProjectPermission;

  /// No description provided for @projectDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل المشروع'**
  String get projectDetails;

  /// No description provided for @unifiedContractNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم العقد الموحد'**
  String get unifiedContractNumber;

  /// No description provided for @contractCode.
  ///
  /// In ar, this message translates to:
  /// **'كود العقد'**
  String get contractCode;

  /// No description provided for @projectNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم المشروع'**
  String get projectNumber;

  /// No description provided for @workOrderNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم أمر العمل'**
  String get workOrderNumber;

  /// No description provided for @duration.
  ///
  /// In ar, this message translates to:
  /// **'المدة'**
  String get duration;

  /// No description provided for @projectStatus.
  ///
  /// In ar, this message translates to:
  /// **'حالة المشروع'**
  String get projectStatus;

  /// No description provided for @assignmentAuthority.
  ///
  /// In ar, this message translates to:
  /// **'جهة الإسناد'**
  String get assignmentAuthority;

  /// No description provided for @supervisionAuthority.
  ///
  /// In ar, this message translates to:
  /// **'جهة الإشراف'**
  String get supervisionAuthority;

  /// No description provided for @client.
  ///
  /// In ar, this message translates to:
  /// **'العميل'**
  String get client;

  /// No description provided for @projectEngineer.
  ///
  /// In ar, this message translates to:
  /// **'مهندس المشروع'**
  String get projectEngineer;

  /// No description provided for @projectManager.
  ///
  /// In ar, this message translates to:
  /// **'مدير المشروع'**
  String get projectManager;

  /// No description provided for @projectsManager.
  ///
  /// In ar, this message translates to:
  /// **'مدير المشاريع'**
  String get projectsManager;

  /// No description provided for @projectValue.
  ///
  /// In ar, this message translates to:
  /// **'قيمة المشروع'**
  String get projectValue;

  /// No description provided for @basicInfo.
  ///
  /// In ar, this message translates to:
  /// **'المعلومات الأساسية'**
  String get basicInfo;

  /// No description provided for @projectTeam.
  ///
  /// In ar, this message translates to:
  /// **'فريق المشروع'**
  String get projectTeam;

  /// No description provided for @toggleLanguage.
  ///
  /// In ar, this message translates to:
  /// **'عربي/English'**
  String get toggleLanguage;

  /// No description provided for @days.
  ///
  /// In ar, this message translates to:
  /// **'يوم'**
  String get days;

  /// No description provided for @currency.
  ///
  /// In ar, this message translates to:
  /// **'ريال'**
  String get currency;

  /// No description provided for @taskPermissions.
  ///
  /// In ar, this message translates to:
  /// **'التصاريح'**
  String get taskPermissions;

  /// No description provided for @taskPermissionsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تصاريح المشروع'**
  String get taskPermissionsTitle;

  /// No description provided for @taskPermissionsDesc.
  ///
  /// In ar, this message translates to:
  /// **'إدارة التصاريح الخاصة بالمشاريع'**
  String get taskPermissionsDesc;

  /// No description provided for @permissionType.
  ///
  /// In ar, this message translates to:
  /// **'نوع التصريح'**
  String get permissionType;

  /// No description provided for @permissionNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم التصريح'**
  String get permissionNumber;

  /// No description provided for @permissionStatus.
  ///
  /// In ar, this message translates to:
  /// **'حالة التصريح'**
  String get permissionStatus;

  /// No description provided for @activeStatus.
  ///
  /// In ar, this message translates to:
  /// **'ساري'**
  String get activeStatus;

  /// No description provided for @expiredStatus.
  ///
  /// In ar, this message translates to:
  /// **'منتهي'**
  String get expiredStatus;

  /// No description provided for @projectInfo.
  ///
  /// In ar, this message translates to:
  /// **'بيانات المشروع'**
  String get projectInfo;

  /// No description provided for @projectNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'اسم المشروع'**
  String get projectNameLabel;

  /// No description provided for @contractNumberLabel.
  ///
  /// In ar, this message translates to:
  /// **'الرقم الداخلى'**
  String get contractNumberLabel;

  /// No description provided for @noPermissionsFound.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد تصاريح'**
  String get noPermissionsFound;

  /// No description provided for @loadingPermissions.
  ///
  /// In ar, this message translates to:
  /// **'جار تحميل التصاريح...'**
  String get loadingPermissions;

  /// No description provided for @newPermission.
  ///
  /// In ar, this message translates to:
  /// **'جديد'**
  String get newPermission;

  /// No description provided for @permissionDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل التصريح'**
  String get permissionDetails;

  /// No description provided for @permitSerial.
  ///
  /// In ar, this message translates to:
  /// **'مسلسل التصريح'**
  String get permitSerial;

  /// No description provided for @permitCopy.
  ///
  /// In ar, this message translates to:
  /// **'رقم النسخة'**
  String get permitCopy;

  /// No description provided for @municipality.
  ///
  /// In ar, this message translates to:
  /// **'البلدية'**
  String get municipality;

  /// No description provided for @streets.
  ///
  /// In ar, this message translates to:
  /// **'الشوارع'**
  String get streets;

  /// No description provided for @totalLength.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي الطول'**
  String get totalLength;

  /// No description provided for @totalWidth.
  ///
  /// In ar, this message translates to:
  /// **'العرض'**
  String get totalWidth;

  /// No description provided for @requestDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الطلب'**
  String get requestDate;

  /// No description provided for @issueDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الإصدار'**
  String get issueDate;

  /// No description provided for @issued.
  ///
  /// In ar, this message translates to:
  /// **'تم الإصدار'**
  String get issued;

  /// No description provided for @bookingMethod.
  ///
  /// In ar, this message translates to:
  /// **'طريقة الحفر'**
  String get bookingMethod;

  /// No description provided for @permitValue.
  ///
  /// In ar, this message translates to:
  /// **'قيمة التصريح'**
  String get permitValue;

  /// No description provided for @renew.
  ///
  /// In ar, this message translates to:
  /// **'تجديد'**
  String get renew;

  /// No description provided for @attachments.
  ///
  /// In ar, this message translates to:
  /// **'المرفقات'**
  String get attachments;

  /// No description provided for @dates.
  ///
  /// In ar, this message translates to:
  /// **'المواعيد'**
  String get dates;

  /// No description provided for @createPermission.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء تصريح جديد'**
  String get createPermission;

  /// No description provided for @save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// No description provided for @selectPermissionType.
  ///
  /// In ar, this message translates to:
  /// **'اختر نوع التصريح'**
  String get selectPermissionType;

  /// No description provided for @selectMunicipality.
  ///
  /// In ar, this message translates to:
  /// **'اختر البلدية'**
  String get selectMunicipality;

  /// No description provided for @requestedBy.
  ///
  /// In ar, this message translates to:
  /// **'طالب التصريح'**
  String get requestedBy;

  /// No description provided for @permissionData.
  ///
  /// In ar, this message translates to:
  /// **'بيانات التصريح'**
  String get permissionData;

  /// No description provided for @permissionNotAllowedTitle.
  ///
  /// In ar, this message translates to:
  /// **'غير مسموح بالتفعيل'**
  String get permissionNotAllowedTitle;

  /// No description provided for @permissionNotAllowedMessage.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكن تفعيل هذا الإذن لأن التصريح غير متاح.\nيرجى التحقق من صلاحيات المهمة أولاً.'**
  String get permissionNotAllowedMessage;

  /// No description provided for @permissionAlreadyEnabledTitle.
  ///
  /// In ar, this message translates to:
  /// **'الإذن مفعل بالفعل'**
  String get permissionAlreadyEnabledTitle;

  /// No description provided for @permissionAlreadyEnabledMessage.
  ///
  /// In ar, this message translates to:
  /// **'هذا الإذن مفعل حالياً ولا يمكن تعطيله.'**
  String get permissionAlreadyEnabledMessage;

  /// No description provided for @permissionNotAvailableTitle.
  ///
  /// In ar, this message translates to:
  /// **'غير متاح'**
  String get permissionNotAvailableTitle;

  /// No description provided for @permissionNotAvailableMessage.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكن تعديل هذا الإذن في الوقت الحالي.'**
  String get permissionNotAvailableMessage;

  /// No description provided for @permissionDialogOk.
  ///
  /// In ar, this message translates to:
  /// **'حسناً'**
  String get permissionDialogOk;

  /// No description provided for @enabled.
  ///
  /// In ar, this message translates to:
  /// **'تم الاصدار'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم الاصدار'**
  String get disabled;

  /// No description provided for @attachmentsRequiredTitle.
  ///
  /// In ar, this message translates to:
  /// **'مرفقات مطلوبة'**
  String get attachmentsRequiredTitle;

  /// No description provided for @attachmentsRequiredMessage.
  ///
  /// In ar, this message translates to:
  /// **'يجب إرفاق المرفقات المطلوبة قبل حفظ التصريح.\nيرجى إضافة المرفقات أولاً.'**
  String get attachmentsRequiredMessage;

  /// No description provided for @validationErrorTitle.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في البيانات'**
  String get validationErrorTitle;

  /// No description provided for @permissionCreatedSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء التصريح بنجاح'**
  String get permissionCreatedSuccessfully;

  /// No description provided for @failedToCreatePermission.
  ///
  /// In ar, this message translates to:
  /// **'فشل إنشاء التصريح. يرجى المحاولة مرة أخرى.'**
  String get failedToCreatePermission;

  /// No description provided for @pleaseSelectPermissionType.
  ///
  /// In ar, this message translates to:
  /// **'يرجى اختيار نوع التصريح'**
  String get pleaseSelectPermissionType;

  /// No description provided for @pleaseSelectMunicipality.
  ///
  /// In ar, this message translates to:
  /// **'يرجى اختيار البلدية'**
  String get pleaseSelectMunicipality;

  /// No description provided for @pleaseEnterPermissionNumber.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال رقم التصريح'**
  String get pleaseEnterPermissionNumber;

  /// No description provided for @pleaseEnterPermitCopy.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال رقم النسخة'**
  String get pleaseEnterPermitCopy;

  /// No description provided for @pleaseSelectStartDate.
  ///
  /// In ar, this message translates to:
  /// **'يرجى اختيار تاريخ البداية'**
  String get pleaseSelectStartDate;

  /// No description provided for @pleaseSelectEndDate.
  ///
  /// In ar, this message translates to:
  /// **'يرجى اختيار تاريخ النهاية'**
  String get pleaseSelectEndDate;

  /// No description provided for @pleaseEnterPermitValue.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال قيمة التصريح'**
  String get pleaseEnterPermitValue;

  /// No description provided for @uploadFile.
  ///
  /// In ar, this message translates to:
  /// **'رفع ملف'**
  String get uploadFile;

  /// No description provided for @uploadImage.
  ///
  /// In ar, this message translates to:
  /// **'رفع صورة'**
  String get uploadImage;

  /// No description provided for @viewFile.
  ///
  /// In ar, this message translates to:
  /// **'عرض الملف'**
  String get viewFile;

  /// No description provided for @selectFileSource.
  ///
  /// In ar, this message translates to:
  /// **'اختر مصدر الصورة'**
  String get selectFileSource;

  /// No description provided for @camera.
  ///
  /// In ar, this message translates to:
  /// **'الكاميرا'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In ar, this message translates to:
  /// **'المعرض'**
  String get gallery;

  /// No description provided for @fileDescription.
  ///
  /// In ar, this message translates to:
  /// **'وصف الملف'**
  String get fileDescription;

  /// No description provided for @documentSerial.
  ///
  /// In ar, this message translates to:
  /// **'مسلسل المستند'**
  String get documentSerial;

  /// No description provided for @documentType.
  ///
  /// In ar, this message translates to:
  /// **'نوع المستند'**
  String get documentType;

  /// No description provided for @noFileSelected.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم اختيار ملف'**
  String get noFileSelected;

  /// No description provided for @noImageSelected.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم اختيار صورة'**
  String get noImageSelected;

  /// No description provided for @selectFileFirst.
  ///
  /// In ar, this message translates to:
  /// **'يرجى اختيار ملف أولاً'**
  String get selectFileFirst;

  /// No description provided for @attachmentDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل المرفق'**
  String get attachmentDetails;

  /// No description provided for @tableName.
  ///
  /// In ar, this message translates to:
  /// **'اسم الجدول'**
  String get tableName;

  /// No description provided for @primaryKey1.
  ///
  /// In ar, this message translates to:
  /// **'المفتاح الأساسي 1'**
  String get primaryKey1;

  /// No description provided for @primaryKey2.
  ///
  /// In ar, this message translates to:
  /// **'المفتاح الأساسي 2'**
  String get primaryKey2;

  /// No description provided for @alternateKey.
  ///
  /// In ar, this message translates to:
  /// **'المفتاح البديل'**
  String get alternateKey;

  /// No description provided for @selectedFile.
  ///
  /// In ar, this message translates to:
  /// **'الملف المحدد'**
  String get selectedFile;

  /// No description provided for @selectedImage.
  ///
  /// In ar, this message translates to:
  /// **'الصورة المحددة'**
  String get selectedImage;

  /// No description provided for @loadingAttachment.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل المرفق...'**
  String get loadingAttachment;

  /// No description provided for @errorLoadingAttachment.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في تحميل المرفق'**
  String get errorLoadingAttachment;

  /// No description provided for @noAttachmentData.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بيانات مرفق'**
  String get noAttachmentData;

  /// No description provided for @notificationsView.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get notificationsView;

  /// No description provided for @notificationsTitle.
  ///
  /// In ar, this message translates to:
  /// **'عرض الإشعارات'**
  String get notificationsTitle;

  /// No description provided for @operationFilter.
  ///
  /// In ar, this message translates to:
  /// **'العملية'**
  String get operationFilter;

  /// No description provided for @selectOperation.
  ///
  /// In ar, this message translates to:
  /// **'اختر العملية'**
  String get selectOperation;

  /// No description provided for @responseStatusFilter.
  ///
  /// In ar, this message translates to:
  /// **'حالة الرد'**
  String get responseStatusFilter;

  /// No description provided for @notReplied.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم الرد'**
  String get notReplied;

  /// No description provided for @replied.
  ///
  /// In ar, this message translates to:
  /// **'تم الرد'**
  String get replied;

  /// No description provided for @serialNumber.
  ///
  /// In ar, this message translates to:
  /// **'م'**
  String get serialNumber;

  /// No description provided for @userType.
  ///
  /// In ar, this message translates to:
  /// **'نوع المستخدم'**
  String get userType;

  /// No description provided for @notificationType.
  ///
  /// In ar, this message translates to:
  /// **'نوع الإشعار'**
  String get notificationType;

  /// No description provided for @notificationDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الإشعار'**
  String get notificationDate;

  /// No description provided for @replyStatus.
  ///
  /// In ar, this message translates to:
  /// **'تم الرد'**
  String get replyStatus;

  /// No description provided for @noNotificationsFound.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد إشعارات'**
  String get noNotificationsFound;

  /// No description provided for @loadingNotifications.
  ///
  /// In ar, this message translates to:
  /// **'جار تحميل الإشعارات...'**
  String get loadingNotifications;

  /// No description provided for @notificationsList.
  ///
  /// In ar, this message translates to:
  /// **'قائمة الإشعارات'**
  String get notificationsList;

  /// No description provided for @notificationDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الإشعار'**
  String get notificationDetails;

  /// No description provided for @notificationDetailsTitle.
  ///
  /// In ar, this message translates to:
  /// **'عرض تفاصيل الإشعار'**
  String get notificationDetailsTitle;

  /// No description provided for @project.
  ///
  /// In ar, this message translates to:
  /// **'المشروع'**
  String get project;

  /// No description provided for @userName.
  ///
  /// In ar, this message translates to:
  /// **'المستخدم'**
  String get userName;

  /// No description provided for @notificationTypeLabel.
  ///
  /// In ar, this message translates to:
  /// **'نوع الإشعار'**
  String get notificationTypeLabel;

  /// No description provided for @notificationDateLabel.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الإشعار'**
  String get notificationDateLabel;

  /// No description provided for @replyStatusLabel.
  ///
  /// In ar, this message translates to:
  /// **'تم الرد'**
  String get replyStatusLabel;

  /// No description provided for @replyDateLabel.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الرد'**
  String get replyDateLabel;

  /// No description provided for @replyDescription.
  ///
  /// In ar, this message translates to:
  /// **'وصف الرد'**
  String get replyDescription;

  /// No description provided for @insertUserLabel.
  ///
  /// In ar, this message translates to:
  /// **'مدخل الإشعار'**
  String get insertUserLabel;

  /// No description provided for @notRepliedYet.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم الرد بعد'**
  String get notRepliedYet;

  /// No description provided for @loadingNotificationDetails.
  ///
  /// In ar, this message translates to:
  /// **'جار تحميل تفاصيل الإشعار...'**
  String get loadingNotificationDetails;

  /// No description provided for @createNewNotification.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء إشعار جديد'**
  String get createNewNotification;

  /// No description provided for @selectUserType.
  ///
  /// In ar, this message translates to:
  /// **'اختر نوع المستخدم'**
  String get selectUserType;

  /// No description provided for @selectUser.
  ///
  /// In ar, this message translates to:
  /// **'اختر المستخدم'**
  String get selectUser;

  /// No description provided for @notificationTypeStop.
  ///
  /// In ar, this message translates to:
  /// **'إشعار بتوقف'**
  String get notificationTypeStop;

  /// No description provided for @notificationTypeGeneral.
  ///
  /// In ar, this message translates to:
  /// **'إشعار عام'**
  String get notificationTypeGeneral;

  /// No description provided for @todayDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ اليوم'**
  String get todayDate;

  /// No description provided for @notificationDescription.
  ///
  /// In ar, this message translates to:
  /// **'شرح الإشعار'**
  String get notificationDescription;

  /// No description provided for @enterDescription.
  ///
  /// In ar, this message translates to:
  /// **'أدخل شرح الإشعار'**
  String get enterDescription;

  /// No description provided for @createNotification.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء الإشعار'**
  String get createNotification;

  /// No description provided for @creatingNotification.
  ///
  /// In ar, this message translates to:
  /// **'جاري إنشاء الإشعار...'**
  String get creatingNotification;

  /// No description provided for @notificationCreatedSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء الإشعار بنجاح'**
  String get notificationCreatedSuccessfully;

  /// No description provided for @failedToCreateNotification.
  ///
  /// In ar, this message translates to:
  /// **'فشل إنشاء الإشعار'**
  String get failedToCreateNotification;

  /// No description provided for @pleaseSelectUserType.
  ///
  /// In ar, this message translates to:
  /// **'يرجى اختيار نوع المستخدم'**
  String get pleaseSelectUserType;

  /// No description provided for @pleaseSelectUser.
  ///
  /// In ar, this message translates to:
  /// **'يرجى اختيار المستخدم'**
  String get pleaseSelectUser;

  /// No description provided for @pleaseEnterDescription.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال شرح الإشعار'**
  String get pleaseEnterDescription;

  /// No description provided for @addNotificationButton.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء إشعار'**
  String get addNotificationButton;

  /// No description provided for @notificationData.
  ///
  /// In ar, this message translates to:
  /// **'بيانات الإشعار'**
  String get notificationData;

  /// No description provided for @replySection.
  ///
  /// In ar, this message translates to:
  /// **'قسم الرد'**
  String get replySection;

  /// No description provided for @savedSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تم الحفظ بنجاح'**
  String get savedSuccessfully;

  /// No description provided for @replyDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الرد'**
  String get replyDate;

  /// No description provided for @internalNumber.
  ///
  /// In ar, this message translates to:
  /// **'الرقم الداخلي'**
  String get internalNumber;

  /// No description provided for @executionDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ التنفيذ'**
  String get executionDate;

  /// No description provided for @permitStatus.
  ///
  /// In ar, this message translates to:
  /// **'حالة التصريح'**
  String get permitStatus;

  /// No description provided for @selectPermitStatus.
  ///
  /// In ar, this message translates to:
  /// **'اختر حالة التصريح'**
  String get selectPermitStatus;

  /// No description provided for @insertUser.
  ///
  /// In ar, this message translates to:
  /// **'مدخل الحقل'**
  String get insertUser;

  /// No description provided for @errorBandRequired.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكن التنفيذ بدون ادخال بنود للعملية'**
  String get errorBandRequired;

  /// No description provided for @enterQuantity.
  ///
  /// In ar, this message translates to:
  /// **'أدخل الكمية'**
  String get enterQuantity;

  /// No description provided for @itemsAndCategoriesButton.
  ///
  /// In ar, this message translates to:
  /// **'البنود والأصناف'**
  String get itemsAndCategoriesButton;

  /// No description provided for @band.
  ///
  /// In ar, this message translates to:
  /// **'البند'**
  String get band;

  /// No description provided for @remainingQty.
  ///
  /// In ar, this message translates to:
  /// **'المتبقي'**
  String get remainingQty;

  /// No description provided for @transactionDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الحركة'**
  String get transactionDate;

  /// No description provided for @addBandAndItem.
  ///
  /// In ar, this message translates to:
  /// **'إضافة'**
  String get addBandAndItem;

  /// No description provided for @createBandOrItem.
  ///
  /// In ar, this message translates to:
  /// **'إضافة بند / صنف'**
  String get createBandOrItem;

  /// No description provided for @bandSection.
  ///
  /// In ar, this message translates to:
  /// **'قسم البند'**
  String get bandSection;

  /// No description provided for @itemSection.
  ///
  /// In ar, this message translates to:
  /// **'قسم الصنف'**
  String get itemSection;

  /// No description provided for @selectBand.
  ///
  /// In ar, this message translates to:
  /// **'اختر البند'**
  String get selectBand;

  /// No description provided for @selectItem.
  ///
  /// In ar, this message translates to:
  /// **'اختر الصنف'**
  String get selectItem;

  /// No description provided for @executedQty.
  ///
  /// In ar, this message translates to:
  /// **'الكمية المنفذة'**
  String get executedQty;

  /// No description provided for @remainingQtyLabel.
  ///
  /// In ar, this message translates to:
  /// **'الكمية المتبقية'**
  String get remainingQtyLabel;

  /// No description provided for @unitLabel.
  ///
  /// In ar, this message translates to:
  /// **'الوحدة'**
  String get unitLabel;

  /// No description provided for @executedQtyHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل الكمية المنفذة'**
  String get executedQtyHint;

  /// No description provided for @selectBandValidation.
  ///
  /// In ar, this message translates to:
  /// **'يرجى اختيار البند'**
  String get selectBandValidation;

  /// No description provided for @selectItemValidation.
  ///
  /// In ar, this message translates to:
  /// **'يرجى اختيار الصنف'**
  String get selectItemValidation;

  /// No description provided for @executedQtyValidation.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال الكمية المنفذة'**
  String get executedQtyValidation;

  /// No description provided for @executedQtyExceedsRemaining.
  ///
  /// In ar, this message translates to:
  /// **'الكمية المنفذة تتجاوز الكمية المتبقية'**
  String get executedQtyExceedsRemaining;

  /// No description provided for @executedQtyMustBePositive.
  ///
  /// In ar, this message translates to:
  /// **'يجب أن تكون الكمية أكبر من صفر'**
  String get executedQtyMustBePositive;

  /// No description provided for @enableBandSection.
  ///
  /// In ar, this message translates to:
  /// **'إضافة بند'**
  String get enableBandSection;

  /// No description provided for @enableItemSection.
  ///
  /// In ar, this message translates to:
  /// **'إضافة صنف'**
  String get enableItemSection;

  /// No description provided for @selectAtLeastOne.
  ///
  /// In ar, this message translates to:
  /// **'يرجى تفعيل قسم البند أو قسم الصنف على الأقل'**
  String get selectAtLeastOne;

  /// No description provided for @creating.
  ///
  /// In ar, this message translates to:
  /// **'جاري الحفظ...'**
  String get creating;

  /// No description provided for @createSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم الحفظ بنجاح'**
  String get createSuccess;

  /// No description provided for @createFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل الحفظ، يرجى المحاولة مرة أخرى'**
  String get createFailed;

  /// No description provided for @autofilled.
  ///
  /// In ar, this message translates to:
  /// **'يتم ملؤه تلقائياً'**
  String get autofilled;

  /// No description provided for @transactionDateLabel.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ المعاملة'**
  String get transactionDateLabel;

  /// No description provided for @selectTransactionDate.
  ///
  /// In ar, this message translates to:
  /// **'اختر تاريخ المعاملة'**
  String get selectTransactionDate;

  /// No description provided for @selectTransactionDateValidation.
  ///
  /// In ar, this message translates to:
  /// **'يرجى اختيار تاريخ المعاملة'**
  String get selectTransactionDateValidation;

  /// No description provided for @tasksAndApprovalTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلب مواد من المخزن'**
  String get tasksAndApprovalTitle;

  /// No description provided for @tasksSelection.
  ///
  /// In ar, this message translates to:
  /// **'المهام'**
  String get tasksSelection;

  /// No description provided for @tasksSelectionDesc.
  ///
  /// In ar, this message translates to:
  /// **'عرض وإدارة المهام المُسندة'**
  String get tasksSelectionDesc;

  /// No description provided for @approvalSelection.
  ///
  /// In ar, this message translates to:
  /// **'الاعتماد'**
  String get approvalSelection;

  /// No description provided for @approvalSelectionDesc.
  ///
  /// In ar, this message translates to:
  /// **'مراجعة واعتماد طلبات المواد'**
  String get approvalSelectionDesc;

  /// No description provided for @tasksDataTitle.
  ///
  /// In ar, this message translates to:
  /// **'المهام'**
  String get tasksDataTitle;

  /// No description provided for @filterDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الحركة'**
  String get filterDate;

  /// No description provided for @filterDateHint.
  ///
  /// In ar, this message translates to:
  /// **'اختر التاريخ'**
  String get filterDateHint;

  /// No description provided for @filterApprovalStatus.
  ///
  /// In ar, this message translates to:
  /// **'الاعتماد'**
  String get filterApprovalStatus;

  /// No description provided for @filterAll.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get filterAll;

  /// No description provided for @filterApproved.
  ///
  /// In ar, this message translates to:
  /// **'معتمد'**
  String get filterApproved;

  /// No description provided for @filterNotApproved.
  ///
  /// In ar, this message translates to:
  /// **'غير معتمد'**
  String get filterNotApproved;

  /// No description provided for @filterRejected.
  ///
  /// In ar, this message translates to:
  /// **'مرفوض'**
  String get filterRejected;

  /// No description provided for @colSerial.
  ///
  /// In ar, this message translates to:
  /// **'م'**
  String get colSerial;

  /// No description provided for @colBand.
  ///
  /// In ar, this message translates to:
  /// **'البند'**
  String get colBand;

  /// No description provided for @colQuantity.
  ///
  /// In ar, this message translates to:
  /// **'الكمية'**
  String get colQuantity;

  /// No description provided for @colTeam.
  ///
  /// In ar, this message translates to:
  /// **'الفرقة'**
  String get colTeam;

  /// No description provided for @colStatus.
  ///
  /// In ar, this message translates to:
  /// **'الحالة'**
  String get colStatus;

  /// No description provided for @addNewRecord.
  ///
  /// In ar, this message translates to:
  /// **'إضافة'**
  String get addNewRecord;

  /// No description provided for @noRecordsFound.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بيانات'**
  String get noRecordsFound;

  /// No description provided for @taskDetailsViewTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل المهمة'**
  String get taskDetailsViewTitle;

  /// No description provided for @detailTrnsDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الحركة'**
  String get detailTrnsDate;

  /// No description provided for @detailBand.
  ///
  /// In ar, this message translates to:
  /// **'البند'**
  String get detailBand;

  /// No description provided for @detailUnit.
  ///
  /// In ar, this message translates to:
  /// **'الوحدة'**
  String get detailUnit;

  /// No description provided for @detailQuantity.
  ///
  /// In ar, this message translates to:
  /// **'الكمية'**
  String get detailQuantity;

  /// No description provided for @detailNotes.
  ///
  /// In ar, this message translates to:
  /// **'الملاحظات'**
  String get detailNotes;

  /// No description provided for @detailAuthDesc.
  ///
  /// In ar, this message translates to:
  /// **'وصف الاعتماد'**
  String get detailAuthDesc;

  /// No description provided for @detailAuthUser.
  ///
  /// In ar, this message translates to:
  /// **'معتمد بواسطة'**
  String get detailAuthUser;

  /// No description provided for @detailAuthDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الاعتماد'**
  String get detailAuthDate;

  /// No description provided for @detailAuthStatus.
  ///
  /// In ar, this message translates to:
  /// **'حالة الاعتماد'**
  String get detailAuthStatus;

  /// No description provided for @sectionTaskInfo.
  ///
  /// In ar, this message translates to:
  /// **'بيانات الطلب'**
  String get sectionTaskInfo;

  /// No description provided for @sectionAuthInfo.
  ///
  /// In ar, this message translates to:
  /// **'بيانات الاعتماد'**
  String get sectionAuthInfo;

  /// No description provided for @btnSave.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get btnSave;

  /// No description provided for @btnDelete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get btnDelete;

  /// No description provided for @readOnlyMessage.
  ///
  /// In ar, this message translates to:
  /// **'هذا الطلب معتمد ولا يمكن تعديله'**
  String get readOnlyMessage;

  /// No description provided for @quantityHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل الكمية'**
  String get quantityHint;

  /// No description provided for @notesHintDetails.
  ///
  /// In ar, this message translates to:
  /// **'أدخل الملاحظات...'**
  String get notesHintDetails;

  /// No description provided for @saveSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم الحفظ بنجاح'**
  String get saveSuccess;

  /// No description provided for @deleteSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم الحذف بنجاح'**
  String get deleteSuccess;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الحذف'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmBody.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من حذف هذا الطلب؟ لا يمكن التراجع عن هذا الإجراء.'**
  String get deleteConfirmBody;

  /// No description provided for @addTaskTitle.
  ///
  /// In ar, this message translates to:
  /// **'إضافة طلب مواد'**
  String get addTaskTitle;

  /// No description provided for @transDateLabel.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الحركة'**
  String get transDateLabel;

  /// No description provided for @bandSelectionLabel.
  ///
  /// In ar, this message translates to:
  /// **'اختيار البند'**
  String get bandSelectionLabel;

  /// No description provided for @addSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم الإضافة بنجاح'**
  String get addSuccess;

  /// No description provided for @selectBandFirst.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء اختيار البند أولاً'**
  String get selectBandFirst;

  /// No description provided for @requiredField.
  ///
  /// In ar, this message translates to:
  /// **'هذا الحقل مطلوب'**
  String get requiredField;

  /// No description provided for @invalidNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم غير صحيح'**
  String get invalidNumber;

  /// No description provided for @quantityTitle.
  ///
  /// In ar, this message translates to:
  /// **'الكمية'**
  String get quantityTitle;

  /// No description provided for @notesTitle.
  ///
  /// In ar, this message translates to:
  /// **'الملاحظات'**
  String get notesTitle;

  /// No description provided for @approvalsViewTitle.
  ///
  /// In ar, this message translates to:
  /// **'الاعتمادات'**
  String get approvalsViewTitle;

  /// No description provided for @approvalsFilterTeamHint.
  ///
  /// In ar, this message translates to:
  /// **'اختر الفرقة'**
  String get approvalsFilterTeamHint;

  /// No description provided for @approvalDetailTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الاعتماد'**
  String get approvalDetailTitle;

  /// No description provided for @approvalDetailSectionRequest.
  ///
  /// In ar, this message translates to:
  /// **'بيانات الطلب'**
  String get approvalDetailSectionRequest;

  /// No description provided for @approvalDetailSectionApproverNotes.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات المعتمد'**
  String get approvalDetailSectionApproverNotes;

  /// No description provided for @approvalDetailApproverNotesHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل ملاحظات المعتمد...'**
  String get approvalDetailApproverNotesHint;

  /// No description provided for @approvalBtnApprove.
  ///
  /// In ar, this message translates to:
  /// **'اعتماد'**
  String get approvalBtnApprove;

  /// No description provided for @approvalBtnCancelApproval.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء اعتماد'**
  String get approvalBtnCancelApproval;

  /// No description provided for @approvalBtnReject.
  ///
  /// In ar, this message translates to:
  /// **'رفض'**
  String get approvalBtnReject;

  /// No description provided for @approvalActionSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم الاعتماد بنجاح'**
  String get approvalActionSuccess;

  /// No description provided for @cancelApprovalActionSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم إلغاء الاعتماد بنجاح'**
  String get cancelApprovalActionSuccess;

  /// No description provided for @rejectActionSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم الرفض بنجاح'**
  String get rejectActionSuccess;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
