import 'package:get/get.dart';

import '../models/cargo_object.dart';
import '../services/api_service.dart';

class ObjectController extends GetxController {
  ObjectController(this._apiService);

  final ApiService _apiService;

  final RxList<CargoObject> objects = <CargoObject>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isMoreLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt _currentPage = 1.obs;
  final int _pageSize = 20;
  final RxBool hasMore = true.obs;
  final RxBool isDirty = false.obs;

  void _notify(String title, String message) {
    if (Get.context != null) {
      Get.snackbar(title, message);
    }
  }

  Future<void> loadInitial() async {
    _currentPage.value = 1;
    hasMore.value = true;
    objects.clear();
    await _fetchPage(isInitial: true);
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isMoreLoading.value) {
      return;
    }
    _currentPage.value = _currentPage.value + 1;
    await _fetchPage(isInitial: false);
  }

  Future<void> _fetchPage({required bool isInitial}) async {
    if (isInitial) {
      isLoading.value = true;
    } else {
      isMoreLoading.value = true;
    }
    errorMessage.value = '';

    try {
      final pageItems = await _apiService.fetchObjects(
        page: _currentPage.value,
        pageSize: _pageSize,
      );

      if (pageItems.isEmpty) {
        hasMore.value = false;
      } else {
        objects.addAll(pageItems);
      }
    } catch (e) {
      errorMessage.value = 'Failed to load objects';
      _notify('Error', e.toString());
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
      isDirty.value = false;
    }
  }

  Future<void> refreshList() async {
    await loadInitial();
  }

  Future<void> createObject(CargoObject object) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final created = await _apiService.createObject(object);
      objects.insert(0, created);
      isDirty.value = true;
      _notify('Success', 'Object created');
    } catch (e) {
      errorMessage.value = 'Failed to create object';
      _notify('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateObject(CargoObject updated) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final saved = await _apiService.updateObject(updated);
      final index = objects.indexWhere((o) => o.id == saved.id);
      if (index != -1) {
        objects[index] = saved;
      }
      isDirty.value = true;
      _notify('Success', 'Object updated');
    } catch (e) {
      errorMessage.value = 'Failed to update object';
      _notify('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteObject(CargoObject object) async {
    if (object.id == null) {
      _notify('Error', 'Object id is required for delete');
      return false;
    }

    final backup = List<CargoObject>.from(objects);
    objects.removeWhere((o) => o.id == object.id);

    try {
      await _apiService.deleteObject(object.id!);
      isDirty.value = true;
      _notify('Success', 'Object deleted');
      return true;
    } catch (e) {
      objects.assignAll(backup);
      errorMessage.value = 'Failed to delete object';
      _notify('Error', e.toString());
      return false;
    }
  }
}
