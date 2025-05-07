import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/theme_service.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool isPassword;
  final bool isPasswordVisible;
  final Function()? onTogglePasswordVisibility;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final int? maxLines;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final Function()? onTap;
  final Function(String)? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.hint,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.onTogglePasswordVisibility,
    this.onChanged,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.onTap,
    this.onSubmitted,
    this.inputFormatters,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  // Pre-compute decoration once and reuse
  late final InputDecoration _decoration;
  late final Widget? _suffixIconWidget;
  
  @override
  void initState() {
    super.initState();
    
    // Calculate suffix icon once
    if (widget.isPassword) {
      _suffixIconWidget = IconButton(
        icon: Icon(
          widget.isPasswordVisible ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey,
        ),
        onPressed: widget.onTogglePasswordVisibility,
      );
    } else {
      _suffixIconWidget = widget.suffixIcon;
    }
    
    // Pre-compute decoration once
    _decoration = ThemeService.inputDecoration(
      labelText: widget.label,
      hintText: widget.hint,
      prefixIcon: widget.prefixIcon,
      suffixIcon: _suffixIconWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword && !widget.isPasswordVisible,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      onChanged: widget.onChanged,
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      textInputAction: widget.textInputAction,
      focusNode: widget.focusNode,
      onTap: widget.onTap,
      onFieldSubmitted: widget.onSubmitted,
      inputFormatters: widget.inputFormatters,
      style: const TextStyle(fontSize: 16),
      decoration: _decoration,
    );
  }
} 