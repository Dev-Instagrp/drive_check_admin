import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TaskAllocationController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Rx<bool> isLoading = false.obs;
  Rx<bool> done = false.obs;
  Rx<bool> isLoadingTasks = false.obs;
  Rx<bool> showFAB = false.obs;
  RxList<Map<String, dynamic>> allocatedTasks = RxList<Map<String, dynamic>>();
  RxList<Map<String, dynamic>> filteredTasks = RxList<Map<String, dynamic>>();
  DateTime today = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  void allocateTask({
    required String name,
    required String siteID,
    required String latitude,
    required String longitude,
  }) async {
    String year = today.year.toString();
    String month = today.month.toString();
    String day = today.day.toString();
    String date = "$day-$month-$year";
    if (name.isEmpty || siteID.isEmpty || latitude.isEmpty || longitude.isEmpty) {
      Get.snackbar("Error", "All fields must be filled");
      isLoading.value = false;
      return;
    }

    try {
      var userDoc = await _firestore.collection('users').where('Employee Name', isEqualTo: name).get();
      if (userDoc.docs.isEmpty) {
        Get.snackbar("Error", "$name is not in your circle or check name again");
      } else {
        await _firestore.collection('siteAllocation').doc("$siteID($date)").set({
          'Employee Name': name,
          'siteID': siteID,
          'latitude': latitude,
          'longitude': longitude,
          'allocatedDate': date,
        });
        // After successful task allocation user profile will be updated with the task allocated.
        var userId = userDoc.docs.first.id;
        await _firestore.collection('users').doc(userId).set({
          'Site ID': siteID,
          'Allocated Date': date
        }, SetOptions(merge: true));
        Get.snackbar("Success", "Task allocated successfully to $name");
        fetchTasks(); // Refresh the task list
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
      done.value = true;
    }
  }

  void fetchTasks() async {
    isLoadingTasks.value = true;
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('siteAllocation').get();
      allocatedTasks.value = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      filteredTasks.value = allocatedTasks;
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoadingTasks.value = false;
    }
  }

  void filterTasks(String query) {
    if (query.isEmpty) {
      filteredTasks.value = allocatedTasks;
    } else {
      filteredTasks.value = allocatedTasks.where((task) {
        return task['Employee Name'].toLowerCase().contains(query.toLowerCase()) ||
            task['siteID'].toLowerCase().contains(query.toLowerCase()) ||
            task['latitude'].toLowerCase().contains(query.toLowerCase()) ||
            task['longitude'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  void editTask(Map<String, dynamic> task) {
    // Logic to edit task
  }

  void deleteTask(String siteID, String date) async {
    isLoadingTasks.value = true;
    try {
      await _firestore.collection('siteAllocation').doc(siteID+"(${date})").delete();
      Get.snackbar("Success", "Task deleted successfully");
      fetchTasks();
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoadingTasks.value = false;
    }
  }
}