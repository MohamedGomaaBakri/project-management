import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/task_permission_model.dart';
import '../../core/providers/task_permission_provider.dart';
import '../../core/providers/locale_provider.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/permission_detail_card.dart';
import 'widgets/permission_action_buttons.dart';

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
                                DetailItem(
                                  label: l10n.projectNumber,
                                  value: widget.permission.projectId
                                      ?.toString(),
                                ),
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

                            // Permission Info Card
                            PermissionDetailCard(
                              title: l10n.taskPermissions,
                              items: [
                                DetailItem(
                                  label: l10n.permitSerial,
                                  value: widget.permission.permitSerial
                                      ?.toString(),
                                ),
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
                                DetailItem(
                                  label: l10n.permitValue,
                                  value: widget.permission.permitValue
                                      ?.toString(),
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
                                  value: widget.permission.doneFlag?.toString(),
                                  isCheckbox: true,
                                ),
                              ],
                            ),

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
                              onRenewPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${l10n.renew} - ${l10n.comingSoon}',
                                    ),
                                    backgroundColor: const Color(0xFF4F46E5),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              onAttachmentsPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${l10n.attachments} - ${l10n.comingSoon}',
                                    ),
                                    backgroundColor: const Color(0xFF059669),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
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
