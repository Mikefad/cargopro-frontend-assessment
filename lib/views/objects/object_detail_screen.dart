import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/app_routes.dart';
import '../../app/app_theme.dart';
import '../../controllers/object_controller.dart';
import '../../models/cargo_object.dart';

class ObjectDetailScreen extends StatelessWidget {
  const ObjectDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CargoObject item = Get.arguments as CargoObject;
    final controller = Get.find<ObjectController>();

    final prettyJson =
        const JsonEncoder.withIndent('  ').convert(item.data.isEmpty ? {} : item.data);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.background),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              IconButton(
                                onPressed: () => Get.back(),
                                icon: const Icon(Icons.arrow_back_ios_new),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  Get.toNamed(
                                    AppRoutes.objectForm,
                                    arguments: item,
                                  );
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () async {
                                  final confirmed = await Get.defaultDialog<bool>(
                                    title: 'Delete',
                                    middleText:
                                        'Are you sure you want to delete this object?',
                                    textCancel: 'Cancel',
                                    textConfirm: 'Delete',
                                    confirmTextColor: Colors.white,
                                    onConfirm: () => Get.back(result: true),
                                    onCancel: () => Get.back(result: false),
                                  );

                                  if (confirmed == true) {
                                    final success =
                                        await controller.deleteObject(item);
                                    if (success) {
                                      Navigator.of(context)
                                          .pop<bool>(true);
                                    }
                                  }
                                },
                                icon: const Icon(Icons.delete_outline),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            item.name,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'ID: ${item.id ?? '-'}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.black54),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                colors: <Color>[
                                  Color(0xFFE0ECFF),
                                  Color(0xFFD7FDF4),
                                ],
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Payload',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  prettyJson,
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 15,
                                  ),
                                ),
                              ],
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
    );
  }
}
