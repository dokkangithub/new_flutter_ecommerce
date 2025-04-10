import 'package:flutter/material.dart';
import '../../config/themes.dart/theme.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String? label;
  final String? hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final Widget? prefixIcon;
  final bool isLoading;
  final double borderRadius;

  const CustomDropdown({
    Key? key,
    this.label,
    this.hint,
    this.value,
    required this.items,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.isLoading = false,
    this.borderRadius = 25.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = AppTheme.accentColor.withValues(alpha: 0.2);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: DropdownButtonFormField<T>(
          value: value,
          items: isLoading ? [] : items,
          onChanged: isLoading ? null : onChanged,
          validator: validator,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.black54),
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black54),
            prefixIcon: prefixIcon,
            // Remove all borders
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none,
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: backgroundColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
          ),
          icon: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ),
                )
              : const Icon(Icons.arrow_drop_down),
          dropdownColor: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          isExpanded: true,
        ),
      ),
    );
  }
}
