class Agenda {
  int? id;
  String name;
  int date;
  String nameC;
  double rain;

  Agenda(
      {this.id,
      required this.name,
      required this.date,
      required this.nameC,
      required this.rain});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'date': date, 'nameC': nameC, 'rain': rain};
  }
}
