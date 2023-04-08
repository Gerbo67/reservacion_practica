import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reservacion/src/core/controllers/weather_api_controller.dart';
import 'package:reservacion/src/core/helpers/database.dart';
import 'package:reservacion/src/core/models/agenda_model.dart';

import '../../../core/controllers/notification_controller.dart';
import '../../../core/models/clock_model.dart';
import '../../widgets/custom_loading/custom_loading_controller.dart';
import '../home/home_controller.dart';

class RegisterController extends ChangeNotifier {
  late Map<String, int> hoursMap;
  late ClockModel _clocksModel;
  late String _clockSelect;
  late String _idCancha;
  late String _probabilityText;
  late bool _flagLoadHours;
  late DateTime _dateAgenda;
  late int _length;
  late String _name;

  RegisterController() {
    _name = "";
    _length = 0;
    _idCancha = "";
    _clockSelect = '12:00';
    _flagLoadHours = true;
    _probabilityText = "0.0";
    hoursMap = {"12:00": 12, "15:00": 15, "18:00": 18};
    _clocksModel = ClockModel(options: ['12:00', '15:00', '18:00']);
    _dateAgenda =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    notifyListeners();
  }

  //------------------------------Setter/Getters-----------------------------
  ClockModel get clocksModel => _clocksModel;

  String get probabilityText => _probabilityText;

  String get idCancha => _idCancha;

  String get clockSelect => _clockSelect;

  String get name => _name;

  DateTime get dateAgenda => _dateAgenda;

  bool get flagLoadHours => _flagLoadHours;

  int get length => _length;

  set canchaSelect(String value) {
    _idCancha = value;
    notifyListeners();
  }

  set dateSelect(DateTime value) {
    _dateAgenda = value;
    notifyListeners();
  }

  set clockSelect(String value) {
    _clockSelect = value;
    notifyListeners();
  }

  set lengthUpdate(int value) {
    _length = value;
    notifyListeners();
  }

  set nameUpdate(String value) {
    _name = value;
    notifyListeners();
  }

//--------------------------Metodos---------------------------------

  /*
  * Este metodo consulta la existencia de aportados por cancha y horario
  * y con esto poder llenar el dropdown de las horas
  * */
  Future<void> queryExist() async {
    _flagLoadHours = true;
    notifyListeners();

    if (_idCancha != "") {
      List<int> dates = [
        _dateAgenda.add(const Duration(hours: 12)).millisecondsSinceEpoch,
        _dateAgenda.add(const Duration(hours: 15)).millisecondsSinceEpoch,
        _dateAgenda.add(const Duration(hours: 18)).millisecondsSinceEpoch
      ];

      List<Agenda> agendaExist = await DB.queryExist(dates, _idCancha);

      List<String> optionsTemp = ['12:00', '15:00', '18:00'];

      for (var e in agendaExist) {
        switch (DateTime.fromMillisecondsSinceEpoch(e.date).hour) {
          case 12:
            optionsTemp.remove('12:00');
            break;
          case 15:
            optionsTemp.remove('15:00');
            break;
          case 18:
            optionsTemp.remove('18:00');
            break;
        }
      }

      _clocksModel = ClockModel(options: optionsTemp);
      _clockSelect =
          _clocksModel.options.isEmpty ? '' : _clocksModel.options.first;

      //No dejar que los botones se puedan usar
      if (_clockSelect == '') {
        _flagLoadHours = true;
      } else {
        _flagLoadHours = false;
      }
      notifyListeners();
    }
  }

  /*
  * Este metodo consulta la probalidad de lluvia
  * tomando de referencia la hora y lugar
  * */
  Future<void> weather() async {
    late double probability;
    try {
      //Probabilidad con -2 para bandera de carga
      _probabilityText = "-2.0";
      notifyListeners();

      //Controlar error al consultar con hora vacia
      if (_clockSelect != '' && _idCancha != '') {
        //Agregar horas elegidas a la fecha para juntarlo en DateTime
        DateTime dateAgendaHours =
            _dateAgenda.add(Duration(hours: hoursMap[_clockSelect]!));

        //Obtener probalidad de lluvia
        probability = await WeatherApiController.instance
            .getProbabilityPrecipitation(_idCancha, dateAgendaHours);
      } else {
        probability = -1.0;
      }

      //Guardar probabilidad
      _probabilityText = probability == -1.0 ? 'N/A' : probability.toString();
      notifyListeners();
    } catch (e) {
      // Manejar errores de conexión u otros errores
      Notifications.instance.notificationError();
    }
  }

  /*
  * Este metodo guarda los datos en la BD, teniendo en si
  * una pequeña verificaion
  * */
  Future<bool> addAgenda(BuildContext context) async {
    try {
      //Verificar longitud del nombre
      if (name.length >= 20) {
        LoadingWidgetController.instance.loading();
        DateTime dateAgendaHours =
            _dateAgenda.add(Duration(hours: hoursMap[_clockSelect]!));

        await DB.insert(Agenda(
            name: _name,
            date: dateAgendaHours.millisecondsSinceEpoch,
            nameC: _idCancha,
            rain: _probabilityText == 'N/A'
                ? -1.0
                : double.parse(_probabilityText)));
        LoadingWidgetController.instance.close();

        Provider.of<HomeController>(context, listen: false).loadItems();
        Navigator.pop(context);

        return true;
      } else {
        Notifications.instance
            .notificationWarning("El nombre debe tener minimo 20 caracteres");
        return false;
      }
    } catch (e) {
      // Manejar errores de conexión u otros errores
      Notifications.instance.notificationError();
      LoadingWidgetController.instance.close();
      return false;
    }
  }
}
