import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controller/data_fetch_controller.dart';
import '../widgets/fetched_data_card.dart';

class OHSCheck extends StatelessWidget {
  OHSCheck({Key? key}) : super(key: key);
  static const String routeName = '/ohsId';
  
  DateTime? globalPickedDate;
  

  @override
  Widget build(BuildContext context) {
    final OHSCheckController controller = Get.put(OHSCheckController());
    final TextEditingController siteIDController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('OHS Check'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Select Employee:'),
                  SizedBox(
                    width: 10,
                  ),
                  FutureBuilder<QuerySnapshot>(
                    future:
                        FirebaseFirestore.instance.collection('users').get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final List<String> employees = ['Select Employee'] +
                            snapshot.data!.docs
                                .map((doc) => doc['Employee Name'] as String)
                                .toList();
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Obx(() => DropdownButton<String>(
                                value: controller.selectedEmployee.value,
                                onChanged: (value) {
                                  controller.selectedEmployee.value = value!;
                                },
                                underline: Container(),
                                items: employees.map<DropdownMenuItem<String>>(
                                    (String employee) {
                                  return DropdownMenuItem<String>(
                                    value: employee,
                                    child: Text(employee),
                                  );
                                }).toList(),
                              )),
                        );
                      }
                    },
                  ),
                  SizedBox(width: 20),
                  Text('Site ID:'),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: siteIDController,
                      decoration: InputDecoration(
                        labelText: "Enter Site ID",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)
                        )
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Text('Select Type:'),
                  SizedBox(width: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Obx(() => DropdownButton<String>(
                          value: controller.selectedType.value,
                          onChanged: (value) {
                             controller.selectedType.value = value!;
                          },
                          underline: Container(),
                          items: [
                            'Activity Type',
                            'PreSiteData',
                            'OnSiteData',
                            'PostSiteData'
                          ].map<DropdownMenuItem<String>>((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                        )),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _selectDate(context, controller);
                    },
                    child: Obx(() => Text(
                      controller.selectedDate.value != null
                          ? controller.selectedDate.value.toString()
                          : "Select Date",
                    )),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  controller.siteId.value = siteIDController.text.trim()+"${controller.siteId.value}";
                  controller.fetchData(siteIDController.text.trim());
                },
                child: Text('Fetch Data'),
              ),
              SizedBox(height: 20),
              Obx(() {
                if (controller.fetchedData.isEmpty) {
                  return Text('No data available');
                } else {
                  return FetchedDataCard(
                    data: Map<String, dynamic>.from(controller.fetchedData),
                    title: 'Fetched Data',
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(
      BuildContext context, OHSCheckController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != controller.selectedDate.value) {
      controller.selectedDate.value = pickedDate;
    }
  }
}