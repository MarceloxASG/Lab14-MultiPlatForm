// team.dart

class TeamFields {
  static const List<String> values = [id, name, year, lastChampionshipDate];
  static const String tableName = 'teams';
  static const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String textType = 'TEXT NOT NULL';
  static const String intType = 'INTEGER NOT NULL';
  static const String id = '_id';
  static const String name = 'name';
  static const String year = 'year';
  static const String lastChampionshipDate = 'last_championship_date';
}

class TeamModel {
  int? id;
  final String name;
  final int year;
  final DateTime lastChampionshipDate;

  TeamModel({
    this.id,
    required this.name,
    required this.year,
    required this.lastChampionshipDate,
  });

  Map<String, Object?> toJson() => {
        TeamFields.id: id,
        TeamFields.name: name,
        TeamFields.year: year,
        TeamFields.lastChampionshipDate: lastChampionshipDate.toIso8601String(),
      };

  factory TeamModel.fromJson(Map<String, Object?> json) => TeamModel(
        id: json[TeamFields.id] as int?,
        name: json[TeamFields.name] as String,
        year: json[TeamFields.year] as int,
        lastChampionshipDate: DateTime.parse(json[TeamFields.lastChampionshipDate] as String),
      );

  TeamModel copy({
    int? id,
    String? name,
    int? year,
    DateTime? lastChampionshipDate,
  }) =>
      TeamModel(
        id: id ?? this.id,
        name: name ?? this.name,
        year: year ?? this.year,
        lastChampionshipDate: lastChampionshipDate ?? this.lastChampionshipDate,
      );
}
