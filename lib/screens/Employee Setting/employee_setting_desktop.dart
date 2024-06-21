import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/employee_setting_controller.dart';

class EmployeeSettingDesktop extends StatelessWidget {
  final EmployeeSettingController _employeeSettingController = Get.put(EmployeeSettingController());
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Settings'),
      ),
      body: Row(
        children: [
          SizedBox(
            width: 250, // Width of sidebar for filters or additional options
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search employees...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      )
                    ),
                    onChanged: (value) {
                      _employeeSettingController.searchEmployees(value.trim());
                    },
                  ),
                ),
                // Add additional filters or options as needed
              ],
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