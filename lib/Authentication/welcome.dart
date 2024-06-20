import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:drive_check_admin/utils/styleUtils.dart';
import 'package:drive_check_admin/widgets/inputfield.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Stack(
      children: [
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width*0.5,
            ),
            SizedBox( width: MediaQuery.of(context).size.width*0.5,child: RiveAnimation.asset("assets/riveassets/shapes.riv", fit: BoxFit.cover,)),
          ],
        ),
        BlurryContainer(
          blur: 70,
            child: Row(
          children: [
            Expanded(
                child: Container(
                  alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * .5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListTile(
                        title: Text("Hello,", style: StyleUtils.h1, textAlign: TextAlign.center,),
                        subtitle: Text("Let's get started", style: StyleUtils.h3,textAlign: TextAlign.center,),
                      ),
                      InputField(controller: emailController, label: "Enter Email", isPassword: false,),
                      SizedBox(
                        height: 20,
                      ),
                      InputField(controller: passwordController, label: "Enter Password", isPassword: true,),
                    ],
                  ),
            )
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .5,
            )
          ],
        ))
      ],
    );
  }
}
