import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/app_routes.dart';
import '../../app/app_theme.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/object_controller.dart';
import '../../models/cargo_object.dart';

class ObjectListScreen extends StatefulWidget {
  const ObjectListScreen({super.key});

  @override
  State<ObjectListScreen> createState() => _ObjectListScreenState();
}

class _ObjectListScreenState extends State<ObjectListScreen> {
  final ObjectController objectController = Get.find<ObjectController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    objectController.loadInitial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Get.toNamed(AppRoutes.objectForm);
        },
        icon: const Icon(Icons.add),
        label: const Text('New Object'),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.background),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _Header(authController: authController),
                const SizedBox(height: 16),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Obx(
                        () {
                          if (objectController.isLoading.value &&
                              objectController.objects.isEmpty) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (objectController.errorMessage.isNotEmpty &&
                              objectController.objects.isEmpty) {
                            return Center(
                              child: Text(objectController.errorMessage.value),
                            );
                          }

                          if (objectController.objects.isEmpty) {
                            return const Center(
                              child: Text('No objects found'),
                            );
                          }

                          return Column(
                            children: <Widget>[
                              _StatsBar(controller: objectController),
                              const SizedBox(height: 16),
                              Expanded(
                                child: RefreshIndicator(
                                  onRefresh: objectController.refreshList,
                                  child: ListView.separated(
                                    itemCount:
                                        objectController.objects.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(height: 12),
                                    itemBuilder: (context, index) {
                                      final item =
                                          objectController.objects[index];
                                      return _ObjectCard(
                                        item: item,
                                        onTap: () async {
                                          await Get.toNamed(
                                            AppRoutes.objectDetail,
                                            arguments: item,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                              if (objectController.hasMore.value)
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: ElevatedButton(
                                    onPressed:
                                        objectController.isMoreLoading.value
                                            ? null
                                            : objectController.loadMore,
                                    child: objectController
                                            .isMoreLoading.value
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child:
                                                CircularProgressIndicator(),
                                          )
                                        : const Text('Load more'),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.authController});

  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    final phone = authController.firebaseUser.value?.phoneNumber ?? 'Guest';

    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Dashboard',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Welcome, $phone • monitor your logistics data in real time.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: authController.logout,
          icon: const Icon(Icons.logout, color: Colors.white),
        ),
      ],
    );
  }
}

class _StatsBar extends StatelessWidget {
  const _StatsBar({required this.controller});

  final ObjectController controller;

  @override
  Widget build(BuildContext context) {
    final total = controller.objects.length;
    final hasMore = controller.hasMore.value;

    return Row(
      children: <Widget>[
        Expanded(
          child: _InfoChip(
            icon: Icons.inventory_2_rounded,
            accentColor: AppColors.primary,
            label: 'Total objects',
            value: '$total entries synced',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _InfoChip(
            icon: Icons.auto_awesome_outlined,
            accentColor: hasMore ? AppColors.accent : AppColors.teal,
            label: hasMore ? 'More available' : 'All caught up',
            value: hasMore
                ? 'Tap to load additional records'
                : 'Latest data displayed',
            onTap: hasMore ? controller.loadMore : null,
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.accentColor,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final Color accentColor;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accentColor.withOpacity(0.4)),
      ),
      child: Row(
        children: <Widget>[
          Icon(icon, color: accentColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  label,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  value,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (onTap == null) {
      return content;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: content,
    );
  }
}

class _ObjectCard extends StatelessWidget {
  const _ObjectCard({required this.item, this.onTap});

  final CargoObject item;
  final Future<void> Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final summary = item.data.isEmpty
        ? '{}'
        : jsonEncode(
            Map<String, dynamic>.from(
              item.data.length > 3
                  ? item.data.entries
                      .take(3)
                      .fold<Map<String, dynamic>>(
                        <String, dynamic>{},
                        (map, e) => map..[e.key] = e.value,
                      )
                  : item.data,
            ),
          );

    return InkWell(
      onTap: onTap == null ? null : () => onTap!.call(),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.grey.shade100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.15),
                  child: const Icon(
                    Icons.widgets_rounded,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'ID: ${item.id ?? '-'}',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              summary,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
