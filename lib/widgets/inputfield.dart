import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;
  final Icon? icon; // Make icon nullable for optional usage

  const InputField({
    Key? key, // Add key parameter for better widget management
    required this.controller,
    required this.label,
    required this.isPassword,
    this.icon, // Make icon nullable for optional usage
  }) : super(key: key);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool isObscure = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start
      children: [
        Container(
          width: 365,
          height: 55,
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFFF0EDFF), // Use a consistent background color
          ),
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.isPassword && isObscure,
            decoration: InputDecoration(
              prefixIcon: widget.icon,
              prefixIconColor: Color(0xFF1C1C1C),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              labelText: widget.label,
            ),
          ),
        ),
        if (widget.isPassword) // Show toggle button only if it's a password field
          TextButton(
            onPressed: () {
              setState(() {
                isObscure = !isObscure;
              });
            },
            child: Text(
              isObscure ? "Show password" : "Hide password",
              textAlign: TextAlign.left,
            ),
          ),
      ],
    );
  }
}
