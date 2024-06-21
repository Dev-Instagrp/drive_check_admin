import 'package:flutter/material.dart';

class NewInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  const NewInputField({super.key, required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15)
        )
      ),
    );
  }
}
