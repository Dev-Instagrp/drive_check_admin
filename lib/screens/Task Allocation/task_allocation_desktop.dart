import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:drive_check_admin/widgets/gradient_button.dart';
import 'package:drive_check_admin/widgets/input_field_new.dart';
import '../../controller/task_allocation_controller.dart';

class TaskAllocationDesktop extends StatelessWidget {
  const TaskAllocationDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController siteIDController = TextEditingController();
    final TextEditingController latitudeController = TextEditingController();
    final TextEditingController longitudeController = TextEditingController();

    final TaskAllocationController taskController = Get.put(TaskAllocationController());

    void clearInputs(){
      print("Clear method called");
      siteIDController.clear();
      latitudeController.clear();
      longitudeController.clear();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Task Allocation",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Allocate task to employee"),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: const Divider(),
            ),
            Row(
              children: [
                Expanded(child: NewInputField(controller: nameController, label: "Enter Name of Employee")),
                const SizedBox(width: 10,),
                Expanded(child: NewInputField(controller: siteIDController, label: "Enter Site ID")),
                const SizedBox(width: 10,),
                Expanded(child: NewInputField(controller: latitudeController, label: "Enter Latitude")),
                const SizedBox(width: 10,),
                Expanded(child: NewInputField(controller: longitudeController, label: "Enter Longitude")),
                const SizedBox(width: 10,),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Obx(() => taskController.isLoading.value
                  ? CircularProgressIndicator()
                  : GradientButton(
                colors: [const Color(0xFF9181F4), const Color(0xFF5038ED)],
                onTap: () {
                  if(taskController.done.isTrue) clearInputs();
                  taskController.isLoading.value = true;
                  taskController.allocateTask(
                    name: nameController.text,
                    siteID: siteIDController.text,
                    latitude: latitudeController.text,
                    longitude: longitudeController.text,
                  );
                },
                title: "Allocate",
                titleColor: Colors.white,
              ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: const Divider(),
            ),
            const ListTile(
              title: Text(""),
            ),
          ],
        ),
      ),
    );

  }
}
