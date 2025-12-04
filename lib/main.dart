import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/app_bindings.dart';
import 'app/app_routes.dart';
import 'app/app_theme.dart';
import 'firebase_options.dart';
import 'views/auth/login_screen.dart';
import 'views/auth/otp_screen.dart';
import 'views/objects/object_detail_screen.dart';
import 'views/objects/object_form_screen.dart';
import 'views/objects/object_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CargoPro Assignment',
      debugShowCheckedModeBanner: false,
      initialBinding: AppBindings(),
      initialRoute: AppRoutes.login,
      getPages: <GetPage<dynamic>>[
        GetPage(
          name: AppRoutes.login,
          page: () => const LoginScreen(),
        ),
        GetPage(
          name: AppRoutes.otp,
          page: () => const OtpScreen(),
        ),
        GetPage(
          name: AppRoutes.objects,
          page: () => ObjectListScreen(),
        ),
        GetPage(
          name: AppRoutes.objectDetail,
          page: () => ObjectDetailScreen(),
        ),
        GetPage(
          name: AppRoutes.objectForm,
          page: () => ObjectFormScreen(),
        ),
      ],
      theme: AppTheme.light,
    );
  }
}
