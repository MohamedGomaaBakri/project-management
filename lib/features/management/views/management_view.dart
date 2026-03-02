import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shehabapp/features/management/views/mng_notification_view.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/locale_provider.dart';
import '../../daily_tasks/daily_tasks_screen.dart';
import '../../display_notifications/display_notifications_view.dart';
import '../../task_permissions/task_permissions_view.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/management_provider.dart';

class ManagementView extends StatefulWidget {
  const ManagementView({super.key});

  static const String routeName = 'management_view';

  @override
  State<ManagementView> createState() => _ManagementViewState();
}

class _ManagementViewState extends State<ManagementView>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ManagementProvider>(context, listen: false).fetchAllCounts();
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

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4F46E5), // Matches project_categories app theme
              Color(0xFF7C3AED),
              Color(0xFFEC4899),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  _buildHeader(context, l10n),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 30,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[50], // Consistent with other screens
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Consumer<ManagementProvider>(
                        builder: (context, mngProvider, child) {
                          final int dailyTasksCount =
                              mngProvider.procCountModel?.items?.isNotEmpty ==
                                  true
                              ? (mngProvider
                                        .procCountModel!
                                        .items!
                                        .first
                                        .selectobjects0 ??
                                    0)
                              : 0;
                          final int notificationsCount =
                              mngProvider
                                      .notificationCountModel
                                      ?.items
                                      ?.isNotEmpty ==
                                  true
                              ? (mngProvider
                                        .notificationCountModel!
                                        .items!
                                        .first
                                        .notifCnt ??
                                    0)
                              : 0;
                          final int permissionsCount =
                              mngProvider.permitCountModel?.items?.isNotEmpty ==
                                  true
                              ? (mngProvider
                                        .permitCountModel!
                                        .items!
                                        .first
                                        .permitCnt ??
                                    0)
                              : 0;

                          return CustomScrollView(
                            physics: const BouncingScrollPhysics(),
                            slivers: [
                              SliverToBoxAdapter(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      l10n.selectCategory,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                        height: 1.4,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 30),

                                    // Daily Tasks Card
                                    _buildStunningCard(
                                      context: context,
                                      title: l10n.dailyTasks,
                                      subtitle: l10n.dailyTasksDesc,
                                      count: dailyTasksCount,
                                      icon: Icons.assignment_turned_in_rounded,
                                      gradient: const [
                                        Color(0xFF4F46E5),
                                        Color(0xFF6366F1),
                                      ],
                                      delay: 100,
                                      onTap: () {},
                                    ),
                                    const SizedBox(height: 20),

                                    // Notifications Card
                                    _buildStunningCard(
                                      context: context,
                                      title: l10n.notifications,
                                      subtitle: l10n.notificationsDesc,
                                      count: notificationsCount,
                                      icon: Icons.notifications_active_rounded,
                                      gradient: const [
                                        Color(0xFFEC4899),
                                        Color(0xFFF97316),
                                      ],
                                      delay: 250,
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                          MngNotificationView.routeName,
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 20),

                                    // Permissions Card
                                    _buildStunningCard(
                                      context: context,
                                      title: l10n.taskPermissions,
                                      subtitle: l10n.taskPermissionsDesc,
                                      count: permissionsCount,
                                      icon: Icons.verified_user_rounded,
                                      gradient: const [
                                        Color(0xFF10B981),
                                        Color(0xFF059669),
                                      ],
                                      delay: 400,
                                      onTap: () {},
                                    ),
                                    const SizedBox(height: 40),
                                  ],
                                ),
                              ),
                            ],
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

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
            l10n.management, // Represents "الإدارة"
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),

          // Language Toggle
          Consumer<LocaleProvider>(
            builder: (context, provider, child) {
              final isArabic = provider.locale?.languageCode == 'ar';
              return GestureDetector(
                onTap: () {
                  final newLang = isArabic ? 'en' : 'ar';
                  provider.setLocale(Locale(newLang));
                },
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
                          fontSize: 16,
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

  Widget _buildStunningCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required int count,
    required IconData icon,
    required List<Color> gradient,
    required int delay,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
        );
      },
      child: _StunningInteractiveCard(
        title: title,
        subtitle: subtitle,
        count: count,
        icon: icon,
        gradient: gradient,
        onTap: onTap,
      ),
    );
  }
}

class _StunningInteractiveCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final int count;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _StunningInteractiveCard({
    required this.title,
    required this.subtitle,
    required this.count,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_StunningInteractiveCard> createState() =>
      _StunningInteractiveCardState();
}

class _StunningInteractiveCardState extends State<_StunningInteractiveCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) {
        setState(() => _isHovered = false);
        Future.delayed(const Duration(milliseconds: 150), widget.onTap);
      },
      onTapCancel: () => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..scale(_isHovered ? 0.95 : 1.0),
        height: 140, // Fixed height for consistent look
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: widget.gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.gradient.last.withOpacity(_isHovered ? 0.6 : 0.3),
              blurRadius: _isHovered ? 20 : 12,
              offset: Offset(0, _isHovered ? 8 : 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative background icon overlay
            Positioned(
              right: -20,
              bottom: -20,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _isHovered ? 0.4 : 0.15,
                child: Transform.rotate(
                  angle: -0.2,
                  child: Icon(widget.icon, size: 130, color: Colors.white),
                ),
              ),
            ),

            // Top Shine Effect
            Positioned(
              top: 0,
              left: 20,
              right: 20,
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon Container
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(widget.icon, size: 34, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 20),

                  // Text Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 15),

                  // Count Badge with Pulse Animation
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '${widget.count}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: widget.gradient.first,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
