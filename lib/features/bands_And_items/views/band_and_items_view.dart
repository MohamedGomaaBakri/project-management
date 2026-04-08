import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shehabapp/core/providers/band_items_provider.dart';
import 'package:shehabapp/features/bands_And_items/views/create_band_or_item_view.dart';
import 'package:shehabapp/features/bands_And_items/widgets/band_and_item_card.dart';
import 'package:shehabapp/features/bands_And_items/widgets/band_and_items_header.dart';
import 'package:shehabapp/l10n/app_localizations.dart';

class BandAndItemsView extends StatefulWidget {
  final int? projectId;
  final int? partId;
  final int? flowId;
  final int? procId;
  final int? insertUser;

  const BandAndItemsView({
    super.key,
    this.projectId,
    this.partId,
    this.flowId,
    this.procId,
    this.insertUser,
  });

  @override
  State<BandAndItemsView> createState() => _BandAndItemsViewState();
}

class _BandAndItemsViewState extends State<BandAndItemsView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BandItemsProvider>().getAllBandItems();
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            colors: [Color(0xFF4F46E5), Color(0xFF7C3AED), Color(0xFF06B6D4)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  BandAndItemsHeader(
                    title: l10n.itemsAndCategoriesButton,
                    onAddTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CreateBandOrItemView(
                            projectId: widget.projectId,
                            partId: widget.partId,
                            flowId: widget.flowId,
                            procId: widget.procId,
                            insertUser: widget.insertUser,
                          ),
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 18),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Consumer<BandItemsProvider>(
                        builder: (context, provider, child) {
                          if (provider.isLoading) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const CircularProgressIndicator(),
                                  const SizedBox(height: 12),
                                  Text(l10n.loading),
                                ],
                              ),
                            );
                          }

                          if (provider.errorMessage != null &&
                              provider.errorMessage!.isNotEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.error_outline_rounded,
                                      size: 44,
                                      color: Color(0xFFEF4444),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      l10n.error,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      provider.errorMessage!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        provider.getAllBandItems();
                                      },
                                      icon: const Icon(Icons.refresh_rounded),
                                      label: Text(l10n.retry),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF4F46E5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          final items = provider.bandAndItemsModel?.items ?? [];
                          if (items.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.inbox_outlined,
                                      size: 44,
                                      color: Color(0xFF94A3B8),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      l10n.noDataAvailable,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    OutlinedButton.icon(
                                      onPressed: () =>
                                          provider.getAllBandItems(),
                                      icon: const Icon(Icons.refresh_rounded),
                                      label: Text(l10n.refresh),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return RefreshIndicator(
                            onRefresh: () => provider.getAllBandItems(),
                            child: ListView.builder(
                              padding: const EdgeInsets.fromLTRB(
                                20,
                                22,
                                20,
                                26,
                              ),
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                return BandAndItemCard(
                                  data: items[index],
                                  isArabic: isArabic,
                                );
                              },
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
    );
  }
}
