import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback onProjectTap;
  final VoidCallback onAttachmentsTap;
  final VoidCallback onPermissionsTap;
  final VoidCallback onNotificationTap;

  const ActionButtonsWidget({
    super.key,
    required this.onProjectTap,
    required this.onAttachmentsTap,
    required this.onPermissionsTap,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: size.width > 600 ? 4 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.0,
          children: [
            _buildActionButton(
              context,
              icon: Icons.folder_special_rounded,
              label: l10n.projectButton,
              gradientColors: [
                const Color(0xFF4F46E5),
                const Color(0xFF6366F1),
              ],
              onTap: onProjectTap,
            ),
            _buildActionButton(
              context,
              icon: Icons.attach_file_rounded,
              label: l10n.attachmentsButton,
              gradientColors: [
                const Color(0xFFEC4899),
                const Color(0xFFF97316),
              ],
              onTap: onAttachmentsTap,
            ),
            _buildActionButton(
              context,
              icon: Icons.verified_user_rounded,
              label: l10n.permissionsButton,
              gradientColors: [
                const Color(0xFF10B981),
                const Color(0xFF059669),
              ],
              onTap: onPermissionsTap,
            ),
            _buildActionButton(
              context,
              icon: Icons.notification_add_rounded,
              label: l10n.createNotificationButton,
              gradientColors: [
                const Color(0xFF8B5CF6),
                const Color(0xFF7C3AED),
              ],
              onTap: onNotificationTap,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return _AnimatedActionButton(
      icon: icon,
      label: label,
      gradientColors: gradientColors,
      onTap: onTap,
    );
  }
}

class _AnimatedActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _AnimatedActionButton({
    required this.icon,
    required this.label,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  State<_AnimatedActionButton> createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<_AnimatedActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _controller.forward();
      },
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () {
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: widget.gradientColors[0].withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: Colors.white, size: 32),
              const SizedBox(height: 8),
              Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
