import 'package:flutter/material.dart';
import '../../../config/themes.dart/theme.dart';
import 'custom_loading.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final Color? color;
  final String? icon;
  final Color? splashColor;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final VoidCallback? onPressed;
  final double? borderRadius;
  final Duration? animationDuration;
  final TextStyle? textStyle;
  final bool isLoading;
  final double? loadingIndicatorSize;

  const CustomButton({
    super.key,
    required this.text,
    this.color,
    this.splashColor,
    this.padding,
    this.elevation,
    this.onPressed,
    this.borderRadius,
    this.animationDuration,
    this.textStyle,
    this.isLoading = false,
    this.loadingIndicatorSize = 24.0,
    this.icon,
  });

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration ?? const Duration(milliseconds: 150),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedScale(
        scale: _scaleAnimation.value,
        duration: widget.animationDuration ?? const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Material(
          color: widget.color ?? Theme.of(context).primaryColor,
          elevation: widget.elevation ?? 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 25.0),
          ),
          child: InkWell(
            splashColor: widget.splashColor ?? Theme.of(context).splashColor,
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.0),
            child: Container(
              padding: widget.padding ??
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: widget.isLoading
                  ? const Center(
                      child: CustomLoadingWidget(),
                    )
                  : Row(
                      spacing: 4,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        widget.icon != null
                            ? Image.asset(
                                widget.icon!,
                                width: 30,
                                height: 30,
                                color: AppTheme.white,
                              )
                            : const SizedBox.shrink(),
                        Text(
                          widget.text,
                          style: widget.textStyle ??
                              Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(color: AppTheme.white),
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
