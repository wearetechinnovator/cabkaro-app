import 'package:flutter/material.dart';

enum ToastType { success, error, info, warning }

class ToastWidget {
  static void show(
    BuildContext context, {
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context);

    // Colors per type
    final config = _toastConfig(type);

    final overlayEntry = OverlayEntry(
      builder: (context) => _ToastOverlay(
        message: message,
        icon: config['icon'] as IconData,
        backgroundColor: config['backgroundColor'] as Color,
        textColor: config['textColor'] as Color,
        iconColor: config['iconColor'] as Color,
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }

  static Map<String, dynamic> _toastConfig(ToastType type) {
    switch (type) {
      case ToastType.success:
        return {
          'icon': Icons.check_circle_outline_rounded,
          'backgroundColor': const Color(0xFF1E7E34),
          'textColor': Colors.white,
          'iconColor': Colors.white,
        };
      case ToastType.error:
        return {
          'icon': Icons.error_outline_rounded,
          'backgroundColor': const Color(0xFFC0392B),
          'textColor': Colors.white,
          'iconColor': Colors.white,
        };
      case ToastType.warning:
        return {
          'icon': Icons.warning_amber_rounded,
          'backgroundColor': const Color(0xFFF39C12),
          'textColor': Colors.black,
          'iconColor': Colors.black,
        };
      case ToastType.info:
        return {
          'icon': Icons.info_outline_rounded,
          'backgroundColor': const Color(0xFF2D2F35),
          'textColor': Colors.white,
          'iconColor': Colors.white,
        };
    }
  }
}

class _ToastOverlay extends StatefulWidget {
  final String message;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;

  const _ToastOverlay({
    required this.message,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
  });

  @override
  State<_ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<_ToastOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.07,
      left: 24,
      right: 24,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(widget.icon, color: widget.iconColor, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: TextStyle(
                        color: widget.textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
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