

import 'package:tfleet/view/driver/driver_app_page.dart';
import 'package:tfleet/view/login_page.dart';
import 'package:tfleet/view/passenger/passenger_app_page.dart';
import 'package:tfleet/view/register_page.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:tfleet/view/subcon/subcon_app_page.dart';
import 'package:tfleet/view/unknown_role_page.dart';

import 'app_routes.dart';

class AppRouter {
  // init route
  static const String initialRoute = AppRoutes.login;

  static const String driverLoggedInRoute = AppRoutes.driver_app;
  static const String passengerLoggedInRoute = AppRoutes.passenger_app;
  static const String subconLoggedInRoute = AppRoutes.subcon_app;
  static const String unknownRoleRoute = AppRoutes.unknown_role;

  // 404
  static final GetPage unknownRoute = GetPage(
    name: AppRoutes.notFound,
    page: () => LoginPage(),
  );
  // 路由页面
  static final List<GetPage<dynamic>> getPages = [
    GetPage(
      name: AppRoutes.driver_app,
      page: () => DriverAppPage(),
    ),
    GetPage(
      name: AppRoutes.passenger_app,
      page: () => PassengerAppPage(),
    ),
    GetPage(
      name: AppRoutes.subcon_app,
      page: () => SubconAppPage(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginPage(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterPage(title: 'Register', fromEdit: false,),
    ),
    GetPage(
      name: AppRoutes.passenger_app,
      page: () => UnknownRolePage(),
    ),
  ];
}