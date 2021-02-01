import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'menuList.dart';

class MenuDatabase extends ChangeNotifier {
  MenuDatabase._();
  static final MenuDatabase mdb =MenuDatabase._();
  static final int version = 1;
  static Database _database;

  Future<Database> get database async{
    if (_database != null)
      return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    String path = join(await getDatabasesPath(), 'menuDB.db');
    return await openDatabase(
        path,
        version: version,
        onCreate: (Database rdb, int version) async {
          await rdb.execute(
              '''CREATE TABLE menu (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              rest_id INTEGER ,
              name TEXT,
              descr TEXT,
              price DOUBLE,
              image TEXT,
              rating INTEGER DEFAULT 1 )'''
          );
        }
    );
  }

  Future<List<MenuList>> getAllMenus() async {
    final mdb = await database;
    List<Map> results = await mdb.query(
        'menu', columns: MenuList.columns, orderBy: "id ASC"
    );
    List<MenuList> menus = List();
    results.forEach((result) {
      MenuList m = MenuList.fromMap(result);
      menus.add(m);
    });
    return menus;
  }


  Future addMenu(MenuList menus) async {
    final mdb = await database;
    notifyListeners();
    return await mdb.insert('menu', menus.toMap());
  }

  Future removeAll() async {
    final mdb = await database;
    notifyListeners();
    return await mdb.delete('menu');
  }

  Future removeMenu(int id) async {
    final mdb = await database;
    notifyListeners();
    return await mdb.delete('menu', where: 'id=?', whereArgs: [id]);
  }

  Future<MenuList> getMenuItem(int id) async {
    final mdb = await database;
    List<Map> menu = await mdb.query('menu', where: 'id=?', whereArgs: [id]);
    return MenuList.fromMap(menu[0]);
  }

}
