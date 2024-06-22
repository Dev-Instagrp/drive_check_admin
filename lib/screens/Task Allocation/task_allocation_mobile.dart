import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:drive_check_admin/widgets/gradient_button.dart';
import 'package:drive_check_admin/widgets/input_field_new.dart';
import '../../controller/task_allocation_controller.dart';
import 'dart:html' as html;
import 'package:excel/excel.dart';
import 'dart:typed_data';

class TaskAllocationMobile extends StatelessWidget {
  const TaskAllocationMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController siteIDController = TextEditingController();
    final TextEditingController latitudeController = TextEditingController();
    final TextEditingController longitudeController = TextEditingController();
    final TextEditingController searchController = TextEditingController();

    final TaskAllocationController taskController = Get.put(TaskAllocationController());
    final ScrollController scrollController = ScrollController();
    final RxBool showFAB = false.obs;

    void clearInputs() {
      nameController.clear();
      siteIDController.clear();
      latitudeController.clear();
      longitudeController.clear();
    }

    scrollController.addListener(() {
      if (scrollController.offset > 200) {
        showFAB.value = true;
      } else {
        showFAB.value = false;
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
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
            Expanded(
              child: ListView(
                controller: scrollController,
                children: [
                  NewInputField(controller: nameController, label: "Enter Name of Employee"),
                  const SizedBox(height: 10,),
                  NewInputField(controller: siteIDController, label: "Enter Site ID"),
                  const SizedBox(height: 10,),
                  NewInputField(controller: latitudeController, label: "Enter Latitude"),
                  const SizedBox(height: 10,),
                  NewInputField(controller: longitudeController, label: "Enter Longitude"),
                  const SizedBox(height: 10,),
                  Center(
                    child: Obx(() => taskController.isLoading.value
                        ? CircularProgressIndicator()
                        : GradientButton(
                      colors: [const Color(0xFF9181F4), const Color(0xFF5038ED)],
                      onTap: () {
                        if (taskController.done.isTrue) clearInputs();
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
                  const SizedBox(height: 10,),
                  Center(
                    child: GradientButton(
                      colors: [const Color(0xFF9181F4), const Color(0xFF5038ED)],
                      onTap: () {
                        pickFile(taskController);
                      },
                      title: "Bulk Allocate",
                      titleColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: const Divider(),
                  ),
                  const Text("Allocated Tasks"),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: 'Search Tasks',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        taskController.filterTasks(value);
                      },
                    ),
                  ),
                  Obx(() {
                    if (taskController.isLoadingTasks.value) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: taskController.filteredTasks.length,
                        itemBuilder: (context, index) {
                          final task = taskController.filteredTasks[index];
                          return ListTile(
                            title: Text("Employee Name: ${task['Employee Name']}"),
                            subtitle: Text("Site ID: ${task['siteID']}, Latitude: ${task['latitude']}, Longitude: ${task['longitude']}, Date: ${task['allocatedDate']}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    // Handle edit task
                                    taskController.editTask(task);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    // Handle delete task
                                    taskController.deleteTask(task['siteID'], task['allocatedDate']);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(() => showFAB.value
          ? FloatingActionButton(
        onPressed: () {
          scrollController.animateTo(
            0,
            duration: Duration(seconds: 1),
            curve: Curves.easeInOut,
          );
        },
        child: Icon(Icons.arrow_upward),
      )
          : Container()),
    );
  }

  void pickFile(TaskAllocationController taskController) {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = '.xlsx';
    uploadInput.multiple = false;

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files?.length == 1) {
        final file = files?.first;
        final reader = html.FileReader();

        reader.onLoadEnd.listen((e) {
          final content = reader.result as Uint8List;
          var excel = Excel.decodeBytes(content);

          for (var table in excel.tables.keys) {
            for (var row in excel.tables[table]?.rows ?? []) {
              if (row.length >= 4) {
                String name = row[0]?.value?.toString() ?? '';
                String siteID = row[1]?.value?.toString() ?? '';
                String latitude = row[2]?.value?.toString() ?? '';
                String longitude = row[3]?.value?.toString() ?? '';

                taskController.allocateTask(
                  name: name,
                  siteID: siteID,
                  latitude: latitude,
                  longitude: longitude,
                );
              }
            }
          }
        });

        reader.readAsArrayBuffer(file as html.Blob);
      }
    });

    uploadInput.click();
  }
}
