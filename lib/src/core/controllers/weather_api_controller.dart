import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../ui/utils/configure.dart';
import '../services/internet_services.dart';
import 'notification_controller.dart';

class WeatherApiController {
  WeatherApiController._();

  static final instance = WeatherApiController._();

  Future<double> getProbabilityPrecipitation(
      String idCancha, DateTime date) async {

    //Map para identificar lugar de consulta metereologica
    Map<String, String> position = {
      'A': 'lat=25.68&lon=100.32&asl=543', //Monterrey
      'B': 'lat=21.02&lon=101.26&asl=2010', //Guadalajara
      'C': 'lat=20.59&lon=100.39&asl=1826', //Queretaro
    };

    try {
      //Verifica conexion a internet
      if (await InternetServices.instance.connected()) {
        // Convertir la URL a un objeto Uri
        final url = Uri.parse(
            'https://my.meteoblue.com/packages/basic-1h?apikey=wN9xc4W86LCA1vtq&${position[idCancha]}&format=json');

        // Hacer la llamada HTTP con el método GET
        final response = await http.get(url);

        // Verificar si la respuesta es exitosa (código de estado 200)
        if (response.statusCode == 200) {
          // Convertir la respuesta JSON en un mapa
          final Map<String, dynamic> dataJson = jsonDecode(response.body);

          // Guardar datos con fin de uso tipo tuplas
          List<dynamic> time = dataJson['data_1h']['time'];
          List<dynamic> probability =
              dataJson['data_1h']['precipitation_probability'];

          //Buscar la posicion, hacinedo uso de tuplas
          int indexPosition = time.indexWhere((e) =>
              e.toString() ==
              '${date.year}-${Configure.addLeadingZero(date.month)}-${Configure.addLeadingZero(date.day)} ${Configure.addLeadingZero(date.hour)}:${Configure.addLeadingZero(date.minute)}');

          // Retornar la probabilidad
          return indexPosition == -1 ? -1.0 : probability[indexPosition] + 0.0;
        } else {
          // Manejar errores si es necesario
          Notifications.instance.notificationError();
        }
      } else {
        // Manejar error de conexion de red especificamente
        Notifications.instance.notificationNoInternet();
      }
    } catch (e) {
      // Manejar errores de conexión u otros errores
      Notifications.instance.notificationError();
    }

    //Regresar un numero de uso bandera
    return -1.0;
  }
}
