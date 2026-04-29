import 'package:flutter/material.dart';

/// An animated, interactive card widget used on the selection screen.
/// Matches the design language of ManagementView's _StunningInteractiveCard.
class SelectionCardWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;

  const SelectionCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<SelectionCardWidget> createState() => _SelectionCardWidgetState();
}

class _SelectionCardWidgetState extends State<SelectionCardWidget>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
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
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        Future.delayed(const Duration(milliseconds: 150), widget.onTap);
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..scale(_isPressed ? 0.95 : 1.0),
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: widget.gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.gradient.last.withOpacity(_isPressed ? 0.6 : 0.3),
              blurRadius: _isPressed ? 20 : 12,
              offset: Offset(0, _isPressed ? 8 : 5),
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
                opacity: _isPressed ? 0.4 : 0.15,
                child: Transform.rotate(
                  angle: -0.2,
                  child: Icon(widget.icon, size: 130, color: Colors.white),
                ),
              ),
            ),

            // Top shine effect
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

            // Content row
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon container
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

                  // Text content
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

                  // Pulsing arrow badge
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
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20,
                          color: widget.gradient.first,
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
