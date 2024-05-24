// import 'package:realm/realm.dart';
// import 'package:colab_care/models/realm_model.dart';

// Future<Realm> openRealm() async {
//   return await Realm.open();
// }

// Future<void> closeRealm(Realm realm) async {
//   realm.close();
// }

// Future<void> addReminder(Reminder newReminder) async {
//   final realm = await openRealm();
//   realm.write<Reminder>(() {
//     realm.add<Reminder>(newReminder, update: true);
//   });
//   await closeRealm(realm);
// }

// Future<void> updateReminder(Reminder updatedReminder) async {
//   final realm = await openRealm();
//   realm.write<Reminder>(() {
//     realm.add<Reminder>(updatedReminder, update: true);
//   });
//   await closeRealm(realm);
// }

// Future<void> deleteReminder(Reminder reminder) async {
//   final realm = await openRealm();
//   realm.write<Reminder>(() {
//     realm.delete<Reminder>(reminder);
//   });
//   await closeRealm(realm);
// }

// Future<List<Reminder>> getAllReminders() async {
//   final realm = await openRealm();
//   final reminders = realm.objects<Reminder>().toList();
//   await closeRealm(realm);
//   return reminders;
// }
