import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String validationMessage;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.validationMessage,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        fontFamily: 'GoogleSans',
      ),
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        fillColor: Colors.white,
        filled: true,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return validationMessage;
        }
        return null;
      },
    );
  }
}
