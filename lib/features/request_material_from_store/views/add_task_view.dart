import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shehabapp/core/providers/auth_provider.dart';
import 'package:shehabapp/core/providers/locale_provider.dart';
import 'package:shehabapp/core/providers/request_material_from_store_provider.dart';
import 'package:shehabapp/core/models/band_list_model.dart';
import 'package:shehabapp/features/request_material_from_store/widgets/rm_attachment_bottom_sheet.dart';
import 'package:shehabapp/l10n/app_localizations.dart';

class AddTaskView extends StatefulWidget {
  static const routeName = '/add_task_view';
  const AddTaskView({super.key});

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  DateTime _selectedDate = DateTime.now();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  Items? _selectedBand;
  int? _expectedSerial;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBands();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadBands() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final provider = Provider.of<RequestMaterialFromStoreProvider>(
      context,
      listen: false,
    );

    final teamCode = authProvider.currentUser?.teamCode ?? 0;
    final teamType = authProvider.currentUser?.teamType ?? 0;

    await provider.getBandList(teamCode: teamCode, teamType: teamType);

    int newSerial = 1;
    if (provider.tasksAndApprovals == null) {
      await provider.getTasksAndApprovals(
        teamCode: teamCode,
        teamType: teamType,
      );
    }
    final allTasks = provider.tasksAndApprovals?.items ?? [];
    if (allTasks.isNotEmpty) {
      final maxItem = allTasks.reduce(
        (current, next) =>
            ((current.serial ?? 0) > (next.serial ?? 0)) ? current : next,
      );
      newSerial = (maxItem.serial ?? 0) + 1;
    }
    if (mounted) {
      setState(() {
        _expectedSerial = newSerial;
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF4F46E5),
            colorScheme: const ColorScheme.light(primary: Color(0xFF4F46E5)),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      if (picked != _selectedDate) {
        setState(() => _selectedDate = picked);
      }
    }
  }

  Future<void> _performSave() async {
    final l10n = AppLocalizations.of(context)!;
    if (_selectedBand == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Text(l10n.selectBandFirst),
            ],
          ),
          backgroundColor: Colors.orange[800],
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final provider = Provider.of<RequestMaterialFromStoreProvider>(
      context,
      listen: false,
    );

    final qty = double.tryParse(_quantityController.text.trim());
    if (qty == null || qty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Text(l10n.invalidNumber),
            ],
          ),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final teamCode = authProvider.currentUser?.teamCode ?? 0;
    final insertUser = authProvider.currentUser?.usersCode ?? 0;
    final insertDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final trnsDate = DateFormat('yyyy-MM-dd').format(_selectedDate);

    int newSerial = _expectedSerial ?? 1;

    await provider.addOneTasksAndApprovals(
      teamCode: teamCode,
      teamType: authProvider.currentUser?.teamType ?? 'P',
      serial: newSerial,
      trnsDate: trnsDate,
      bandCode: _selectedBand!.bandCode ?? 0,
      bandCodeDet: _selectedBand!.bandCodeDet ?? 0,
      unitCode: _selectedBand!.unitCode ?? 0,
      quantity: qty,
      notes: _notesController.text.trim(),
      insertUser: insertUser,
      insertDate: insertDate,
    );

    if (!mounted) return;

    if (provider.errorMessage == null) {
      // Success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Text(l10n.addSuccess),
            ],
          ),
          backgroundColor: Colors.green[700],
          behavior: SnackBarBehavior.floating,
        ),
      );
      await provider.getTasksAndApprovals(
        teamCode: teamCode,
        teamType: authProvider.currentUser?.teamType,
      ); // refresh list
      await Future.delayed(const Duration(milliseconds: 1000));
      if (mounted) Navigator.of(context).pop();
    } else {
      // Error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(child: Text(provider.errorMessage!)),
            ],
          ),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final provider = context.watch<RequestMaterialFromStoreProvider>();

    String unitName = '';
    if (_selectedBand != null) {
      unitName = isAr
          ? _selectedBand!.unitNameA ?? ''
          : _selectedBand!.unitNameE ?? _selectedBand!.unitNameA ?? '';
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final teamCode = authProvider.currentUser?.teamCode ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFF4F46E5),
      body: SafeArea(
        child: Column(
          children: [
            _DetailHeader(l10n: l10n),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[50], // Or white
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: provider.isLoading && provider.bandList == null
                    ? const Center(child: CircularProgressIndicator())
                    : Stack(
                        children: [
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.only(
                                top: 24,
                                left: 16,
                                right: 16,
                                bottom: 120,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // ── TrnsDate ──────────────────────────────────────────
                                  _buildSectionLabel(l10n.transDateLabel),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: _pickDate,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: Colors.grey[200]!,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.03,
                                            ),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_month_rounded,
                                            color: Colors.indigo[400],
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            DateFormat(
                                              'yyyy-MM-dd',
                                            ).format(_selectedDate),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // ── Band Dropdown ─────────────────────────────────────
                                  _buildSectionLabel(l10n.bandSelectionLabel),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: Colors.grey[200]!,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.03),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: DropdownSearch<Items>(
                                      popupProps: PopupProps.menu(
                                        showSearchBox: true,
                                        searchFieldProps: TextFieldProps(
                                          decoration: InputDecoration(
                                            hintText: l10n.search,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: Colors.grey[300]!,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: Colors.grey[300]!,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: Colors.indigo[400]!,
                                              ),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 12,
                                                ),
                                          ),
                                        ),
                                        menuProps: MenuProps(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                      ),
                                      items: (filter, loadProps) {
                                        final allItems =
                                            provider.bandList?.items ?? [];
                                        if (filter.isEmpty)
                                          return Future.value(allItems);
                                        return Future.value(
                                          allItems.where((band) {
                                            final keyword = filter
                                                .toLowerCase();
                                            final nameA = (band.bandName ?? '')
                                                .toLowerCase();
                                            final nameE = (band.bandNameE ?? '')
                                                .toLowerCase();
                                            return nameA.contains(keyword) ||
                                                nameE.contains(keyword);
                                          }).toList(),
                                        );
                                      },
                                      itemAsString: (Items u) => isAr
                                          ? (u.bandName ?? '')
                                          : (u.bandNameE ?? u.bandName ?? ''),
                                      compareFn: (item1, item2) =>
                                          item1.bandCodeDet ==
                                          item2.bandCodeDet,
                                      selectedItem: _selectedBand,
                                      decoratorProps: DropDownDecoratorProps(
                                        decoration: InputDecoration(
                                          hintText: l10n.bandSelectionLabel,
                                          hintStyle: TextStyle(
                                            color: Colors.grey[400],
                                          ),
                                          border: InputBorder.none,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                vertical: 8,
                                              ),
                                          isDense: true,
                                        ),
                                      ),
                                      onChanged: (Items? value) {
                                        setState(() {
                                          _selectedBand = value;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // ── Unit (Disabled) ───────────────────────────────────
                                  _buildSectionLabel(l10n.unitLabel),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: Colors.grey[200]!,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.widgets_rounded,
                                          color: Colors.grey[400],
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          unitName.isEmpty ? '—' : unitName,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: unitName.isEmpty
                                                ? Colors.grey[400]
                                                : Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // ── Quantity ──────────────────────────────────────────
                                  _buildSectionLabel(l10n.quantityTitle),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: _quantityController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    decoration: _buildInputDecoration(
                                      hint: l10n.quantityHint,
                                      icon: Icons.numbers_rounded,
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // ── Notes ─────────────────────────────────────────────
                                  _buildSectionLabel(l10n.notesTitle),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: _notesController,
                                    maxLines: 4,
                                    decoration: _buildInputDecoration(
                                      hint: l10n.notesHintDetails,
                                      icon: Icons.notes_rounded,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // ── Pinned Action Buttons ──────────────────────────────────────
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(
                                20,
                                16,
                                20,
                                24,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 16,
                                    offset: const Offset(0, -4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Attachment Button
                                  GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) => Padding(
                                          padding: EdgeInsets.only(
                                            top:
                                                MediaQuery.of(
                                                  context,
                                                ).padding.top +
                                                20,
                                          ),
                                          child: RMAttachmentBottomSheet(
                                            attachmentData:
                                                provider.attatchments,
                                            isArabic: isAr,
                                            pk1: teamCode.toString(),
                                            pk2: (_expectedSerial ?? 1)
                                                .toString(),
                                          ),
                                        ),
                                      );
                                      // Also pre-fetch attachments to ensure it has data
                                      provider.getAttatchments(
                                        pk1: teamCode.toString(),
                                        pk2: (_expectedSerial ?? 1).toString(),
                                      );
                                    },
                                    child: Container(
                                      height: 52,
                                      width: 52,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: Colors.grey[200]!,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.attach_file,
                                        color: Color(0xFF4F46E5),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Save Button
                                  Expanded(
                                    child: _SaveButton(
                                      l10n: l10n,
                                      isSaving: provider.isLoading,
                                      onPressed: provider.isLoading
                                          ? () {}
                                          : _performSave,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Color(0xFF374151),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
      prefixIcon: Icon(icon, color: Colors.indigo[300], size: 22),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.indigo[400]!, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _DetailHeader extends StatelessWidget {
  final AppLocalizations l10n;
  const _DetailHeader({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back
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

          Text(
            l10n.addTaskTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Language toggle
          Consumer<LocaleProvider>(
            builder: (context, provider, _) {
              final isArabic = provider.locale?.languageCode == 'ar';
              return GestureDetector(
                onTap: () => provider.setLocale(Locale(isArabic ? 'en' : 'ar')),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.language, color: Colors.white, size: 20),
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
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SaveButton extends StatefulWidget {
  final AppLocalizations l10n;
  final VoidCallback onPressed;
  final bool isSaving;

  const _SaveButton({
    required this.l10n,
    required this.onPressed,
    this.isSaving = false,
  });

  @override
  State<_SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<_SaveButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isSaving
          ? null
          : (_) => setState(() => _isPressed = true),
      onTapUp: widget.isSaving
          ? null
          : (_) {
              setState(() => _isPressed = false);
              Future.delayed(
                const Duration(milliseconds: 100),
                widget.onPressed,
              );
            },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(_isPressed ? 0.97 : 1.0),
        height: 52,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: !_isPressed && !widget.isSaving
              ? [
                  BoxShadow(
                    color: const Color(0xFF4F46E5).withOpacity(0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ]
              : [],
        ),
        child: widget.isSaving
            ? const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add_task_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.l10n.btnSave,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
