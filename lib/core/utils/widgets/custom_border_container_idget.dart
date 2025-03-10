import 'package:flutter/material.dart';

class CustomBorderContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double borderWidth;
  final Color? borderColor;
  final EdgeInsets padding;
  final EdgeInsets margin;

  const CustomBorderContainer({
    super.key,
    required this.child,
    this.borderRadius = 15.0,
    this.borderWidth = 1.5,
    this.borderColor ,
    this.padding = const EdgeInsets.all(12.0),
    this.margin = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.transparent, // No background color
        border: Border.all(
          color: borderColor??Theme.of(context).primaryColor,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child, // The widget you pass inside
    );
  }
}
