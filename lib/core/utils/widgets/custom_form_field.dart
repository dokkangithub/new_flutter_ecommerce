import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final bool isPassword;
  final bool isReadOnly;
  final bool autoFocus;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextStyle? textStyle;
  final double borderRadius;

  const CustomTextFormField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.isPassword = false,
    this.isReadOnly = false,
    this.autoFocus = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.textStyle,
    this.borderRadius = 25.0, // Set border radius to 25
  });

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _isObscured = true;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: _isFocused
            ? [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ]
            : [
          BoxShadow(
            color: Colors.black12.withValues(alpha:0.05),
            blurRadius: 1,
            offset: const Offset(0.2, 0.2),
          ),
        ],
      ),
      child: TextFormField(
        focusNode: _focusNode,
        controller: widget.controller,
        obscureText: widget.isPassword ? _isObscured : false,
        readOnly: widget.isReadOnly,
        autofocus: widget.autoFocus,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onFieldSubmitted,
        validator: widget.validator,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        maxLength: widget.maxLength,
        style: widget.textStyle ?? Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: const TextStyle(color: Colors.black54),
          hintText: widget.hint,
          hintStyle: const TextStyle(color: Colors.black54),
          errorText: widget.errorText,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.isPassword
              ? IconButton(
            icon: Icon(
              _isObscured ? Icons.visibility_off : Icons.visibility,
              color: Theme.of(context).primaryColor.withOpacity(0.3),
            ),
            onPressed: () {
              setState(() {
                _isObscured = !_isObscured;
              });
            },
          )
              : widget.suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25), // Rounded border
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25), // Rounded border
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25), // Rounded border
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25), // Rounded border
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25), // Rounded border
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
