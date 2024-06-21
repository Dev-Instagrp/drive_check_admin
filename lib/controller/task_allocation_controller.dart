import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TaskAllocationController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Rx<bool> isLoading = false.obs;
  Rx<bool> done = false.obs;
  DateTime today = DateTime.now();


  void allocateTask({
    required String name,
    required String siteID,
    required String latitude,
    required String longitude,
  }) async {
    String year = today.year.toString();
    String month = today.month.toString();
    String day = today.day.toString();
    String date = day+"-"+month+"-"+year;
    if (name.isEmpty || siteID.isEmpty || latitude.isEmpty || longitude.isEmpty) {
      Get.snackbar("Error", "All fields must be filled");
      isLoading.value = false;
      return;
    }

    try {
      var userDoc = await _firestore.collection('users').where('Employee Name', isEqualTo: name).get();
      if (userDoc.docs.isEmpty) {
        Get.snackbar("Error", "Employee not in your circle or check employee name again");
      } else {
        await _firestore.collection('siteAllocation').doc(siteID + "(${date})").set({
          'Employee Name': name,
          'siteID': siteID,
          'latitude': latitude,
          'longitude': longitude,
          'timestamp': FieldValue.serverTimestamp(),
        });
        // After successful task allocation user profile will be updated with the task allocated.
        var userId = userDoc.docs.first.id;
        await _firestore.collection('users').doc(userId).set({
          'Site ID': siteID,
          'Allocated Date': date
        }, SetOptions(merge: true));
        Get.snackbar("Success", "Task allocated successfully");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
      done.value = true;
    }
  }
}
