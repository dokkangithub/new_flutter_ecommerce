import 'package:flutter/material.dart';
import '../../../../core/utils/widgets/custom_button.dart';

class SaveAddressButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final bool isEditing;

  const SaveAddressButton({
    Key? key,
    required this.isLoading,
    required this.onPressed,
    required this.isEditing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: isEditing ? 'Update Address' : 'Add Address',
      onPressed: isLoading ? null : onPressed,
      isLoading: isLoading,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      textStyle: const TextStyle(fontSize: 16),
      borderRadius: 8.0,
    );
  }
}
