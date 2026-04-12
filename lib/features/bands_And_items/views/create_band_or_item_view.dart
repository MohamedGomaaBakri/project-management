import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shehabapp/core/models/bands_model/item.dart' as band_model;
import 'package:shehabapp/core/models/items_model/item.dart' as item_model;
import 'package:shehabapp/core/providers/band_items_provider.dart';
import 'package:shehabapp/l10n/app_localizations.dart';
import '../widgets/create_band_section_widget.dart';
import '../widgets/create_item_section_widget.dart';
import '../widgets/section_toggle_card.dart';

class CreateBandOrItemView extends StatefulWidget {
  final int? projectId;
  final int? partId;
  final int? flowId;
  final int? procId;
  final int? insertUser;

  const CreateBandOrItemView({
    super.key,
    this.projectId,
    this.partId,
    this.flowId,
    this.procId,
    this.insertUser,
  });

  static const String routeName = 'create_band_or_item_view';

  @override
  State<CreateBandOrItemView> createState() => _CreateBandOrItemViewState();
}

class _CreateBandOrItemViewState extends State<CreateBandOrItemView>
    with TickerProviderStateMixin {
  // ── Animation ────────────────────────────────────────────────────────────────
  late AnimationController _headerController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  // ── Form ─────────────────────────────────────────────────────────────────────
  final _formKey = GlobalKey<FormState>();

  // Band state
  bool _bandEnabled = false;
  band_model.Band? _selectedBand;
  DateTime? _selectedDate;
  final _bandExecQtyCtrl = TextEditingController();

  // Item state
  bool _itemEnabled = false;
  item_model.Item? _selectedItem;
  final _itemExecQtyCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOutCubic),
    );
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _headerController,
            curve: Curves.easeOutCubic,
          ),
        );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<BandItemsProvider>();
      final projectId = widget.projectId?.toString() ?? '';
      if (projectId.isNotEmpty) {
        provider.getAllBands(projectId: projectId);
        provider.getAllItems(projectId: projectId);
      }
      _headerController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _bandExecQtyCtrl.dispose();
    _itemExecQtyCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final l10n = AppLocalizations.of(context)!;
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: l10n.selectTransactionDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4F46E5),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  // ── Build ─────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4F46E5), Color(0xFF7C3AED), Color(0xFFF97316)],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: Column(
                children: [
                  _buildHeader(context, l10n),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 18),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(36),
                          topRight: Radius.circular(36),
                        ),
                      ),
                      child: Consumer<BandItemsProvider>(
                        builder: (context, provider, _) {
                          if (provider.isLoading) {
                            return _buildLoading(l10n);
                          }
                          return Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(
                                20,
                                28,
                                20,
                                120,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildPageTitle(l10n),
                                  const SizedBox(height: 20),

                                  // ── Global Date Picker ───────────
                                  _DateSelectionCard(
                                    selectedDate: _selectedDate,
                                    onTap: _pickDate,
                                    formatDate: _formatDate,
                                    l10n: l10n,
                                  ),
                                  const SizedBox(height: 24),


                                  // ── Band Section ──────────────────
                                  SectionToggleCard(
                                    title: l10n.bandSection,
                                    icon: Icons.layers_rounded,
                                    iconColor: const Color(0xFF4F46E5),
                                    isEnabled: _bandEnabled,
                                    onToggle: (v) => setState(() {
                                      _bandEnabled = v;
                                      if (!v) {
                                        _selectedBand = null;
                                        _bandExecQtyCtrl.clear();
                                      }
                                    }),
                                    child: CreateBandSectionWidget(
                                      bands: provider.bandsModel?.items ?? [],
                                      isArabic: isArabic,
                                      selectedBand: _selectedBand,
                                      selectedDate: _selectedDate,
                                      executedQtyController: _bandExecQtyCtrl,
                                      onBandChanged: (b) =>
                                          setState(() => _selectedBand = b),
                                      isEnabled: _bandEnabled,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // ── Item Section ──────────────────
                                  SectionToggleCard(
                                    title: l10n.itemSection,
                                    icon: Icons.category_rounded,
                                    iconColor: const Color(0xFFF97316),
                                    isEnabled: _itemEnabled,
                                    onToggle: (v) => setState(() {
                                      _itemEnabled = v;
                                      if (!v) {
                                        _selectedItem = null;
                                        _itemExecQtyCtrl.clear();
                                      }
                                    }),
                                    child: CreateItemSectionWidget(
                                      items: provider.itemsModel?.items ?? [],
                                      isArabic: isArabic,
                                      selectedItem: _selectedItem,
                                      executedQtyController: _itemExecQtyCtrl,
                                      onItemChanged: (it) =>
                                          setState(() => _selectedItem = it),
                                      isEnabled: _itemEnabled,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // ── Floating Save Button ─────────────────────────────────────────────────
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer<BandItemsProvider>(
        builder: (context, provider, _) {
          return _buildSaveButton(context, l10n, provider);
        },
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.createBandOrItem,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Page title inside scroll area ─────────────────────────────────────────────
  Widget _buildPageTitle(AppLocalizations l10n) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4F46E5).withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.add_circle_outline_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.createBandOrItem,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            Text(
              '${l10n.enableBandSection} / ${l10n.enableItemSection}',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      ],
    );
  }

  // ── Loading ───────────────────────────────────────────────────────────────────
  Widget _buildLoading(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: Color(0xFF4F46E5)),
          const SizedBox(height: 14),
          Text(l10n.loading, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  // ── Save Button ───────────────────────────────────────────────────────────────
  Widget _buildSaveButton(
    BuildContext context,
    AppLocalizations l10n,
    BandItemsProvider provider,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () => _handleSave(context, l10n, provider),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: provider.isCreating
                  ? const LinearGradient(
                      colors: [Color(0xFF94A3B8), Color(0xFF94A3B8)],
                    )
                  : const LinearGradient(
                      colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: provider.isCreating
                  ? []
                  : [
                      BoxShadow(
                        color: const Color(0xFF4F46E5).withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
            ),
            child: Center(
              child: provider.isCreating
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          l10n.creating,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.save_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          l10n.save,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.4,
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

  // ── Save Logic ────────────────────────────────────────────────────────────────
  Future<void> _handleSave(
    BuildContext context,
    AppLocalizations l10n,
    BandItemsProvider provider,
  ) async {
    print('🚀 _handleSave clicked!');
    print('👉 _bandEnabled: $_bandEnabled, _itemEnabled: $_itemEnabled');

    // At least one section must be enabled
    if (!_bandEnabled && !_itemEnabled) {
      print('❌ Validation Failed: No section enabled.');
      _showSnack(context, l10n.selectAtLeastOne, isError: true);
      return;
    }

    print('🔍 Validating form with key...');
    final isValid = _formKey.currentState!.validate();
    print('✅ Form isValid: $isValid');

    if (!isValid) return;
    if (_selectedDate == null) {
      print('❌ Validation Failed: No date selected.');
      _showSnack(
        context,
        l10n.selectTransactionDateValidation,
        isError: true,
      );
      return;
    }

    // Validate band section
    if (_bandEnabled) {
      print(
        '🔍 Checking band section selection. _selectedBand: ${_selectedBand?.bandName}, _selectedDate: $_selectedDate',
      );
      if (_selectedBand == null) {
        print('❌ Validation Failed: No band selected.');
        _showSnack(context, l10n.selectBandValidation, isError: true);
        return;
      }
    }

    // Validate item section
    if (_itemEnabled) {
      print(
        '🔍 Checking item section selection. _selectedItem: ${_selectedItem?.itemNameA}',
      );
      if (_selectedItem == null) {
        print('❌ Validation Failed: No item selected.');
        _showSnack(context, l10n.selectItemValidation, isError: true);
        return;
      }
    }

    // Build request body
    final now = DateTime.now();
    final insertDateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}T00:00:00+03:00';

    final String? trnsDateStr = _selectedDate != null
        ? '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}T00:00:00+03:00'
        : null;

    print('✅ Getting next serial...');
    final nextSerial = provider.getNextSerial();
    print('👉 nextSerial: $nextSerial');

    final body = <String, dynamic>{
      'ProjectId': widget.projectId,
      'PartId': widget.partId,
      'FlowId': widget.flowId,
      'ProcId': widget.procId,
      'Serial': nextSerial,
      // Band fields
      'BandSerial': _bandEnabled ? _selectedBand?.serialMast : null,
      'BandDetSerial': _bandEnabled ? _selectedBand?.serial : null,
      'BandCode': _bandEnabled ? _selectedBand?.bandCode : null,
      'BandCodeDet': _bandEnabled ? _selectedBand?.bandCodeDet : null,
      'TrnsDate':  trnsDateStr,
      'BandQty': _bandEnabled
          ? (double.tryParse(_bandExecQtyCtrl.text.trim()) ?? 0)
          : null,
      'BandRestQty': _bandEnabled ? _selectedBand?.restQty : null,
      // Item fields
      'DetSerial': _itemEnabled ? _selectedItem?.detSerial : null,
      'ItemSerial': _itemEnabled ? _selectedItem?.itemSerial : null,
      'GroupCode': _itemEnabled ? _selectedItem?.itemGroupCode : null,
      'ItemCode': _itemEnabled ? _selectedItem?.itemCode : null,
      'UnitCode': _itemEnabled ? _selectedItem?.unitCode : null,
      'ItemQty': _itemEnabled
          ? (double.tryParse(_itemExecQtyCtrl.text.trim()) ?? 0)
          : null,
      'ItemBasicQty': _itemEnabled ? _selectedItem?.basicQty : null,
      'ItemRestQty': _itemEnabled ? _selectedItem?.restQty : null,
      // Common
      'DescA': null,
      'DescE': null,
      'InsertUser': widget.insertUser,
      'InsertDate': insertDateStr,
    };

    print('📦 Body Prepared: $body');
    print('🚀 Calling provider.createBandOrItem...');

    final success = await provider.createBandOrItem(body: body);
    print('✅ Call completed! success = $success');

    if (!mounted) {
      print('⚠️ Not mounted after await!');
      return;
    }

    if (success) {
      print('🎉 Success! Showing snackbar and popping...');
      _showSnack(context, l10n.createSuccess, isError: false);
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) Navigator.of(context).pop();
    } else {
      print(
        '❌ Failed! Showing error message. Error: ${provider.createErrorMessage}',
      );
      _showSnack(
        context,
        provider.createErrorMessage ?? l10n.createFailed,
        isError: true,
      );
    }
  }

  void _showSnack(BuildContext context, String msg, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError
                  ? Icons.error_outline_rounded
                  : Icons.check_circle_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                msg,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isError
            ? const Color(0xFFEF4444)
            : const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        duration: Duration(seconds: isError ? 3 : 2),
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

class _DateSelectionCard extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onTap;
  final String Function(DateTime) formatDate;
  final AppLocalizations l10n;

  const _DateSelectionCard({
    required this.selectedDate,
    required this.onTap,
    required this.formatDate,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(
            label: l10n.transactionDateLabel,
            icon: Icons.calendar_today_rounded,
            iconColor: const Color(0xFF4F46E5),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selectedDate != null
                      ? const Color(0xFF4F46E5).withValues(alpha: 0.3)
                      : const Color(0xFFE2E8F0),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.event_available_rounded,
                    size: 22,
                    color: selectedDate != null
                        ? const Color(0xFF4F46E5)
                        : Colors.grey[400],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      selectedDate != null
                          ? formatDate(selectedDate!)
                          : l10n.selectTransactionDate,
                      style: TextStyle(
                        fontSize: 15,
                        color: selectedDate != null
                            ? const Color(0xFF1E293B)
                            : Colors.grey[400],
                        fontWeight: selectedDate != null
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;

  const _SectionLabel({
    required this.label,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF475569),
          ),
        ),
        const TextSpan(
          text: ' *',
          style: TextStyle(color: Color(0xFFEF4444)),
        ).toTextWidget(),
      ],
    );
  }
}

// Extension to convert TextSpan to Widget for Row
extension TextSpanExtension on TextSpan {
  Widget toTextWidget() => RichText(text: this);
}
