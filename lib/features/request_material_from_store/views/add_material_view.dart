import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shehabapp/core/providers/auth_provider.dart';
import 'package:shehabapp/core/providers/locale_provider.dart';
import 'package:shehabapp/core/providers/request_material_from_store_provider.dart';
import 'package:shehabapp/core/models/material_projects_model.dart' as mp;
import 'package:shehabapp/core/models/project_items_model.dart' as pi;
import 'package:shehabapp/l10n/app_localizations.dart';

class AddMaterialView extends StatefulWidget {
  static const routeName = '/add_material_view';
  const AddMaterialView({super.key});

  @override
  State<AddMaterialView> createState() => _AddMaterialViewState();
}

class _AddMaterialViewState extends State<AddMaterialView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final DateTime _currentDate = DateTime.now();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  mp.Items? _selectedProject;
  pi.Items? _selectedItem;
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
      _loadInitialData();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    final provider = Provider.of<RequestMaterialFromStoreProvider>(
      context,
      listen: false,
    );

    // Fetch projects for the first dropdown
    await provider.fetchMaterialProjects();

    // Determine the next serial from the existing requests
    int newSerial = 1;
    final allRequests = provider.materialsModel?.items ?? [];
    if (allRequests.isNotEmpty) {
      final maxItem = allRequests.reduce(
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

  void _onProjectSelected(mp.Items? project) {
    if (_selectedProject != project) {
      setState(() {
        _selectedProject = project;
        _selectedItem = null; // Reset item selection
        _quantityController.clear();
      });

      if (project != null && project.projectId != null) {
        final provider = Provider.of<RequestMaterialFromStoreProvider>(
          context,
          listen: false,
        );
        provider.fetchProjectItems(projectId: project.projectId.toString());
      }
    }
  }

  Future<void> _performSave() async {
    final l10n = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    if (_selectedProject == null) {
      _showErrorSnackBar(
        isAr ? 'يرجى اختيار المشروع أولاً' : 'Please select a project first',
      );
      return;
    }

    if (_selectedItem == null) {
      _showErrorSnackBar(
        isAr ? 'يرجى اختيار الصنف أولاً' : 'Please select an item first',
      );
      return;
    }

    final qty = double.tryParse(_quantityController.text.trim());
    if (qty == null || qty <= 0) {
      _showErrorSnackBar(l10n.invalidNumber);
      return;
    }

    final maxQty = _selectedItem!.bandBal ?? 0;
    if (qty > maxQty) {
      _showErrorSnackBar(
        isAr
            ? 'الكمية المطلوبة أكبر من الرصيد المتاح'
            : 'Quantity exceeds available balance',
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final provider = Provider.of<RequestMaterialFromStoreProvider>(
      context,
      listen: false,
    );

    final insertUser = authProvider.currentUser?.usersCode ?? 0;
    final insertDate = DateFormat('yyyy-MM-dd').format(_currentDate);
    final trnsDate = DateFormat('yyyy-MM-dd').format(_currentDate);

    int newSerial = _expectedSerial ?? 1;

    await provider.addOneMaterialRequestAndApprovals(
      projectId: _selectedProject!.projectId ?? 0,
      serial: newSerial,
      trnsDate: trnsDate,
      groupCode: _selectedItem!.itemGroupCode ?? 0,
      itemCode: int.tryParse(_selectedItem!.itemCode ?? '0') ?? 0,
      unitCode: _selectedItem!.unitCode ?? 0,
      quantity: qty,
      descA: _notesController.text.trim(),
      descE: _notesController.text.trim(),
      insertUser: insertUser,
      insertDate: insertDate,
      authFlag: 0, // 0 for unapproved initial request
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

      // Refresh list
      final teamCode = authProvider.currentUser?.teamCode ?? 0;
      await provider.fetchMaterials(
        teamCode: teamCode,
        teamType: authProvider.currentUser?.teamType,
      );

      await Future.delayed(const Duration(milliseconds: 1000));
      if (mounted) Navigator.of(context).pop();
    } else {
      // Error
      _showErrorSnackBar(provider.errorMessage!);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final provider = context.watch<RequestMaterialFromStoreProvider>();

    String unitName = '';
    String balance = '';
    if (_selectedItem != null) {
      unitName = isAr
          ? (_selectedItem!.unitNameA ?? '')
          : (_selectedItem!.unitNameE ?? _selectedItem!.unitNameA ?? '');
      balance = _selectedItem!.bandBal?.toString() ?? '0';
    }

    return Scaffold(
      backgroundColor: const Color(0xFF4F46E5),
      body: SafeArea(
        child: Column(
          children: [
            _DetailHeader(l10n: l10n, isAr: isAr),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child:
                    provider.isLoading && provider.materialProjectsModel == null
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
                                bottom: 100, // Space for save button
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // ── TrnsDate (Current Date, Read Only) ──────────────
                                  _buildSectionLabel(isAr ? 'التاريخ' : 'Date'),
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
                                          Icons.calendar_month_rounded,
                                          color: Colors.grey[400],
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          DateFormat(
                                            'yyyy-MM-dd',
                                          ).format(_currentDate),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // ── Project Dropdown ────────────────────────────────
                                  _buildSectionLabel(l10n.project),
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
                                    child: DropdownSearch<mp.Items>(
                                      popupProps: PopupProps.menu(
                                        showSearchBox: true,
                                        searchFieldProps: TextFieldProps(
                                          decoration:
                                              _buildSearchInputDecoration(l10n),
                                        ),
                                        menuProps: MenuProps(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                      ),
                                      items: (filter, loadProps) {
                                        final allItems =
                                            provider
                                                .materialProjectsModel
                                                ?.items ??
                                            [];
                                        if (filter.isEmpty)
                                          return Future.value(allItems);
                                        return Future.value(
                                          allItems.where((proj) {
                                            final keyword = filter
                                                .toLowerCase();
                                            final nameA = (proj.nameA ?? '')
                                                .toLowerCase();
                                            final nameE = (proj.nameE ?? '')
                                                .toString()
                                                .toLowerCase();
                                            final contract =
                                                (proj.contractNo ?? '')
                                                    .toLowerCase();
                                            return nameA.contains(keyword) ||
                                                nameE.contains(keyword) ||
                                                contract.contains(keyword);
                                          }).toList(),
                                        );
                                      },
                                      itemAsString: (mp.Items u) =>
                                          u.contractNo ?? '-',
                                      compareFn: (item1, item2) =>
                                          item1.projectId == item2.projectId,
                                      selectedItem: _selectedProject,
                                      decoratorProps: DropDownDecoratorProps(
                                        decoration: InputDecoration(
                                          hintText: l10n
                                              .project, // Assuming l10n.project exists
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
                                      onChanged: _onProjectSelected,
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // ── Item Dropdown ───────────────────────────────────
                                  _buildSectionLabel(l10n.item),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _selectedProject == null
                                          ? Colors.grey[100]
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: Colors.grey[200]!,
                                      ),
                                      boxShadow: _selectedProject == null
                                          ? []
                                          : [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.03,
                                                ),
                                                blurRadius: 10,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                    ),
                                    child: DropdownSearch<pi.Items>(
                                      enabled: _selectedProject != null,
                                      popupProps: PopupProps.menu(
                                        showSearchBox: true,
                                        searchFieldProps: TextFieldProps(
                                          decoration:
                                              _buildSearchInputDecoration(l10n),
                                        ),
                                        menuProps: MenuProps(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                      ),
                                      items: (filter, loadProps) {
                                        final allItems =
                                            provider.projectItemsModel?.items ??
                                            [];
                                        if (filter.isEmpty)
                                          return Future.value(allItems);
                                        return Future.value(
                                          allItems.where((item) {
                                            final keyword = filter
                                                .toLowerCase();
                                            final nameA = (item.itemName ?? '')
                                                .toLowerCase();
                                            final nameE = (item.itemNameE ?? '')
                                                .toLowerCase();
                                            return nameA.contains(keyword) ||
                                                nameE.contains(keyword);
                                          }).toList(),
                                        );
                                      },
                                      itemAsString: (pi.Items u) => isAr
                                          ? (u.itemName ?? '')
                                          : (u.itemNameE ?? u.itemName ?? ''),
                                      compareFn: (item1, item2) =>
                                          item1.itemCode == item2.itemCode,
                                      selectedItem: _selectedItem,
                                      decoratorProps: DropDownDecoratorProps(
                                        decoration: InputDecoration(
                                          hintText: l10n.item,
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
                                      onChanged: (pi.Items? value) {
                                        setState(() {
                                          _selectedItem = value;
                                          _quantityController.clear();
                                        });
                                      },
                                    ),
                                  ),
                                  if (provider.isLoading &&
                                      _selectedProject != null &&
                                      provider.projectItemsModel == null)
                                    const Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: LinearProgressIndicator(),
                                    ),
                                  const SizedBox(height: 24),

                                  // ── Unit & Balance (Read Only) ──────────────────────
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            _buildSectionLabel(l10n.detailUnit),
                                            const SizedBox(height: 8),
                                            _buildReadOnlyField(
                                              icon: Icons.widgets_rounded,
                                              text: unitName.isEmpty
                                                  ? '—'
                                                  : unitName,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            _buildSectionLabel(
                                              isAr ? 'الرصيد' : 'Balance',
                                            ),
                                            const SizedBox(height: 8),
                                            _buildReadOnlyField(
                                              icon: Icons
                                                  .account_balance_wallet_rounded,
                                              text: balance.isEmpty
                                                  ? '—'
                                                  : balance,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),

                                  // ── Quantity ──────────────────────────────────────────
                                  _buildSectionLabel(l10n.colQuantity),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: _quantityController,
                                    enabled: _selectedItem != null,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    decoration: _buildInputDecoration(
                                      hint: l10n
                                          .quantityHint, // or generic quantity
                                      icon: Icons.numbers_rounded,
                                      enabled: _selectedItem != null,
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // ── Notes ─────────────────────────────────────────────
                                  _buildSectionLabel(
                                    isAr ? 'ملاحظات' : 'Notes',
                                  ),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: _notesController,
                                    maxLines: 4,
                                    decoration: _buildInputDecoration(
                                      hint: isAr
                                          ? 'أدخل ملاحظاتك هنا'
                                          : 'Enter your notes here',
                                      icon: Icons.notes_rounded,
                                      enabled: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // ── Pinned Action Button ─────────────────────────────────────
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
                              child: _SaveButton(
                                l10n: l10n,
                                isSaving: provider.isLoading,
                                onPressed: provider.isLoading
                                    ? () {}
                                    : _performSave,
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

  Widget _buildReadOnlyField({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[400], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                color: text == '—' ? Colors.grey[400] : Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildSearchInputDecoration(AppLocalizations l10n) {
    return InputDecoration(
      hintText: l10n.search,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.indigo[400]!),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hint,
    required IconData icon,
    bool enabled = true,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
      prefixIcon: Icon(
        icon,
        color: enabled ? Colors.indigo[300] : Colors.grey[300],
        size: 22,
      ),
      filled: true,
      fillColor: enabled ? Colors.white : Colors.grey[100],
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.indigo[400]!, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _DetailHeader extends StatelessWidget {
  final AppLocalizations l10n;
  final bool isAr;
  const _DetailHeader({required this.l10n, required this.isAr});

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
            isAr ? 'إضافة طلب صرف' : 'Add Material Request',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Language toggle
          Consumer<LocaleProvider>(
            builder: (context, provider, _) {
              final isArabic = provider.locale.languageCode == 'ar';
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
                  const Icon(Icons.save_rounded, color: Colors.white, size: 22),
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
