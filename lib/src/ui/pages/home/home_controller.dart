import 'package:flutter/material.dart';
import 'package:reservacion/src/core/models/agenda_model.dart';
import 'package:reservacion/src/routes/routes.dart';
import 'package:reservacion/src/ui/utils/configure.dart';

import '../../../core/controllers/notification_controller.dart';
import '../../../core/helpers/database.dart';

class HomeController extends ChangeNotifier {
  late List<Agenda> _agendaItems = [];

  HomeController() {
    loadItems();
  }

  //------------------------------Setter/Getters-----------------------------
  List<Agenda> get agendaItems => _agendaItems;

  //--------------------------Metodos---------------------------------

  /*
  * Este metodo consulta todos los datos de la BD
  * sobre las reservaciones
  * */
  Future<void> loadItems() async {
    try {
      //Evitar añadiduras
      _agendaItems = [];
      notifyListeners();

      // Consulta a la base de datos
      final items = await DB.query();

      // Actualizar la lista de items y notificar a los listeners
      _agendaItems = items;
      notifyListeners();
    } catch (error) {
      // Manejar el error de la consulta a la base de datos
      Notifications.instance.notificationError();
    }
  }

  /*
  * Este metodo convierte la fecha en tipo milisegundos a
  * fecha con formato dd/MM/YY en string
  * */
  String date(int dateInt) {
    DateTime dateTemp = DateTime.fromMillisecondsSinceEpoch(dateInt);
    return '${Configure.addLeadingZero(dateTemp.day)}/${Configure.addLeadingZero(dateTemp.month)}/${dateTemp.year}';
  }

  /*
  * Este metodo convierte la fecha en tipo milisegundos a
  * fecha con formato HH:MM en string
  * */
  String hour(int dateInt) {
    DateTime dateTemp = DateTime.fromMillisecondsSinceEpoch(dateInt);

    return '${Configure.addLeadingZero(dateTemp.hour)}:${Configure.addLeadingZero(dateTemp.minute)}';
  }

  /*
  * Este metodo elimina un registro por su id
  * */
  Future<void> deleteRegister(Agenda agendas) async {
    DB.delete(agendas);
    await loadItems();
  }

  /*
  * Este metodo pasa a la siguiente pantalla
  * */
  void nextRegister(BuildContext context) {
    Navigator.pushNamed(context, Routes.REGISTER);
  }
}
