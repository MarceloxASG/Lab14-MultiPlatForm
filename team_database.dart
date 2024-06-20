// team_database.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_application_3/team.dart';

class TeamDatabase {
  static final TeamDatabase instance = TeamDatabase._internal();
  static Database? _database;

  TeamDatabase._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'teams.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
        CREATE TABLE ${TeamFields.tableName} (
          ${TeamFields.id} ${TeamFields.idType},
          ${TeamFields.name} ${TeamFields.textType},
          ${TeamFields.year} ${TeamFields.intType},
          ${TeamFields.lastChampionshipDate} ${TeamFields.textType}
        )
      ''');
  }

  Future<TeamModel> create(TeamModel team) async {
    final db = await instance.database;
    final id = await db.insert(TeamFields.tableName, team.toJson());
    return team.copy(id: id);
  }

  Future<TeamModel> read(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      TeamFields.tableName,
      columns: TeamFields.values,
      where: '${TeamFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TeamModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<TeamModel>> readAll() async {
    final db = await instance.database;
    final result = await db.query(TeamFields.tableName);
    return result.map((json) => TeamModel.fromJson(json)).toList();
  }

  Future<int> update(TeamModel team) async {
    final db = await instance.database;
    return db.update(
      TeamFields.tableName,
      team.toJson(),
      where: '${TeamFields.id} = ?',
      whereArgs: [team.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      TeamFields.tableName,
      where: '${TeamFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
