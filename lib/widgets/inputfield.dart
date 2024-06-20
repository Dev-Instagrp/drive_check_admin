import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;
  const InputField(
      {super.key,
      required this.controller,
      required this.label,
      required this.isPassword});

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * .35,
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: TextFormField(
            controller: widget.controller,
            obscureText: isObscure,
            decoration: InputDecoration(
                fillColor: Color(0xFFF0EDFF),
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none),
                labelText: widget.label,
            ),
          ),
        ),
        widget.isPassword
            ? TextButton(
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
                child:
                    isObscure ? Text("Show password", textAlign: TextAlign.left,) : Text("Hide password", textAlign: TextAlign.left,))
            : Container(),
      ],
    );
  }
}
