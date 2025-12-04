import 'dart:io';

import 'package:cargopro_assignment/controllers/object_controller.dart';
import 'package:cargopro_assignment/models/cargo_object.dart';
import 'package:cargopro_assignment/services/api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

class _FakeApiService extends ApiService {
  _FakeApiService({this.deleteShouldFail = false})
      : super(
          client: MockClient(
            (_) async => http.Response('{}', 200),
          ),
        );

  final bool deleteShouldFail;

  @override
  Future<CargoObject> createObject(CargoObject object) async {
    return CargoObject(
      id: 'generated-id',
      name: object.name,
      data: object.data,
    );
  }

  @override
  Future<void> deleteObject(String id) async {
    if (deleteShouldFail) {
      throw const HttpException('delete failed');
    }
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    Get.testMode = true;
  });

  test('createObject inserts the new record and marks controller dirty',
      () async {
    final controller = ObjectController(_FakeApiService());

    await controller.createObject(
      CargoObject(name: 'Widget', data: <String, dynamic>{'color': 'blue'}),
    );

    expect(controller.objects, hasLength(1));
    expect(controller.objects.first.name, 'Widget');
    expect(controller.isDirty.value, isTrue);
  });

  test('deleteObject rolls back when API call fails', () async {
    final controller = ObjectController(
      _FakeApiService(deleteShouldFail: true),
    );
    final item = CargoObject(id: '1', name: 'To delete', data: const {});
    controller.objects.add(item);

    final result = await controller.deleteObject(item);

    expect(result, isFalse);
    expect(controller.objects, contains(item));
  });
}
