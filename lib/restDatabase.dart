import 'package:talabat_project_app/ListOfRestaurants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class RestDatabase {
  RestDatabase._();
  static final RestDatabase rdb =RestDatabase._();
  static final int version = 5;
  static Database _database;

  Future<Database> get database async{
    if (_database != null)
      return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    String path = join(await getDatabasesPath(), 'uniDB.db');
    return await openDatabase(
        path,
        version: version,
        onCreate: (Database rdb, int version) async {
          await rdb.execute(
              '''CREATE TABLE restaurant (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT,
              city TEXT,
              lat TEXT,
              lng TEXT,
              phone TEXT,
              image TEXT,
              rate INTEGER)'''
          );
        }
    );
  }

  Future<List<Restaurants>> getAllRestaurant() async {
    final rdb = await database;
    List<Map> results = await rdb.query(
        'restaurant', columns: Restaurants.columns, orderBy: "id ASC"
    );
    List<Restaurants> rest = List();
    results.forEach((result) {
      Restaurants restaurants = Restaurants.fromMap(result);
      rest.add(restaurants);
    });
    return rest;
  }

  insert(Restaurants rest) async {
    final rdb = await database;
    return await rdb.insert('restaurant', rest.toMap());
  }

}




