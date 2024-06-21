import 'package:drive_check_admin/screens/Responsiveness/responsive.dart';
import 'package:drive_check_admin/screens/welcome/welcome_desktop.dart';
import 'package:drive_check_admin/screens/welcome/welcome_mobile.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Responsive(
        mobile: WelcomeMobile(),
        tablet: WelcomeDesktop(),
        desktop: WelcomeDesktop()
    );
  }
}
