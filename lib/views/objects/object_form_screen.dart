import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/app_theme.dart';
import '../../controllers/object_controller.dart';
import '../../models/cargo_object.dart';
import '../../utils/validators.dart';

class ObjectFormScreen extends StatelessWidget {
  const ObjectFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ObjectController>();
    final CargoObject? editing = Get.arguments as CargoObject?;

    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: editing?.name ?? '');
    final dataController = TextEditingController(
      text: editing != null
          ? const JsonEncoder.withIndent('  ').convert(editing.data)
          : '',
    );

    final isEditing = editing != null;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.background),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Obx(
                      () => Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              isEditing ? 'Update object' : 'Create object',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Keep Freight data organized with structured JSON payloads.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.black54),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                labelText: 'Name',
                                prefixIcon: Icon(Icons.title_rounded),
                              ),
                              validator: (value) =>
                                  requiredValidator(value, fieldName: 'Name'),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: dataController,
                              decoration: const InputDecoration(
                                labelText: 'Data (JSON)',
                                alignLabelWithHint: true,
                                hintText: '{"weight": "10kg"}',
                              ),
                              minLines: 8,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              validator: jsonValidator,
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
                                            Colors.white,
                                          ),
                                        ),
                                      )
                                    : Icon(
                                        isEditing
                                            ? Icons.save_alt_rounded
                                            : Icons.add_circle_outline,
                                      ),
                                label: Text(
                                  controller.isLoading.value
                                      ? (isEditing
                                          ? 'Saving...'
                                          : 'Creating...')
                                      : (isEditing ? 'Save changes' : 'Create'),
                                ),
                                onPressed: controller.isLoading.value
                                    ? null
                                    : () async {
                                        if (!(formKey.currentState
                                                ?.validate() ??
                                            false)) {
                                          return;
                                        }

                                        Map<String, dynamic> jsonData;
                                        try {
                                          jsonData = (jsonDecode(
                                            dataController.text,
                                          ) as Map<dynamic, dynamic>)
                                              .map(
                                            (key, value) => MapEntry(
                                              key.toString(),
                                              value,
                                            ),
                                          );
                                        } catch (_) {
                                          Get.snackbar(
                                            'Error',
                                            'Enter a valid JSON object',
                                          );
                                          return;
                                        }

                                        final base = CargoObject(
                                          id: editing?.id,
                                          name: nameController.text.trim(),
                                          data: jsonData,
                                        );

                                        if (isEditing) {
                                          await controller.updateObject(base);
                                        } else {
                                          await controller.createObject(base);
                                        }

                                        if (controller.errorMessage.isEmpty) {
                                          Navigator.of(context)
                                              .pop<bool>(true);
                                        }
                                      },
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
