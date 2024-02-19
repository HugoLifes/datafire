import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String validationMessage;

  CustomTextField({
    required this.controller,
    required this.labelText,
    required this.validationMessage,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
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
