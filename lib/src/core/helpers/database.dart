import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

import '../models/agenda_model.dart';

class DB {
  static Future<Database> open() async {
    final String databasePath = await getDatabasesPath();
    final String pathToDatabase = path.join(databasePath, 'tenis.db');
    return await openDatabase(
      pathToDatabase,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE IF NOT EXISTS agenda( id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT, date INTEGER, nameC TEXT, rain REAL)');
      },
    );
  }

  static Future<List<Agenda>> query() async {
    Database database = await open();

    final List<Map<String, dynamic>> agendaMap =
        await database.query('agenda', orderBy: 'date ASC');

    return List.generate(
        agendaMap.length,
        (i) => Agenda(
            id: agendaMap[i]['id'],
            name: agendaMap[i]['name'],
            date: agendaMap[i]['date'],
            nameC: agendaMap[i]['nameC'],
            rain: agendaMap[i]['rain']));
  }

  static Future<List<Agenda>> queryExist(
      List<int> dates, String idCancha) async {
    Database database = await open();

    final List<Map<String, dynamic>> agendaMap = await database.query('agenda',
        where: '(date = ? OR date = ? OR date = ?) AND nameC = ?',
        whereArgs: [dates[0], dates[1], dates[2], idCancha]);

    return List.generate(
        agendaMap.length,
        (i) => Agenda(
            id: agendaMap[i]['id'],
            name: agendaMap[i]['name'],
            date: agendaMap[i]['date'],
            nameC: agendaMap[i]['nameC'],
            rain: agendaMap[i]['rain']));
  }

  static Future<Future<int>> insert(Agenda agenda) async {
    Database database = await open();

    return database.insert('agenda', agenda.toMap());
  }

  static Future<Future<int>> delete(Agenda agenda) async {
    Database database = await open();

    return database.delete('agenda', where: 'id = ?', whereArgs: [agenda.id]);
  }
}
