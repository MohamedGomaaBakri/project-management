import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/task_permission_model.dart';
import '../../core/providers/task_permission_provider.dart';
import '../../core/providers/locale_provider.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/permission_detail_card.dart';
import 'widgets/permission_action_buttons.dart';
import 'widgets/attachment_bottom_sheet.dart';

class PermissionDetailsView extends StatefulWidget {
  final Permission permission;

  const PermissionDetailsView({super.key, required this.permission});

  @override
  State<PermissionDetailsView> createState() => _PermissionDetailsViewState();
}

class _PermissionDetailsViewState extends State<PermissionDetailsView>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Permission _currentPermission;
  int? _attpermitcheck;

  @override
  void initState() {
    super.initState();

    // Create a copy of permission to allow local updates
    _currentPermission = widget.permission;

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

    // Load attpermitcheck after build phase completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAttpermitcheck();
    });
  }

  Future<void> _loadAttpermitcheck() async {
    if (widget.permission.projectId == null) return;

    try {
      final provider = Provider.of<TaskPermissionProvider>(
        context,
        listen: false,
      );
      await provider.getAttpermitcheck(widget.permission.projectId!);

      // Find the matching item based on permitSerial
      final items = provider.attpermitcheckModel?.items;
      if (items != null && items.isNotEmpty) {
        final matchingItem = items.firstWhere(
          (item) => item.permitSerial == widget.permission.permitSerial,
          orElse: () => items.first,
        );
        if (mounted) {
          setState(() {
            _attpermitcheck = matchingItem.attpermitcheck;
          });
        }
      }
    } catch (e) {
      // Handle error silently or show a message
      if (mounted) {
        setState(() {
          _attpermitcheck = 0; // Default to disabled if error
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getPermissionTypeName(BuildContext context, int? permitType) {
    if (permitType == null) return '-';

    final provider = Provider.of<TaskPermissionProvider>(
      context,
      listen: false,
    );
    final permissionList = provider.permissionListModel?.items;

    if (permissionList == null) return permitType.toString();

    final permissionItem = permissionList.firstWhere(
      (item) => item.code == permitType,
      orElse: () => permissionList.first,
    );

    final isArabic =
        Provider.of<LocaleProvider>(
          context,
          listen: false,
        ).locale.languageCode ==
        'ar';

    return isArabic
        ? (permissionItem.nameA ?? permitType.toString())
        : (permissionItem.nameE ??
              permissionItem.nameA ??
              permitType.toString());
  }

  String _getZoneName(BuildContext context, int? permitLoc) {
    if (permitLoc == null) return '-';

    final provider = Provider.of<TaskPermissionProvider>(
      context,
      listen: false,
    );
    final zonesList = provider.zonesListModel?.items;

    if (zonesList == null) return permitLoc.toString();

    final zoneItem = zonesList.firstWhere(
      (item) => item.code == permitLoc,
      orElse: () => zonesList.first,
    );

    final isArabic =
        Provider.of<LocaleProvider>(
          context,
          listen: false,
        ).locale.languageCode ==
        'ar';

    return isArabic
        ? (zoneItem.nameA ?? permitLoc.toString())
        : (zoneItem.nameE ?? zoneItem.nameA ?? permitLoc.toString());
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return '-';
    if (date.contains('T')) {
      return date.split('T')[0];
    }
    return date;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic =
        Provider.of<LocaleProvider>(context).locale.languageCode == 'ar';

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
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            // Title
                            Text(
                              l10n.permissionDetails,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Project Info Card
                            PermissionDetailCard(
                              title: l10n.projectInfo,
                              items: [
                                // DetailItem(
                                //   label: l10n.projectNumber,
                                //   value: widget.permission.projectId
                                //       ?.toString(),
                                // ),
                                DetailItem(
                                  label: l10n.projectNameLabel,
                                  value: isArabic
                                      ? widget.permission.projectNameA
                                      : (widget.permission.projectNameE ??
                                            widget.permission.projectNameA),
                                ),
                                DetailItem(
                                  label: l10n.contractNumberLabel,
                                  value: widget.permission.contractNo,
                                ),
                              ],
                            ),
                            // Dates Card
                            PermissionDetailCard(
                              title: l10n.dates,
                              items: [
                                DetailItem(
                                  label: l10n.requestDate,
                                  value: _formatDate(
                                    widget.permission.insertDate,
                                  ),
                                ),
                                DetailItem(
                                  label: l10n.fromDate,
                                  value: _formatDate(
                                    widget.permission.startDate,
                                  ),
                                ),
                                DetailItem(
                                  label: l10n.toDate,
                                  value: _formatDate(widget.permission.endDate),
                                ),
                                DetailItem(
                                  label: l10n.issueDate,
                                  value: _formatDate(
                                    widget.permission.doneDate,
                                  ),
                                ),
                                DetailItem(
                                  label: l10n.issued,
                                  value: _currentPermission.doneFlag
                                      ?.toString(),
                                  isCheckbox: true,
                                  attpermitcheck: _attpermitcheck,
                                  onToggleChanged: (bool newValue) async {
                                    // Store previous value for rollback on error
                                    final previousValue =
                                        _currentPermission.doneFlag;

                                    // Update local state immediately for UI feedback
                                    setState(() {
                                      _currentPermission.doneFlag = newValue
                                          ? 1
                                          : 0;
                                    });

                                    // Check if altKey exists
                                    if (widget.permission.altKey == null) {
                                      // Rollback on error
                                      setState(() {
                                        _currentPermission.doneFlag =
                                            previousValue;
                                      });

                                      if (mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              isArabic
                                                  ? 'خطأ: معرّف التصريح غير موجود'
                                                  : 'Error: Permission ID not found',
                                            ),
                                            backgroundColor: const Color(
                                              0xFFEF4444,
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      }
                                      return;
                                    }

                                    try {
                                      final provider =
                                          Provider.of<TaskPermissionProvider>(
                                            context,
                                            listen: false,
                                          );

                                      // Format current date as ISO 8601 string
                                      final currentDate = DateTime.now()
                                          .toIso8601String();

                                      // Call API to update doneFlag
                                      await provider.updateDoneFlag(
                                        widget.permission.altKey!,
                                        newValue ? 1 : 0,
                                        currentDate,
                                      );

                                      // Show success message
                                      if (mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              isArabic
                                                  ? 'تم تحديث حالة الإصدار بنجاح'
                                                  : 'Issue status updated successfully',
                                            ),
                                            backgroundColor: const Color(
                                              0xFF10B981,
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      // Rollback on error
                                      setState(() {
                                        _currentPermission.doneFlag =
                                            previousValue;
                                      });

                                      // Show error message
                                      if (mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              isArabic
                                                  ? 'فشل تحديث حالة الإصدار. يرجى المحاولة مرة أخرى.'
                                                  : 'Failed to update issue status. Please try again.',
                                            ),
                                            backgroundColor: const Color(
                                              0xFFEF4444,
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),

                            // Permission Info Card
                            PermissionDetailCard(
                              title: l10n.taskPermissions,
                              items: [
                                // DetailItem(
                                //   label: l10n.permitSerial,
                                //   value: widget.permission.permitSerial
                                //       ?.toString(),
                                // ),
                                DetailItem(
                                  label: l10n.permissionType,
                                  value: _getPermissionTypeName(
                                    context,
                                    widget.permission.permitType,
                                  ),
                                ),
                                DetailItem(
                                  label: l10n.permissionNumber,
                                  value: widget.permission.permitNo,
                                ),
                                DetailItem(
                                  label: l10n.permitCopy,
                                  value: widget.permission.permitCopy
                                      ?.toString(),
                                ),
                              ],
                            ),

                            // Location & Details Card
                            PermissionDetailCard(
                              title: l10n.details,
                              items: [
                                DetailItem(
                                  label: l10n.municipality,
                                  value: _getZoneName(
                                    context,
                                    widget.permission.permitLoc,
                                  ),
                                ),
                                DetailItem(
                                  label: l10n.streets,
                                  value: widget.permission.streets,
                                ),
                                DetailItem(
                                  label: l10n.totalLength,
                                  value: widget.permission.totalLength
                                      ?.toString(),
                                ),
                                DetailItem(
                                  label: l10n.totalWidth,
                                  value: widget.permission.totalWidth
                                      ?.toString(),
                                ),
                                DetailItem(
                                  label: l10n.bookingMethod,
                                  value: widget.permission.drillingMethod,
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // // Financial Information (same style as Project Details sections)
                            // SectionTitleWidget(
                            //   title: isArabic
                            //       ? 'المعلومات المالية'
                            //       : 'Financial Information',
                            //   icon: Icons.attach_money_outlined,
                            // ),
                            // const SizedBox(height: 16),
                            // PermissionFinancialCardWidget(
                            //   permitValue: widget.permission.permitValue,
                            //   showArabic: isArabic,
                            // ),
                            // const SizedBox(height: 24),

                            // Notes Card
                            if (widget.permission.note != null)
                              PermissionDetailCard(
                                title: l10n.notes,
                                items: [
                                  DetailItem(
                                    label: l10n.notes,
                                    value: widget.permission.note?.toString(),
                                  ),
                                ],
                              ),

                            const SizedBox(height: 24),

                            // Action Buttons
                            PermissionActionButtons(
                              onRenewPressed: () async {
                                // Validate required fields
                                if (widget.permission.projectId == null ||
                                    widget.permission.permitSerial == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        isArabic
                                            ? 'خطأ: بيانات التصريح غير مكتملة'
                                            : 'Error: Permission data is incomplete',
                                      ),
                                      backgroundColor: const Color(0xFFEF4444),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  return;
                                }

                                // Show loading indicator
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const CircularProgressIndicator(
                                            color: Color(0xFF4F46E5),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            isArabic
                                                ? 'جاري تجديد التصريح...'
                                                : 'Renewing permission...',
                                            style: TextStyle(
                                              color: Colors.grey[800],
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );

                                try {
                                  final provider =
                                      Provider.of<TaskPermissionProvider>(
                                        context,
                                        listen: false,
                                      );

                                  // Call renewal API
                                  await provider.renewalPermission(
                                    projectId: widget.permission.projectId
                                        .toString(),
                                    permitSerial: widget.permission.permitSerial
                                        .toString(),
                                    userCode: "0",
                                  );

                                  // Close loading dialog
                                  if (mounted) Navigator.of(context).pop();

                                  // Show success message
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          isArabic
                                              ? 'تم تجديد التصريح بنجاح'
                                              : 'Permission renewed successfully',
                                        ),
                                        backgroundColor: const Color(
                                          0xFF10B981,
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );

                                    // Navigate back to task permissions view
                                    Navigator.of(context).pop(true);
                                  }
                                } catch (e) {
                                  // Close loading dialog
                                  if (mounted) Navigator.of(context).pop();

                                  // Show error message
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          isArabic
                                              ? 'فشل تجديد التصريح. يرجى المحاولة مرة أخرى.'
                                              : 'Failed to renew permission. Please try again.',
                                        ),
                                        backgroundColor: const Color(
                                          0xFFEF4444,
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                }
                              },
                              onAttachmentsPressed: () async {
                                // Validate required fields
                                if (widget.permission.projectId == null ||
                                    widget.permission.permitSerial == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        isArabic
                                            ? 'خطأ: بيانات التصريح غير مكتملة'
                                            : 'Error: Permission data is incomplete',
                                      ),
                                      backgroundColor: const Color(0xFFEF4444),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  return;
                                }

                                // Show loading indicator
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const CircularProgressIndicator(
                                            color: Color(0xFF4F46E5),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            l10n.loadingAttachment,
                                            style: TextStyle(
                                              color: Colors.grey[800],
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );

                                try {
                                  final provider =
                                      Provider.of<TaskPermissionProvider>(
                                        context,
                                        listen: false,
                                      );

                                  // Call API to get attachment data
                                  await provider.getAttachment(
                                    widget.permission.projectId!,
                                    widget.permission.permitSerial!,
                                  );

                                  // Close loading dialog
                                  if (mounted) Navigator.of(context).pop();

                                  // Show attachment bottom sheet
                                  if (mounted) {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) =>
                                          DraggableScrollableSheet(
                                            initialChildSize: 0.9,
                                            minChildSize: 0.5,
                                            maxChildSize: 0.95,
                                            builder:
                                                (context, scrollController) =>
                                                    AttachmentBottomSheet(
                                                      attachmentData: provider
                                                          .attatchmentModel,
                                                      isArabic: isArabic,
                                                      projectId: widget
                                                          .permission
                                                          .projectId!,
                                                      permitSerial: widget
                                                          .permission
                                                          .permitSerial!,
                                                      altKey:
                                                          widget
                                                              .permission
                                                              .altKey ??
                                                          '',
                                                    ),
                                          ),
                                    );
                                  }
                                } catch (e) {
                                  // Close loading dialog
                                  if (mounted) Navigator.of(context).pop();

                                  // Show error message with actual error details
                                  if (mounted) {
                                    // Extract meaningful error message
                                    String errorMessage = e.toString();
                                    if (errorMessage.contains('Body:')) {
                                      // Extract the API error message
                                      final bodyIndex = errorMessage.indexOf(
                                        'Body:',
                                      );
                                      errorMessage = errorMessage
                                          .substring(bodyIndex + 6)
                                          .trim();
                                    } else if (errorMessage.contains(
                                      'Exception:',
                                    )) {
                                      // Remove "Exception:" prefix
                                      errorMessage = errorMessage
                                          .replaceAll('Exception:', '')
                                          .trim();
                                    }

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          isArabic
                                              ? 'خطأ: $errorMessage'
                                              : 'Error: $errorMessage',
                                        ),
                                        backgroundColor: const Color(
                                          0xFFEF4444,
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        duration: const Duration(seconds: 5),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),

                            const SizedBox(height: 24),
                          ],
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
            l10n.permissionDetails,
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
}
