import 'package:realm/realm.dart';

class Reminder {
  @PrimaryKey()
  int? id;
  String name;
  String dosage;
  DateTime dateTime;
  bool isDaily;
  String medicineType;

  Reminder({
    this.id,
    required this.name,
    required this.dosage,
    required this.dateTime,
    required this.isDaily,
    required this.medicineType,
  });
}
