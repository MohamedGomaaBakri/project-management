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

  DateTime? _startDate;
  DateTime? _endDate;
  DateTime? _doneDate;

  // Checkbox value
  bool _doneFlag = false;

  // Loading state
  bool _isLoading = false;

  // Attpermitcheck and PermitSerial
  int? _attpermitcheck;
  int? _currentPermitSerial;
  int? _insertUser;
  String? _insertDate;

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

  void _loadPermissionData() async {
    // Load attpermitcheck and get current permitSerial
    if (widget.projectId == null) return;

    try {
      final provider = Provider.of<TaskPermissionProvider>(
        context,
        listen: false,
      );

      // Get attpermitcheck
      await provider.getAttpermitcheck(widget.projectId!);

      // Get permission details to find current permitSerial
      await provider.getPermissionDetails(widget.projectId!);

      if (mounted) {
        setState(() {
          // Find attpermitcheck value
          final items = provider.attpermitcheckModel?.items;
          if (items != null && items.isNotEmpty) {
            _attpermitcheck = items.first.attpermitcheck;
          }

          // Find current permitSerial (get the maximum)
          final permissions = provider.permissionModel?.items;
          if (permissions != null && permissions.isNotEmpty) {
            _currentPermitSerial = permissions
                .map((p) => p.permitSerial ?? 0)
                .reduce((a, b) => a > b ? a : b);
          }
          _insertUser = permissions?.first.insertUser;
          _insertDate = permissions?.first.insertDate;
        });
      }
    } catch (e) {
      // Handle error silently or show message
      if (mounted) {
        setState(() {
          _attpermitcheck = 0; // Default to disabled
          _currentPermitSerial = 0;
        });
      }
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

  void _handleSave() async {
    final l10n = AppLocalizations.of(context)!;

    // Validate required fields manually
    String? validationError;

    if (_selectedPermitType == null) {
      validationError = l10n.pleaseSelectPermissionType;
    } else if (_permitNoController.text.isEmpty) {
      validationError = l10n.pleaseEnterPermissionNumber;
    } else if (_permitCopyController.text.isEmpty) {
      validationError = l10n.pleaseEnterPermitCopy;
    } else if (_selectedPermitLoc == null) {
      validationError = l10n.pleaseSelectMunicipality;
    } else if (_startDate == null) {
      validationError = l10n.pleaseSelectStartDate;
    } else if (_endDate == null) {
      validationError = l10n.pleaseSelectEndDate;
    } else if (_permitValueController.text.isEmpty) {
      validationError = l10n.pleaseEnterPermitValue;
    }

    // Show validation error if any
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validationError),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Check attpermitcheck
    // if (_attpermitcheck == null || _attpermitcheck == 0) {
    //   // Show attachments required dialog
    //   AttachmentsRequiredDialog.show(
    //     context,
    //     title: l10n.attachmentsRequiredTitle,
    //     message: l10n.attachmentsRequiredMessage,
    //   );
    //   return;
    // }

    // All validation passed, proceed with API call
    setState(() {
      _isLoading = true;
    });

    try {
      final provider = Provider.of<TaskPermissionProvider>(
        context,
        listen: false,
      );

      // Prepare permission data
      final permissionData = {
        // Required fields
        'ProjectId': widget.projectId,
        'PermitSerial': (_currentPermitSerial ?? 0) + 1,
        'InsertUser': _insertUser,
        'InsertDate': _insertDate,
        'PermitType': _selectedPermitType,
        'PermitNo': _permitNoController.text,
        'PermitCopy': int.tryParse(_permitCopyController.text) ?? 0,
        'PermitLoc': _selectedPermitLoc,
        'StartDate': _startDate!.toIso8601String(),
        'EndDate': _endDate!.toIso8601String(),
        'PermitValue': double.tryParse(_permitValueController.text) ?? 0.0,
      };

      // Optional fields - only add if not empty
      if (_streetsController.text.isNotEmpty) {
        permissionData['Streets'] = _streetsController.text;
      }
      if (_totalWidthController.text.isNotEmpty) {
        permissionData['TotalWidth'] =
            double.tryParse(_totalWidthController.text) ?? 0.0;
      }
      if (_totalLengthController.text.isNotEmpty) {
        permissionData['TotalLength'] =
            int.tryParse(_totalLengthController.text) ?? 0;
      }
      if (_doneDate != null) {
        permissionData['DoneDate'] = _doneDate!.toIso8601String();
      }
      if (_drillingMethodController.text.isNotEmpty) {
        permissionData['DrillingMethod'] = _drillingMethodController.text;
      }
      if (_noteController.text.isNotEmpty) {
        permissionData['Note'] = _noteController.text;
      }

      permissionData['DoneFlag'] = _doneFlag ? 1 : 0;

      // Call API with the permission data directly
      await provider.createPermission(permissionData);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.permissionCreatedSuccessfully),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Go back
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.failedToCreatePermission),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // void _handleAttachments() {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(
  //         '${AppLocalizations.of(context)!.attachments} - ${AppLocalizations.of(context)!.comingSoon}',
  //       ),
  //       backgroundColor: const Color(0xFF059669),
  //       behavior: SnackBarBehavior.floating,
  //     ),
  //   );
  // }

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
                                  // FormTextFieldWidget(
                                  //   label: l10n.permitSerial,
                                  //   controller: _permitSerialController,
                                  //   keyboardType: TextInputType.number,
                                  // ),
                                  // const SizedBox(height: 16),
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
                                  ),
                                  const SizedBox(height: 16),
                                  FormTextFieldWidget(
                                    label: l10n.permitCopy,
                                    controller: _permitCopyController,
                                    keyboardType: TextInputType.number,
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
                                  ),
                                  const SizedBox(height: 16),
                                  FormTextFieldWidget(
                                    label: l10n.totalLength,
                                    controller: _totalLengthController,
                                    keyboardType: TextInputType.number,
                                  ),
                                  const SizedBox(height: 16),
                                  FormTextFieldWidget(
                                    label: l10n.totalWidth,
                                    controller: _totalWidthController,
                                    keyboardType: TextInputType.number,
                                  ),
                                  const SizedBox(height: 16),
                                  FormTextFieldWidget(
                                    label: l10n.bookingMethod,
                                    controller: _drillingMethodController,
                                  ),
                                  const SizedBox(height: 16),
                                  FormTextFieldWidget(
                                    label: l10n.permitValue,
                                    controller: _permitValueController,
                                    keyboardType: TextInputType.number,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Dates Section
                              _buildSectionCard(
                                title: l10n.dates,
                                children: [
                                  // FormTextFieldWidget(
                                  //   label: l10n.requestedBy,
                                  //   controller: _insertUserController,
                                  // ),
                                  // const SizedBox(height: 16),
                                  // GestureDetector(
                                  //   onTap: () async {
                                  //     final picked = await showDatePicker(
                                  //       context: context,
                                  //       initialDate:
                                  //           _insertDate ?? DateTime.now(),
                                  //       firstDate: DateTime(2000),
                                  //       lastDate: DateTime(2100),
                                  //     );
                                  //     if (picked != null) {
                                  //       setState(() {
                                  //         _insertDate = picked;
                                  //       });
                                  //     }
                                  //   },
                                  //   child: AbsorbPointer(
                                  //     child: FormTextFieldWidget(
                                  //       label: l10n.requestDate,
                                  //       controller: TextEditingController(
                                  //         text: _insertDate != null
                                  //             ? '${_insertDate!.year}-${_insertDate!.month.toString().padLeft(2, '0')}-${_insertDate!.day.toString().padLeft(2, '0')}'
                                  //             : '',
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  // const SizedBox(height: 16),
                                  GestureDetector(
                                    onTap: () async {
                                      final picked = await showDatePicker(
                                        context: context,
                                        initialDate:
                                            _startDate ?? DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                      );
                                      if (picked != null) {
                                        setState(() {
                                          _startDate = picked;
                                        });
                                      }
                                    },
                                    child: AbsorbPointer(
                                      child: FormTextFieldWidget(
                                        label: l10n.fromDate,
                                        controller: TextEditingController(
                                          text: _startDate != null
                                              ? '${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}'
                                              : '',
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  GestureDetector(
                                    onTap: () async {
                                      final picked = await showDatePicker(
                                        context: context,
                                        initialDate: _endDate ?? DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                      );
                                      if (picked != null) {
                                        setState(() {
                                          _endDate = picked;
                                        });
                                      }
                                    },
                                    child: AbsorbPointer(
                                      child: FormTextFieldWidget(
                                        label: l10n.toDate,
                                        controller: TextEditingController(
                                          text: _endDate != null
                                              ? '${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}'
                                              : '',
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  GestureDetector(
                                    onTap: () async {
                                      final picked = await showDatePicker(
                                        context: context,
                                        initialDate:
                                            _doneDate ?? DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                      );
                                      if (picked != null) {
                                        setState(() {
                                          _doneDate = picked;
                                        });
                                      }
                                    },
                                    child: AbsorbPointer(
                                      child: FormTextFieldWidget(
                                        label: l10n.issueDate,
                                        controller: TextEditingController(
                                          text: _doneDate != null
                                              ? '${_doneDate!.year}-${_doneDate!.month.toString().padLeft(2, '0')}-${_doneDate!.day.toString().padLeft(2, '0')}'
                                              : '',
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Status text
                                      Text(
                                        _doneFlag
                                            ? l10n.enabled
                                            : l10n.disabled,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: _doneFlag
                                              ? const Color(0xFF10B981)
                                              : const Color(0xFFEF4444),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Switch
                                      Transform.scale(
                                        scale: 0.8,
                                        alignment: Alignment.centerRight,
                                        child: Switch(
                                          value: _doneFlag,
                                          onChanged: (value) {
                                            setState(() {
                                              _doneFlag = value;
                                            });
                                          },
                                          activeColor: const Color(0xFF10B981),
                                          activeTrackColor: const Color(
                                            0xFF10B981,
                                          ).withOpacity(0.5),
                                          inactiveThumbColor: const Color(
                                            0xFFEF4444,
                                          ),
                                          inactiveTrackColor: const Color(
                                            0xFFEF4444,
                                          ).withOpacity(0.5),
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
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
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Action Buttons
                              FormActionButtonsWidget(
                                onSavePressed: _handleSave,
                                // onAttachmentsPressed: _handleAttachments,
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
