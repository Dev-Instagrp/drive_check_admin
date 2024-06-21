import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  String uid; // Firestore document ID (uid)
  String id;
  String name;
  String email;
  String phoneNumber;

  Employee({
    required this.uid,
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  factory Employee.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Employee(
      uid: doc.id, // Using uid as the Firestore document ID
      id: data['Employee ID'] ?? '',
      name: data['Employee Name'] ?? '',
      email: data['Email'] ?? '',
      phoneNumber: data['Phone Number'] ?? '',
    );
  }
}

class EmployeeSettingController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;
  var employees = <Employee>[].obs;
  var filteredEmployees = <Employee>[].obs;
  var editEmployee = Employee(uid: '', name: '', email: '', phoneNumber: '', id: '').obs;

  @override
  void onInit() {
    fetchEmployees();
    super.onInit();
  }

  Future<void> fetchEmployees() async {
    try {
      isLoading.value = true;
      QuerySnapshot querySnapshot = await _firestore.collection('users').limit(5).get();

      employees.assignAll(querySnapshot.docs.map((doc) => Employee.fromFirestore(doc)).toList());
      filteredEmployees.assignAll(employees); // Initialize filtered list with all employees
    } catch (e) {
      print('Error fetching employees: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void showEditPopup(Employee employee) {
    editEmployee.value = employee;
    Get.dialog(EditEmployeePopup(employee: employee));
  }

  void saveEmployeeChanges(String newName, String newEmail, String newPhoneNumber) async {
    try {
      isLoading.value = true;
      await _firestore.collection('users').doc(editEmployee.value.uid).update({
        'Employee Name': newName,
        'Email': newEmail,
        'Phone Number': newPhoneNumber,
      });
      // Update local data
      editEmployee.update((val) {
        val!.name = newName;
        val.email = newEmail;
        val.phoneNumber = newPhoneNumber;
      });
      Get.back(); // Close the edit popup
    } catch (e) {
      print('Error updating employee: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void searchEmployees(String query) {
    if (query.isEmpty) {
      filteredEmployees.assignAll(employees); // Reset to all employees if query is empty
    } else {
      // Perform case-insensitive search
      var searchResults = employees.where((employee) =>
      employee.name.toLowerCase().contains(query.toLowerCase()) ||
          employee.email.toLowerCase().contains(query.toLowerCase()) ||
          employee.phoneNumber.toLowerCase().contains(query.toLowerCase()));
      filteredEmployees.assignAll(searchResults.toList());
    }
  }
}

class EditEmployeePopup extends StatelessWidget {
  final Employee employee;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  EditEmployeePopup({required this.employee}) {
    nameController.text = employee.name;
    emailController.text = employee.email;
    phoneNumberController.text = employee.phoneNumber;
    idController.text = employee.id;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Employee'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: idController,
            decoration: InputDecoration(labelText: 'Employee ID'),
          ), // Display uid
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Employee Name'),
          ),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextFormField(
            controller: phoneNumberController,
            decoration: InputDecoration(labelText: 'Phone Number'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Get.find<EmployeeSettingController>().saveEmployeeChanges(
              nameController.text.trim(),
              emailController.text.trim(),
              phoneNumberController.text.trim(),
            );
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}