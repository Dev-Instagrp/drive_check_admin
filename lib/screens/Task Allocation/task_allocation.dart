import 'package:drive_check_admin/screens/Responsiveness/responsive.dart';
import 'package:drive_check_admin/screens/Task%20Allocation/task_allocation_desktop.dart';
import 'package:drive_check_admin/screens/Task%20Allocation/task_allocation_mobile.dart';
import 'package:flutter/material.dart';

class TaskAllocation extends StatelessWidget {
  const TaskAllocation({super.key});
  static const String routeName = '/taskAllocationID';

  @override
  Widget build(BuildContext context) {
    return Responsive(mobile: TaskAllocationMobile(), tablet: TaskAllocationDesktop(), desktop: TaskAllocationDesktop());
  }
}
