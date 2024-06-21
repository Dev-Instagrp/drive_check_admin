import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/employee_setting_controller.dart';

class EmployeeSettingMobile extends StatelessWidget {
  final EmployeeSettingController _employeeSettingController = Get.put(EmployeeSettingController());
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Settings'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search employees...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                _employeeSettingController.searchEmployees(value.trim());
              },
            ),
          ),
          Expanded(
            child: Obx(
                  () => _employeeSettingController.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : _buildEmployeeList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeList() {
    return ListView.builder(
      itemCount: _employeeSettingController.filteredEmployees.length,
      itemBuilder: (context, index) {
        final employee = _employeeSettingController.filteredEmployees[index];
        return ListTile(
          leading: Icon(Icons.person),
          title: Text(employee.name),
          subtitle: Text(employee.email),
          onTap: () {
            _employeeSettingController.showEditPopup(employee);
          },
        );
      },
    );
  }
}
