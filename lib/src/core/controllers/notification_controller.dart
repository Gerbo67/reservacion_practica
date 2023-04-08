import 'package:bot_toast/bot_toast.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../../ui/utils/configure.dart';

class Notifications {
  Notifications._();

  static final instance = Notifications._();

  //Notificacion para advertencias
  void notificationWarning(String text) {
    BotToast.showNotification(
      duration: const Duration(seconds: 10),
      backgroundColor: Configure.YELLOW,
      leading: (cancel) => SizedBox.fromSize(
          size: const Size(40, 40),
          child: IconButton(
            icon: const Icon(EvaIcons.alertCircleOutline, color: Colors.red),
            onPressed: cancel,
          )),
      title: (_) => Text(
        text,
        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
      trailing: (cancel) => IconButton(
        icon: const Icon(Icons.cancel, color: Color(0xFFFF6363)),
        onPressed: cancel,
      ),
    );
  }

  //Notificacion No internet
  void notificationNoInternet() {
    BotToast.showNotification(
      duration: const Duration(seconds: 10),
      backgroundColor: Configure.SECONDARY_BLACK.withOpacity(0.9),
      leading: (cancel) => SizedBox.fromSize(
          size: const Size(40, 40),
          child: IconButton(
            icon: const Icon(EvaIcons.wifiOff, color: Colors.white),
            onPressed: cancel,
          )),
      title: (_) => const Text(
        'Sin acceso a internet',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: (_) => const Text('No podrá ver la probabilidad de lluvia',
          style: TextStyle(color: Colors.white)),
      trailing: (cancel) => IconButton(
        icon: const Icon(Icons.cancel, color: Colors.white),
        onPressed: cancel,
      ),
    );
  }

  //Notificacion para errores
  void notificationError() {
    BotToast.showNotification(
      duration: const Duration(seconds: 10),
      backgroundColor: Configure.PINK.withOpacity(0.9),
      leading: (cancel) => SizedBox.fromSize(
          size: const Size(40, 40),
          child: IconButton(
            icon: const Icon(EvaIcons.closeCircle, color: Colors.red),
            onPressed: cancel,
          )),
      title: (_) => const Text(
        "Error inesperado",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: (_) => const Text(
          "Intenta de nuevo la acción, si perdura contacte a soporte",
          style: TextStyle(color: Colors.white)),
      trailing: (cancel) => IconButton(
        icon: const Icon(Icons.cancel, color: Colors.white),
        onPressed: cancel,
      ),
    );
  }
}
