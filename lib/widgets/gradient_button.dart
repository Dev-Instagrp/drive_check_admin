import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  List<Color> colors;
  final VoidCallback onTap;
  final String title;
  final Color titleColor;
  GradientButton({super.key, required this.colors, required this.onTap, required this.title, required this.titleColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashFactory: InkSplash.splashFactory,
      overlayColor: WidgetStateColor.transparent,
      splashColor: Color(0xFF5038ED),
      child: Container(
        width: 125,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.16),
                  offset: Offset(0, 8),
                  blurRadius: 21
              )
            ],
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
                colors: colors,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight
            )
        ),
        child: Text(title, style: TextStyle(color: titleColor, fontWeight: FontWeight.bold),),
      ),
    );
  }
}
