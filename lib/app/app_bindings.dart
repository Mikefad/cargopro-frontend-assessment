import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/object_controller.dart';
import '../services/api_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(
      () => ApiService(),
      fenix: true,
    );

    Get.lazyPut<AuthController>(
      () => AuthController(),
      fenix: true,
    );

    Get.lazyPut<ObjectController>(
      () => ObjectController(Get.find<ApiService>()),
      fenix: true,
    );
  }
}
