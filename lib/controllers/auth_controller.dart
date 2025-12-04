import 'dart:developer' as developer;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../app/app_routes.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  ConfirmationResult? _webConfirmationResult;

  final RxBool isLoading = false.obs;
  final Rxn<User> firebaseUser = Rxn<User>();
  final RxString verificationId = ''.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();

    if (kIsWeb) {
      _auth.setSettings(appVerificationDisabledForTesting: true);
    }

    firebaseUser.bindStream(_auth.authStateChanges());

    ever<User?>(firebaseUser, (user) {
      if (user != null) {
        Get.offAllNamed(AppRoutes.objects);
      }
    });
  }

  Future<void> sendOtp(String phoneNumber) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      if (kIsWeb) {
        developer.log('web: calling signInWithPhoneNumber');
        _webConfirmationResult = await _auth.signInWithPhoneNumber(
          phoneNumber,
        );
        developer.log('web: signInWithPhoneNumber resolved');
        verificationId.value =
            _webConfirmationResult?.verificationId ?? verificationId.value;
        Get.toNamed(AppRoutes.otp);
      } else {
        await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _auth.signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) {
            errorMessage.value = e.message ?? 'Verification failed';
            Get.snackbar('Error', errorMessage.value);
          },
          codeSent: (String verId, int? forceResendToken) {
            verificationId.value = verId;
            Get.toNamed(AppRoutes.otp);
          },
          codeAutoRetrievalTimeout: (String verId) {
            verificationId.value = verId;
          },
        );
      }
    } catch (e) {
      developer.log('sendOtp error', error: e);
      errorMessage.value = 'Failed to send OTP: $e';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp(String smsCode) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      if (kIsWeb) {
        final confirmationResult = _webConfirmationResult;
        if (confirmationResult == null) {
          errorMessage.value = 'Please request a new OTP.';
          Get.snackbar('Error', errorMessage.value);
          return;
        }
        await confirmationResult.confirm(smsCode);
      } else {
        final cred = PhoneAuthProvider.credential(
          verificationId: verificationId.value,
          smsCode: smsCode,
        );
        await _auth.signInWithCredential(cred);
      }
    } on FirebaseAuthException catch (e) {
      errorMessage.value = e.message ?? 'Invalid OTP or network issue';
      Get.snackbar('Error', errorMessage.value);
    } catch (e) {
      errorMessage.value = 'Failed to verify OTP: $e';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _webConfirmationResult = null;
    Get.offAllNamed(AppRoutes.login);
  }
}
