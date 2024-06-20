import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OHSCheckController extends GetxController {
  var selectedEmployee = 'Select Employee'.obs;
  var selectedType = 'Activity Type'.obs;
  var selectedDate = DateTime.now().obs;
  var fetchedData = <String, dynamic>{}.obs;

  Future<void> fetchData() async {
    if (selectedEmployee.value == 'Select Employee' || selectedType.value == 'Activity Type') {
      showSnackbar('Error', 'Please select both employee and type');
      return;
    }

    String formattedDate = '${selectedDate.value.year}-${selectedDate.value.month.toString().padLeft(2, '0')}-${selectedDate.value.day.toString().padLeft(2, '0')}';

    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('Employee Name', isEqualTo: selectedEmployee.value)
          .limit(1)
          .get();

      if (userSnapshot.docs.isEmpty) {
        showSnackbar('Error', 'No user found');
        return;
      }

      String userId = userSnapshot.docs.first.id;

      DocumentSnapshot dataSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection(selectedType.value)
          .doc(formattedDate)
          .get();

      if (dataSnapshot.exists) {
        var data = dataSnapshot.data() as Map<String, dynamic>;
        data['uid'] = userId;
        data['Employee Name'] = selectedEmployee.value;
        fetchedData.value = data;
      } else {
        fetchedData.value = {};
        showSnackbar('Error', 'No data found for the selected date and type');
      }
    } catch (e) {
      fetchedData.value = {};
      showSnackbar('Error', 'Error fetching data: $e');
    }
  }

  void showSnackbar(String title, String message) {
    Get.snackbar(title, message);
  }
}
