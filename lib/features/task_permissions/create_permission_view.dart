import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/task_permission_provider.dart';
import '../../core/providers/locale_provider.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/form_text_field_widget.dart';
import 'widgets/form_dropdown_widget.dart';
import 'widgets/form_action_buttons_widget.dart';

class CreatePermissionView extends StatefulWidget {
  final int? projectId;

  const CreatePermissionView({super.key, this.projectId});

  @override
  State<CreatePermissionView> createState() => _CreatePermissionViewState();
}

class _CreatePermissionViewState extends State<CreatePermissionView>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Animation controllers
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Text Controllers
  final _permitSerialController = TextEditingController();
  final _permitNoController = TextEditingController();
  final _permitCopyController = TextEditingController();
  final _streetsController = TextEditingController();
  final _totalLengthController = TextEditingController();
  final _totalWidthController = TextEditingController();
  final _insertUserController = TextEditingController();
  final _drillingMethodController = TextEditingController();
  final _noteController = TextEditingController();
  final _permitValueController = TextEditingController();

  // Dropdown values
  int? _selectedPermitType;
  int? _selectedPermitLoc;

  // Date values
  DateTime? _insertDate;
  DateTime? _startDate;
  DateTime? _endDate;
  DateTime? _doneDate;

  // Checkbox value
  bool _doneFlag = false;

  // Loading state
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();

    // Load permission data after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPermissionData();
    });
  }

  void _loadPermissionData() {
    final permissionProvider = Provider.of<TaskPermissionProvider>(
      context,
      listen: false,
    );

    // Get the first permission item from the model if available
    final permission =
        permissionProvider.permissionModel?.items?.isNotEmpty == true
        ? permissionProvider.permissionModel!.items!.first
        : null;

    if (permission != null) {
      setState(() {
        // Populate all fields from permission data
        _permitSerialController.text =
            permission.permitSerial?.toString() ?? '';
        _permitNoController.text = permission.permitNo ?? '';
        _permitCopyController.text = permission.permitCopy?.toString() ?? '';
        _streetsController.text = permission.streets ?? '';
        _totalLengthController.text = permission.totalLength?.toString() ?? '';
        _totalWidthController.text = permission.totalWidth?.toString() ?? '';
        _insertUserController.text = permission.insertUser?.toString() ?? '';
        _drillingMethodController.text = permission.drillingMethod ?? '';
        _noteController.text = permission.note?.toString() ?? '';
        _permitValueController.text = permission.permitValue?.toString() ?? '';

        // Set dropdown values
        _selectedPermitType = permission.permitType;
        _selectedPermitLoc = permission.permitLoc;

        // Set dates
        if (permission.insertDate != null) {
          _insertDate = DateTime.tryParse(permission.insertDate!);
        }
        if (permission.startDate != null) {
          _startDate = DateTime.tryParse(permission.startDate!);
        }
        if (permission.endDate != null) {
          _endDate = DateTime.tryParse(permission.endDate!);
        }
        if (permission.doneDate != null) {
          _doneDate = DateTime.tryParse(permission.doneDate.toString());
        }

        // Set checkbox
        _doneFlag = permission.doneFlag == 1;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _permitSerialController.dispose();
    _permitNoController.dispose();
    _permitCopyController.dispose();
    _streetsController.dispose();
    _totalLengthController.dispose();
    _totalWidthController.dispose();
    _insertUserController.dispose();
    _drillingMethodController.dispose();
    _noteController.dispose();
    _permitValueController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement save logic with API call
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم الحفظ بنجاح!'),
              backgroundColor: Color(0xFF059669),
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.of(context).pop();
        }
      });
    }
  }

  void _handleAttachments() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${AppLocalizations.of(context)!.attachments} - ${AppLocalizations.of(context)!.comingSoon}',
        ),
        backgroundColor: const Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic =
        Provider.of<LocaleProvider>(context).locale.languageCode == 'ar';
    final permissionProvider = Provider.of<TaskPermissionProvider>(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4F46E5), Color(0xFF7C3AED), Color(0xFFEC4899)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  // Header
                  _buildHeader(context, l10n),

                  // Content
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 24),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Text(
                                l10n.createPermission,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Project Info Section
                              _buildSectionCard(
                                title: l10n.projectInfo,
                                children: [
                                  FormTextFieldWidget(
                                    label: l10n.projectNumber,
                                    controller: TextEditingController(
                                      text: widget.projectId?.toString() ?? '',
                                    ),
                                    readOnly: true,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Permission Data Section
                              _buildSectionCard(
                                title: l10n.permissionData,
                                children: [
                                  FormTextFieldWidget(
                                    label: l10n.permitSerial,
                                    controller: _permitSerialController,
                                    keyboardType: TextInputType.number,
                                    readOnly: true,
                                  ),
                                  const SizedBox(height: 16),
                                  FormDropdownWidget<int>(
                                    label: l10n.permissionType,
                                    hint: l10n.selectPermissionType,
                                    value: _selectedPermitType,
                                    items:
                                        permissionProvider
                                            .permissionListModel
                                            ?.items
                                            ?.map((item) {
                                              return DropdownMenuItem<int>(
                                                value: item.code,
                                                child: Text(
                                                  isArabic
                                                      ? (item.nameA ?? '')
                                                      : (item.nameE ??
                                                            item.nameA ??
                                                            ''),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              );
                                            })
                                            .toList() ??
                                        [],
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedPermitType = value;
                                      });
                                    },
                                    required: false,
                                  ),
                                  const SizedBox(height: 16),
                                  FormTextFieldWidget(
                                    label: l10n.permissionNumber,
                                    controller: _permitNoController,
                                    readOnly: true,
                                  ),
                                  const SizedBox(height: 16),
                                  FormTextFieldWidget(
                                    label: l10n.permitCopy,
                                    controller: _permitCopyController,
                                    keyboardType: TextInputType.number,
                                    readOnly: true,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Location & Details Section
                              _buildSectionCard(
                                title: l10n.details,
                                children: [
                                  FormDropdownWidget<int>(
                                    label: l10n.municipality,
                                    hint: l10n.selectMunicipality,
                                    value: _selectedPermitLoc,
                                    items:
                                        permissionProvider.zonesListModel?.items
                                            ?.map((item) {
                                              return DropdownMenuItem<int>(
                                                value: item.code,
                                                child: Text(
                                                  isArabic
                                                      ? (item.nameA ?? '')
                                                      : (item.nameE ??
                                                            item.nameA ??
                                                            ''),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              );
                                            })
                                            .toList() ??
                                        [],
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedPermitLoc = value;
                                      });
                                    },
                                    required: true,
                                  ),
                                  const SizedBox(height: 16),
                                  FormTextFieldWidget(
                                    label: l10n.streets,
                                    controller: _streetsController,
                                    readOnly: true,
                                  ),
                                  const SizedBox(height: 16),
                                  FormTextFieldWidget(
                                    label: l10n.totalLength,
                                    controller: _totalLengthController,
                                    keyboardType: TextInputType.number,
                                    readOnly: true,
                                  ),
                                  const SizedBox(height: 16),
                                  FormTextFieldWidget(
                                    label: l10n.totalWidth,
                                    controller: _totalWidthController,
                                    keyboardType: TextInputType.number,
                                    readOnly: true,
                                  ),
                                  const SizedBox(height: 16),
                                  FormTextFieldWidget(
                                    label: l10n.bookingMethod,
                                    controller: _drillingMethodController,
                                    readOnly: true,
                                  ),
                                  const SizedBox(height: 16),
                                  FormTextFieldWidget(
                                    label: l10n.permitValue,
                                    controller: _permitValueController,
                                    keyboardType: TextInputType.number,
                                    readOnly: true,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Dates Section
                              _buildSectionCard(
                                title: l10n.dates,
                                children: [
                                  FormTextFieldWidget(
                                    label: l10n.requestedBy,
                                    controller: _insertUserController,
                                    readOnly: true,
                                  ),
                                  const SizedBox(height: 16),
                                  FormTextFieldWidget(
                                    label: l10n.requestDate,
                                    controller: TextEditingController(
                                      text: _insertDate != null
                                          ? '${_insertDate!.year}-${_insertDate!.month.toString().padLeft(2, '0')}-${_insertDate!.day.toString().padLeft(2, '0')}'
                                          : '',
                                    ),
                                    readOnly: true,
                                  ),
                                  const SizedBox(height: 16),
                                  FormTextFieldWidget(
                                    label: l10n.fromDate,
                                    controller: TextEditingController(
                                      text: _startDate != null
                                          ? '${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}'
                                          : '',
                                    ),
                                    readOnly: true,
                                  ),
                                  const SizedBox(height: 16),
                                  FormTextFieldWidget(
                                    label: l10n.toDate,
                                    controller: TextEditingController(
                                      text: _endDate != null
                                          ? '${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}'
                                          : '',
                                    ),
                                    readOnly: true,
                                  ),
                                  const SizedBox(height: 16),
                                  FormTextFieldWidget(
                                    label: l10n.issueDate,
                                    controller: TextEditingController(
                                      text: _doneDate != null
                                          ? '${_doneDate!.year}-${_doneDate!.month.toString().padLeft(2, '0')}-${_doneDate!.day.toString().padLeft(2, '0')}'
                                          : '',
                                    ),
                                    readOnly: true,
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: _doneFlag,
                                        onChanged: null, // Read-only
                                        activeColor: const Color(0xFF4F46E5),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        l10n.issued,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Notes Section
                              _buildSectionCard(
                                title: l10n.notes,
                                children: [
                                  FormTextFieldWidget(
                                    label: l10n.notes,
                                    controller: _noteController,
                                    maxLines: 4,
                                    readOnly: true,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Action Buttons
                              FormActionButtonsWidget(
                                onSavePressed: _handleSave,
                                onAttachmentsPressed: _handleAttachments,
                                isLoading: _isLoading,
                              ),

                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),

          // Title
          Text(
            l10n.createPermission,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Language Toggle
          Consumer<LocaleProvider>(
            builder: (context, provider, child) {
              final isArabic = provider.locale.languageCode == 'ar';
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      final newLang = isArabic ? 'en' : 'ar';
                      provider.setLocale(Locale(newLang));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.language,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isArabic ? 'EN' : 'ع',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.edit_note, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}
