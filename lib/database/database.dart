import 'dart:async';
import 'dart:io';

import 'package:nicknamer/database/settings_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Nicknamer.db");
    return await openDatabase(path, version: 1, onOpen: (db) async {
      await createSettingsTableIfNotExists(db);
    }, onCreate: (Database db, int version) async {
      await createSettingsTableIfNotExists(db);
    });
  }

  Future<void> createSettingsTableIfNotExists(Database db) async {
    await db.execute("CREATE TABLE IF NOT EXISTS Settings ("
        "setting TEXT,"
        "value TEXT,"
        "UNIQUE(setting)"
        ")");
    //the list of settings and their default values
    Map<String, String> settings = {'Theme': 'Auto'};
    settings.forEach((key, value) async {
      await db.execute(
          'INSERT OR IGNORE INTO Settings(setting, value) VALUES(?, ?)',
          [key, value]);
    });
  }

  Future<String> getSetting(String setting) async {
    final db = await database;
    final res =
        await db.query("Settings", where: 'setting = ?', whereArgs: [setting]);
    return (res.isNotEmpty ? res.first['value'] as String : "");
  }

  Future<Settings> getAllSettings() async {
    final db = await (database);
    final res = await db.query("Settings");
    return res.isNotEmpty ? Settings.fromJson(res) : Settings();
  }

  setSetting(String setting, String value) async {
    final db = await (database);
    final res = await db.update("Settings", {'setting': setting, 'value': value});
    return res;
  }
}
