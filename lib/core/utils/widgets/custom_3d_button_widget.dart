import 'package:flutter/material.dart';

class Custom3DButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Color? color;
  final Color textColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final bool isDisabled;
  final double elevation;

  const Custom3DButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.color, // Default to primary color
    this.textColor = Colors.white,
    this.width,
    this.height,
    this.borderRadius = 15,
    this.isDisabled = false,
    this.elevation = 8.0, // 3D effect
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onPressed,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 50,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDisabled ? Colors.grey : (color ?? Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            if (!isDisabled)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                offset: const Offset(4, 4),
                blurRadius: elevation,
              ),
          ],
        ),
        child: child,
      ),
    );
  }
}
