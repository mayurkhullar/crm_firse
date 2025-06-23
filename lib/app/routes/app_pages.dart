import 'package:get/get.dart';

import '../modules/login/login_view.dart';

class AppPages {
  static const initial = '/login';

  static final routes = [
    GetPage(name: '/login', page: () => const LoginView()),
    // Any future pages that don't require constructor arguments can go here
  ];
}
