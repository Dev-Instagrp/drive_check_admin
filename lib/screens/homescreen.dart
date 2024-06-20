import 'package:drive_check_admin/screens/dashboard.dart';
import 'package:drive_check_admin/screens/employee_settings.dart';
import 'package:drive_check_admin/screens/ohs_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';


class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {

  Widget _selectedScreen = Dashboard();
  screenSelector(item){
    switch(item.route){
      case Dashboard.routeName:
        setState(() {
          _selectedScreen = Dashboard();
        });
        break;
      case OHSCheck.routeName:
        setState(() {
          _selectedScreen = OHSCheck();
        });
        break;

      case EmployeeSettings.routeName:
        setState(() {
          _selectedScreen = EmployeeSettings();
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('DriveCheck Admin panel'),
        centerTitle: true,
      ),
      sideBar: SideBar(
        textStyle: TextStyle(
          color: Colors.black
        ),
        items: [
          AdminMenuItem(
            title: 'Dashboard',
            route: Dashboard.routeName,
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'Check OHS',
            icon: Icons.health_and_safety_outlined,
            route: OHSCheck.routeName
          ),
          AdminMenuItem(
            title: 'Employee Settings',
            icon: Icons.settings,
            route: EmployeeSettings.routeName
          ),
        ],
        selectedRoute: '/',
        onSelected: (item) {
          screenSelector(item);
        },
      ),
      body: _selectedScreen
    );
  }
}
