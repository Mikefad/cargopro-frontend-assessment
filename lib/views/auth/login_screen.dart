import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/app_theme.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/validators.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final formKey = GlobalKey<FormState>();
    final phoneController = TextEditingController();

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
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.teal.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: const Icon(
                                Icons.local_shipping_outlined,
                                color: AppColors.teal,
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              'Welcome to CargoPro',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryDark,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Securely access freight insights with one-tap OTP login.',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: Colors.black54),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: phoneController,
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                hintText: '+234 801 234 5678',
                                prefixIcon: Icon(Icons.phone_rounded),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: phoneValidator,
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
                                    : const Icon(Icons.lock_open_rounded),
                                label: Text(
                                  controller.isLoading.value
                                      ? 'Sending code...'
                                      : 'Send OTP',
                                ),
                                onPressed: controller.isLoading.value
                                    ? null
                                    : () {
                                        if (formKey.currentState?.validate() ??
                                            false) {
                                          controller.sendOtp(
                                            phoneController.text.trim(),
                                          );
                                        }
                                      },
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: <Widget>[
                                const Icon(
                                  Icons.shield_moon_outlined,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'We use Firebase phone verification with bank-grade encryption.',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                            if (controller.errorMessage.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Text(
                                  controller.errorMessage.value,
                                  style: const TextStyle(color: Colors.red),
                                ),
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
