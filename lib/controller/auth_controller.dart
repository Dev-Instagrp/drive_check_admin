import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/homescreen.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var isLoading = false.obs;

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      isLoading.value = false;
      Get.offAll(() => Homescreen(), transition: Transition.zoom);
    } on FirebaseAuthException catch (error) {
      isLoading.value = false;
      String errorMessage = '';

      switch (error.code) {
        case 'user-not-found':
          errorMessage = 'The email address you entered is not registered.';
          break;
        case 'invalid-password':
          errorMessage = 'The password you entered is incorrect.';
          break;
        case 'invalid-email':
          errorMessage = 'Please enter a valid email address.';
          break;
        case 'user-disabled':
          errorMessage = 'Your account has been disabled. Please contact support.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many login attempts. Please try again later.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Login is not allowed at this time.';
          break;
        default:
          errorMessage = 'An unknown error occurred. Please try again.';
      }

      Get.snackbar(
        'Login Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } catch (e) {
      // Handle other unforeseen exceptions
      isLoading.value = false;
      Get.snackbar(
        'An Error Occurred',
        'An unexpected error occurred during login. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      print('Login failed: $e');
    }
  }
}
