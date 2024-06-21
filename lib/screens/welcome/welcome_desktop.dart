import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:drive_check_admin/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import '../../utils/styleUtils.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/inputfield.dart';

class WelcomeDesktop extends StatelessWidget {
  final AuthController _loginController = Get.put(AuthController());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: RiveAnimation.asset(
                  "assets/riveassets/shapes.riv",
                  fit: BoxFit.cover,
                )),
          ],
        ),
        BlurryContainer(
          blur: 70,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListTile(
                        title: Text(
                          "Hello,",
                          style: StyleUtils.h1,
                          textAlign: TextAlign.center,
                        ),
                        subtitle: Text(
                          "Let's get started",
                          style: StyleUtils.h3,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      InputField(
                        controller: emailController,
                        label: "Enter Email",
                        isPassword: false,
                        icon: Icon(Icons.person_outline_rounded),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InputField(
                        controller: passwordController,
                        label: "Enter Password",
                        isPassword: true,
                        icon: Icon(Icons.lock_open_outlined),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Obx(
                        () => _loginController.isLoading.value
                            ? Center(
                                child: CircularProgressIndicator(color: Colors.blueAccent,),
                              )
                            : GradientButton(
                                colors: [Color(0xFF9181F4), Color(0xFF5038ED)],
                                onTap: () {
                                  _loginController.isLoading.value = true;
                                  _loginController.login(
                                      emailController.text.trim(),
                                      passwordController.text.trim());
                                },
                                title: 'Login',
                                titleColor: Colors.white,
                              ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
