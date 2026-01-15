// --- موديل أمر العمل (يستخدم للقائمة وللتفاصيل) ---
class WorkOrderModel {
  final String altKey; // رقم أمر العمل
  final String reqCode; // رقم الطلب
  final String trnsDate; // التاريخ
  final String statusDesc; // الحالة عربي
  final String statusDescE; // الحالة إنجليزي

  // حقول التفاصيل الإضافية
  final String? storeName;
  final String? storeNameE;
  final String? techName;
  final String? techNameE;
  final String? authDesc;
  final String? authDescE;
  final String? mneTypeName;
  final String? mneTypeNameE;
  final String? notes;
  final String? techNotes;
  final String? contactName;
  final String? contactNameE;
  final String? insertUserName;
  final String? insertUserNameE;
  final String? insertDate;

  WorkOrderModel({
    required this.altKey,
    required this.reqCode,
    required this.trnsDate,
    required this.statusDesc,
    required this.statusDescE,
    this.storeName,
    this.storeNameE,
    this.techName,
    this.techNameE,
    this.authDesc,
    this.authDescE,
    this.mneTypeName,
    this.mneTypeNameE,
    this.notes,
    this.techNotes,
    this.contactName,
    this.contactNameE,
    this.insertUserName,
    this.insertUserNameE,
    this.insertDate,
  });

  factory WorkOrderModel.fromJson(Map<String, dynamic> json) {
    return WorkOrderModel(
      altKey: json['AltKey']?.toString() ?? '',
      reqCode: json['ReqCode']?.toString() ?? '',
      trnsDate:
          json['TrnsDate']?.toString().split('T')[0] ??
          '', // نأخذ التاريخ فقط بدون وقت
      statusDesc: json['StatusDesc'] ?? '',
      statusDescE: json['StatusDescE'] ?? '',
      storeName: json['StoreName'],
      storeNameE: json['StoreNameE'],
      techName: json['TechName'],
      techNameE: json['TechNameE'],
      authDesc: json['AuthDesc'],
      authDescE: json['AuthDescE'],
      mneTypeName: json['MneTypeName'],
      mneTypeNameE: json['MneTypeNameE'],
      notes: json['Notes'],
      techNotes: json['TechNotes'],
      contactName: json['ContactName'],
      contactNameE: json['ContactNameE'],
      insertUserName: json['InsertUserName'],
      insertUserNameE: json['InsertUserNameE'],
      insertDate: json['InsertDate']?.toString().split('T')[0], // تنسيق التاريخ
    );
  }

  // دوال مساعدة لجلب النص حسب اللغة
  String getStatus(bool isArabic) => isArabic
      ? (statusDesc.isEmpty ? statusDescE : statusDesc)
      : (statusDescE.isEmpty ? statusDesc : statusDescE);
  String getStore(bool isArabic) =>
      isArabic ? (storeName ?? '') : (storeNameE ?? storeName ?? '');
  String getTech(bool isArabic) =>
      isArabic ? (techName ?? '') : (techNameE ?? techName ?? '');
  String getAuth(bool isArabic) =>
      isArabic ? (authDesc ?? '') : (authDescE ?? authDesc ?? '');
  String getType(bool isArabic) =>
      isArabic ? (mneTypeName ?? '') : (mneTypeNameE ?? mneTypeName ?? '');
  String getContact(bool isArabic) =>
      isArabic ? (contactName ?? '') : (contactNameE ?? contactName ?? '');
  String getUser(bool isArabic) => isArabic
      ? (insertUserName ?? '')
      : (insertUserNameE ?? insertUserName ?? '');
}

// --- موديل المعدات ---
class EquipmentModel {
  final String altKey;
  final int equipSerial;
  final int equipCode;
  final String equipDesc;
  final String equipDescE;
  final String? equipNo;
  final String? note;

  EquipmentModel({
    required this.altKey,
    required this.equipSerial,
    required this.equipCode,
    required this.equipDesc,
    required this.equipDescE,
    this.equipNo,
    this.note,
  });

  factory EquipmentModel.fromJson(Map<String, dynamic> json) {
    return EquipmentModel(
      altKey: json['AltKey']?.toString() ?? '',
      equipSerial: json['EquipSerial'] ?? 0,
      equipCode: json['EquipCode'] ?? 0,
      equipDesc: json['EquipDesc'] ?? '',
      equipDescE: json['EquipDescE'] ?? '',
      equipNo: json['EquipNo']?.toString(),
      note: json['Note'],
    );
  }

  String getName(bool isArabic) => isArabic
      ? (equipDesc.isEmpty ? equipDescE : equipDesc)
      : (equipDescE.isEmpty ? equipDesc : equipDescE);
}
