import 'package:drive_check_admin/screens/Employee%20Setting/employee_setting_desktop.dart';
import 'package:drive_check_admin/screens/Employee%20Setting/employee_setting_mobile.dart';
import 'package:drive_check_admin/screens/Responsiveness/responsive.dart';
import 'package:flutter/material.dart';

class EmployeeSettings extends StatelessWidget {
  const EmployeeSettings({super.key});
  static const String routeName = '/empSettingId';

  @override
  Widget build(BuildContext context) {
    return Responsive(mobile: EmployeeSettingMobile(), tablet: EmployeeSettingDesktop(), desktop: EmployeeSettingDesktop());
  }
}
