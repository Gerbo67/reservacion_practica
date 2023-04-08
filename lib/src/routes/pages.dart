import 'package:flutter/material.dart';
import 'package:reservacion/src/routes/routes.dart';
import 'package:reservacion/src/ui/pages/home/home_page.dart';

import '../ui/pages/register/register_page.dart';

abstract class Pages {
  static const String INITIAL = Routes.HOME;
  static final Map<String, Widget Function(BuildContext)> routes = {
    Routes.HOME: (_) => const HomePage(),
    Routes.REGISTER: (_) => const RegisterPage(),
  };
}
