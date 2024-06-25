import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_check_admin/controller/data_fetch_controller.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

class FetchedDataCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String title;
  final OHSCheckController controller = Get.put(OHSCheckController());

  FetchedDataCard({Key? key, required this.data, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> textFields = [];
    List<Widget> imageFields = [];

    data.forEach((key, value) {
      if (value != null && value is String && value.isNotEmpty) {
        if (value.startsWith('http')) {
          imageFields.add(
            Container(
              child: Column(
                children: [
                  CachedNetworkImage(
                    placeholder: (context, url) => Container(height: 50, width: 50, child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    width: 100,
                    height: 100,
                    imageUrl: value,
                  ),
                  Text("Image: $key")
                ],
              ),
            ),
          );
        } else {
          if (key != 'uid' && key != 'Employee Name') {
            textFields.add(Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add horizontal padding for spacing
              child: Text('$key: $value'),
            ));
          }
        }
      }
    });

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(data['Employee Name'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(width: 100),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: textFields),
                  ),
                ),
              ],
            ),
            Divider(),
            if (imageFields.isNotEmpty) ...[
              SizedBox(height: 20),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 4,
                crossAxisSpacing: 5,
                mainAxisSpacing: 2,
                children: imageFields,
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: () => _verifyOHS(data), child: Text("Verify OHS")),
                  ElevatedButton(onPressed: () => _rejectOHS(data), child: Text("Reject OHS")),
                ],
              )
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _verifyOHS(Map<String, dynamic> data) async {
    try {
      String siteDate = '${controller.selectedDate.value.day.toString().padLeft(2, '0')}-${controller.selectedDate.value.month.toString()}-${controller.selectedDate.value.year}';
      await FirebaseFirestore.instance.collection('siteAllocation').doc('${controller.siteId.value}($siteDate)').update({'verified': true, 'state': 'OnSite'}).then((_) async{
        var querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('Employee Name', isEqualTo: data['Employee Name'])
            .limit(1)
            .get();

        if (querySnapshot.size > 0) {
          var doc = querySnapshot.docs[0];
          await doc.reference.update({'state': controller.state.value});
        } else {
          print('No matching document found.');
        }
      });
      Get.snackbar("Done", "OHS for employee is verified and employee is allowed to go on field");
    } catch (e) {
      print("Error verifying OHS: $e");
    }
  }

  Future<void> _rejectOHS(Map<String, dynamic> data) async {
    try {
      String siteDate = '${controller.selectedDate.value.day.toString().padLeft(2, '0')}-${controller.selectedDate.value.month.toString()}-${controller.selectedDate.value.year}';
      await FirebaseFirestore.instance.collection('siteAllocation').doc('${controller.siteId.value}($siteDate)').update({'verified': false, 'state': 'PreSite'}).then((_) async{
        var querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('Employee Name', isEqualTo: data['Employee Name'])
            .limit(1)
            .get();

        if (querySnapshot.size > 0) {
          var doc = querySnapshot.docs[0];
          await doc.reference.update({'state': controller.rejectedState.value});
        } else {
          print('No matching document found.');
        }
      });
      Get.snackbar("Oops!", "OHS for ${data['Employee Name']} is Rejected and employee needs to upload images again");
    } catch (e) {
      print("Error rejecting OHS: $e");
    }
  }
}
