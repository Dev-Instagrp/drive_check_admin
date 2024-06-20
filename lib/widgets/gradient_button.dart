import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final List<Color> colors;
  const GradientButton({super.key, required this.colors});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        //LoginFunction
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: colors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight
          )
        ),
      ),
    );
  }
}
