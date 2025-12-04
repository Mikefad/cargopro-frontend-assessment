import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/app_theme.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/validators.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final formKey = GlobalKey<FormState>();
    final otpController = TextEditingController();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.background),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Obx(
                      () => Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Enter verification code',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'We just sent an OTP to your phone. Enter it below to continue.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.black54),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: otpController,
                              decoration: const InputDecoration(
                                labelText: '6-digit code',
                                prefixIcon: Icon(Icons.password_rounded),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  requiredValidator(value, fieldName: 'OTP'),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: controller.isLoading.value
                                    ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : const Icon(Icons.verified_rounded),
                                label: Text(
                                  controller.isLoading.value
                                      ? 'Verifying...'
                                      : 'Verify & Continue',
                                ),
                                onPressed: controller.isLoading.value
                                    ? null
                                    : () {
                                        if (formKey.currentState?.validate() ??
                                            false) {
                                          controller.verifyOtp(
                                            otpController.text.trim(),
                                          );
                                        }
                                      },
                              ),
                            ),
                            if (controller.errorMessage.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Text(
                                  controller.errorMessage.value,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : Get.back,
                              child: const Text('Use another number'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
