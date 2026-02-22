import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shehabapp/features/daily_tasks/daily_tasks_screen.dart';
import 'package:shehabapp/features/display_notifications/display_notifications_view.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/models/project_categories_count.dart';

import 'login_screen.dart';

class ProjectCategories extends StatefulWidget {
  static const String routeName = '/project-categories';

  const ProjectCategories({super.key});

  @override
  State<ProjectCategories> createState() => _ProjectCategoriesState();
}

class _ProjectCategoriesState extends State<ProjectCategories>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  Items? _categoriesData;
  bool _isLoading = true;

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

    // Call API after first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCategoriesCounts();
    });
  }

  Future<void> _loadCategoriesCounts() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final usersCode = authProvider.currentUser?.usersCode.toString();

    if (usersCode != null) {
      await authProvider.getProjectCategoriesCount(usersCode: usersCode);

      // Also fetch user permissions if not already loaded
      if (authProvider.usersPermissions == null) {
        await authProvider.getAllUsersPermissions(usersCode: usersCode);
      }

      if (authProvider.projectCategoriesCount?.items?.isNotEmpty == true) {
        setState(() {
          _categoriesData = authProvider.projectCategoriesCount!.items!.first;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF4F46E5),
              const Color(0xFF7C3AED),
              const Color(0xFFEC4899),
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
                  // Header Section
                  _buildHeader(context, l10n),

                  // Content Section
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 30),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            Text(
                              l10n.selectCategory,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 30),

                            // Category Cards Grid
                            Expanded(
                              child: Consumer<AuthProvider>(
                                builder: (context, authProv, _) {
                                  final perms =
                                      authProv
                                              .usersPermissions
                                              ?.items
                                              ?.isNotEmpty ==
                                          true
                                      ? authProv.usersPermissions!.items!.first
                                      : null;
                                  return GridView.count(
                                    crossAxisCount: size.width > 600 ? 3 : 2,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 0.85,
                                    children: [
                                      _buildCategoryCard(
                                        context,
                                        title: l10n.dailyTasks,
                                        subtitle: l10n.dailyTasksDesc,
                                        icon: Icons.task_alt,
                                        gradientColors: [
                                          const Color(0xFF4F46E5),
                                          const Color(0xFF6366F1),
                                        ],
                                        delay: 0,
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            DailyTasksScreen.routeName,
                                          );
                                        },
                                        showNotifications: true,
                                        notificationCount:
                                            _categoriesData?.procCnt ?? 0,
                                      ),
                                      _buildNotificationsCard(
                                        context,
                                        title: l10n.notifications,
                                        subtitle: l10n.notificationsDesc,
                                        gradientColors: [
                                          const Color(0xFFEC4899),
                                          const Color(0xFFF97316),
                                        ],
                                        delay: 100,
                                        onTap: () {
                                          final ap = Provider.of<AuthProvider>(
                                            context,
                                            listen: false,
                                          );
                                          final userCode =
                                              ap.currentUser?.usersCode;
                                          if (userCode != null) {
                                            Navigator.pushNamed(
                                              context,
                                              DisplayNotificationsView
                                                  .routeName,
                                              arguments: userCode,
                                            );
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'خطأ: لم يتم العثور على بيانات المستخدم',
                                                ),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        },
                                        showNotifications: true,
                                        stopNotifCnt:
                                            _categoriesData?.stopNotifCnt ?? 0,
                                        allNotifCnt:
                                            _categoriesData?.allNotifCnt ?? 0,
                                      ),
                                      // إدارة - MobileManagerFlag
                                      if (perms == null ||
                                          perms.mobileManagerFlag == 1)
                                        _buildCategoryCard(
                                          context,
                                          title: l10n.department,
                                          subtitle: l10n.managementDesc,
                                          icon: Icons.business_center,
                                          gradientColors: [
                                            const Color(0xFF10B981),
                                            const Color(0xFF059669),
                                          ],
                                          delay: 200,
                                          onTap: () {
                                            // TODO: Navigate to Management screen
                                          },
                                          showNotifications: false,
                                        ),
                                      // امر عمل مقايسة - MobileTenderFlag
                                      if (perms == null ||
                                          perms.mobileTenderFlag == 1)
                                        _buildCategoryCard(
                                          context,
                                          title: l10n.workOrderQuotation,
                                          subtitle: l10n.workOrderQuotationDesc,
                                          icon: Icons.description,
                                          gradientColors: [
                                            const Color(0xFF3B82F6),
                                            const Color(0xFF2563EB),
                                          ],
                                          delay: 300,
                                          onTap: () {
                                            // TODO: Navigate to Work Order Quotation
                                          },
                                          showNotifications: false,
                                        ),
                                      // امر عمل مشروع - MobileProjectFlag
                                      if (perms == null ||
                                          perms.mobileProjectFlag == 1)
                                        _buildCategoryCard(
                                          context,
                                          title: l10n.workOrderProjects,
                                          subtitle: l10n.workOrderProjectsDesc,
                                          icon: Icons.assignment,
                                          gradientColors: [
                                            const Color(0xFF8B5CF6),
                                            const Color(0xFF7C3AED),
                                          ],
                                          delay: 400,
                                          onTap: () {
                                            // TODO: Navigate to Work Order Projects
                                          },
                                          showNotifications: false,
                                        ),
                                      // امر عمل صيانة - MobileMainFlag
                                      if (perms == null ||
                                          perms.mobileMainFlag == 1)
                                        _buildCategoryCard(
                                          context,
                                          title: l10n.workOrderMaintenance,
                                          subtitle:
                                              l10n.workOrderMaintenanceDesc,
                                          icon: Icons.build,
                                          gradientColors: [
                                            const Color(0xFFF59E0B),
                                            const Color(0xFFD97706),
                                          ],
                                          delay: 500,
                                          onTap: () {
                                            // TODO: Navigate to Work Order Maintenance
                                          },
                                          showNotifications: false,
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ),
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
            l10n.homeTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Language Toggle Button with Provider
          Consumer<LocaleProvider>(
            builder: (context, provider, child) {
              final isArabic = provider.locale?.languageCode == 'ar';
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

          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (c) => const LoginScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.logout,
                color: Color(0xFF1E3A8A),
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradientColors,
    required VoidCallback onTap,
    required int delay,
    required bool showNotifications,
    int notificationCount = 0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: _AnimatedCategoryCard(
        title: title,
        subtitle: subtitle,
        icon: icon,
        gradientColors: gradientColors,
        onTap: onTap,
        showNotifications: showNotifications,
        notificationCount: notificationCount,
      ),
    );
  }

  Widget _buildNotificationsCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required List<Color> gradientColors,
    required VoidCallback onTap,
    required int delay,
    required bool showNotifications,
    int stopNotifCnt = 0,
    int allNotifCnt = 0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: _AnimatedNotificationsCard(
        title: title,
        subtitle: subtitle,
        gradientColors: gradientColors,
        onTap: onTap,
        stopNotifCnt: stopNotifCnt,
        allNotifCnt: allNotifCnt,
      ),
    );
  }
}

class _AnimatedCategoryCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback onTap;
  final bool showNotifications;
  final int notificationCount;

  const _AnimatedCategoryCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
    required this.onTap,
    required this.showNotifications,
    this.notificationCount = 0,
  });

  @override
  State<_AnimatedCategoryCard> createState() => _AnimatedCategoryCardState();
}

class _AnimatedCategoryCardState extends State<_AnimatedCategoryCard>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        Future.delayed(const Duration(milliseconds: 100), widget.onTap);
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(_isPressed ? 0.97 : 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.gradientColors[0].withOpacity(
                  _isPressed ? 0.2 : 0.15,
                ),
                spreadRadius: 0,
                blurRadius: _isPressed ? 15 : 20,
                offset: Offset(0, _isPressed ? 3 : 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Shimmer Effect
              AnimatedBuilder(
                animation: _shimmerController,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0),
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon Container
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: widget.gradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: widget.gradientColors[0].withOpacity(0.3),
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(widget.icon, size: 30, color: Colors.white),
                    ),

                    // Notification Badge
                    if (widget.showNotifications) ...{
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: widget.gradientColors[0].withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.notifications_active,
                              size: 14,
                              color: widget.gradientColors[0],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.notificationCount.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: widget.gradientColors[0],
                              ),
                            ),
                          ],
                        ),
                      ),
                    },
                    const SizedBox(height: 12),

                    // Text Content
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedNotificationsCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final VoidCallback onTap;
  final int stopNotifCnt;
  final int allNotifCnt;

  const _AnimatedNotificationsCard({
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.onTap,
    this.stopNotifCnt = 0,
    this.allNotifCnt = 0,
  });

  @override
  State<_AnimatedNotificationsCard> createState() =>
      _AnimatedNotificationsCardState();
}

class _AnimatedNotificationsCardState extends State<_AnimatedNotificationsCard>
    with TickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _shimmerController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        Future.delayed(const Duration(milliseconds: 100), widget.onTap);
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(_isPressed ? 0.97 : 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.gradientColors[0].withOpacity(
                  _isPressed ? 0.3 : 0.25,
                ),
                spreadRadius: 0,
                blurRadius: _isPressed ? 20 : 30,
                offset: Offset(0, _isPressed ? 5 : 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Shimmer Effect
              AnimatedBuilder(
                animation: _shimmerController,
                builder: (context, child) {
                  return Container(
                    width: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0),
                          Colors.white.withOpacity(0.2),
                          Colors.white.withOpacity(0),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Content - Split into Animated and Static sections
              Column(
                children: [
                  // Animated Icon Section
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Animated pulse circle
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Container(
                                width: 80 + (_pulseController.value * 10),
                                height: 80 + (_pulseController.value * 10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      widget.gradientColors[0].withOpacity(
                                        0.3 - (_pulseController.value * 0.2),
                                      ),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          // Main Icon Container
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: widget.gradientColors,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: widget.gradientColors[0].withOpacity(
                                    0.4,
                                  ),
                                  spreadRadius: 0,
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                // First notification icon
                                const Positioned(
                                  top: 12,
                                  left: 12,
                                  child: Icon(
                                    Icons.notifications_active,
                                    size: 28,
                                    color: Colors.white,
                                  ),
                                ),
                                // Second notification icon (overlapped)
                                const Positioned(
                                  bottom: 12,
                                  right: 12,
                                  child: Icon(
                                    Icons.notification_important,
                                    size: 28,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Notification Badge (Animated)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: AnimatedBuilder(
                              animation: _pulseController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: 1.0 + (_pulseController.value * 0.2),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.red.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      widget.stopNotifCnt.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Static Text Section (NO ANIMATION)
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        children: [
                          // Notification Count Badge (Static)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: widget.gradientColors[0].withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.notifications_active,
                                  size: 14,
                                  color: widget.gradientColors[0],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.allNotifCnt.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: widget.gradientColors[0],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Title (Static)
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 4),

                          // Subtitle (Static)
                          Text(
                            widget.subtitle,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
