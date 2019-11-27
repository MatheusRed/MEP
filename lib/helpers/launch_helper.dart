import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String launchTable = "launchTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String detailsColumn = "detailsColumn";
final String valorColumn = "valorColumn";
final String vencColumn = "vencColumn";
final String imgColumn = "imgColumn";

class LaunchHelper {
  static final LaunchHelper _instance = LaunchHelper.internal();

  factory LaunchHelper() => _instance;

  LaunchHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "launchnewnew.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $launchTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $detailsColumn TEXT,"
          "$valorColumn TEXT, $vencColumn TEXT, $imgColumn TEXT)");
          print("DB CREATED");
    });
  }

  Future<Launch> saveLaunch(Launch launch) async {
    Database dbLaunch = await db;
    launch.id = await dbLaunch.insert(launchTable, launch.toMap());
    return launch;
  }

  Future<Launch> getLaunch(int id) async {
    Database dbLaunch = await db;
    List<Map> maps = await dbLaunch.query(launchTable,
        columns: [
          idColumn,
          nameColumn,
          valorColumn,
          detailsColumn,
          vencColumn,
          imgColumn
        ],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Launch.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteLaunch(int id) async {
    Database dbLaunch = await db;
    await dbLaunch.delete(launchTable, where: "idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateLaunch(Launch launch) async {
    Database dbLaunch = await db;
    await dbLaunch.update(launchTable, launch.toMap(),
        where: "idColumn = ?", whereArgs: [launch.id]);
  }

  Future<List> getAllLaunch() async {
    Database dbLaunch = await db;
    List listMap = await dbLaunch.rawQuery("SELECT * FROM $launchTable");
    List<Launch> listLaunch = List();
    for (Map m in listMap) {
      listLaunch.add(Launch.fromMap(m));
    }
    return listLaunch;
  }

  Future<int> getNumber() async {
    Database dbLaunch = await db;
    return Sqflite.firstIntValue(
        await dbLaunch.rawQuery("SELECT COUNT (*) FROM $launchTable"));
        
  }

  Future close() async {
    Database dbLaunch = await db;
    dbLaunch.close();
  }
}

class Launch {
  int id;
  String name;
  String details;
  String valor;
  String venc;
  String img;

  Launch();

  Launch.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    details = map[detailsColumn];
    valor = map[valorColumn];
    venc = map[vencColumn];
    img = map[imgColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      detailsColumn: details,
      valorColumn: valor,
      vencColumn: venc,
      imgColumn: img,
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Launch(id: $id, name: $name, details: $details, valor: $valor, venc: $venc, img: $img)";
  }
}


