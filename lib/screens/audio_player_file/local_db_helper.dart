// import 'dart:convert';
// // import 'dart:io';
// // import 'package:flutter/material.dart';

// // import 'package:mart_up/models/product.dart';
// // import 'package:mart_up/services/user_login_service.dart';
// import 'package:active_ecommerce_flutter/data_model/mp3_response.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// // import 'package:path_provider/path_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SongHelper {
//   static Database _db;
//   static const String ID = 'id';
//   static const String PROID = 'pid';
//   //static const String NAME = 'fname';
//   static const String PNAME = 'name';
//   static const String CITY = 'city';
//   static const String FNAME = 'fname';
//   static const String LNAME = 'lname';
//   static const String ROADNO = 'roadNo';
//   static const String HOUSENO = 'houseNo';
//   static const String MOBILENO = 'mobileNo';
//   static const String IMAGE = 'image';
//   static const String PRICE = 'price';
//   static const String REGULARPRICE = 'regularprice';
//   static const String SHOTDES = 'shotdescription';
//   static const String QUANTITY = 'quantity';
//   static const String CATEGORIES = 'categories';
//   static const String ATTRIBUTES = 'attribute';
//   static const String FAVORITELIST_TABLE = 'Favoritelist';

//   static const String RECENTLIST_TABLE = 'Recentlist';
//   static const String ADDRESS_TABLE = 'Addresslist';
//   static const String DB_NAME = 'ayat.db';

//   Future<Database> get db async {
//     if (_db = null) {
//       return _db;
//     }
//     _db = await initDb();
//     return _db;
//   }

//   static initDb() async {
//     String path = join(await getDatabasesPath(), DB_NAME);
//     var db = await openDatabase(path, version: 1, onCreate: _onCreate);
//     return db;
//   }

//   static _onCreate(Database db, int version) async {
//     await db.execute(
//         'CREATE TABLE $RECENTLIST_TABLE (id INTEGER PRIMARY KEY,name TEXT,coverArt TEXT,file TEXT,artistId INTEGER,genreId INTEGER,listens INTEGER,isFeatured INTEGER,description TEXT)');
//   }

//   Future<Datum> saveToRecentList(Datum song) async {
//     var dbClient = await db;
//     song.id = await dbClient.insert(RECENTLIST_TABLE, song.toJson());
//     print(song);
//     return song;
//   }
//   // Future<int> insertTransaction(
//   //     FavoriteModel transactionModel, context) async {
//   //       print(transactionModel);
//   //   Database db = await this.db;
//   //   final int result = await db.insert(FAVORITELIST_TABLE, transactionModel.toJson());
//   //    print('Data added: $result');

//   //   return result;
//   // }

//   Future<List<Datum>> getRecentListSong() async {
//     var dbClient = await db;
//     List<Map> maps = await dbClient.query(RECENTLIST_TABLE, columns: [
//       'id',
//       'name',
//       'coverArt',
//       'file',
//       'artistId',
//       'genreId',
//       'listens',
//       'isFeatured',
//       'description'
//     ]);
//     //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
//     List<Datum> products = [];
//     if (maps.length > 0) {
//       for (int i = 0; i < maps.length; i++) {
//         products.add(Datum.fromJson(Map.from(maps[i])));
//       }
//     }
//     // ignore: unused_local_variable
//     var v = jsonEncode(products);
//     //print(v);
//     return products;
//   }

//   Future<int> deleteRecentProduct(int id) async {
//     var dbClient = await db;
//     return await dbClient
//         .delete(RECENTLIST_TABLE, where: '$ID = ?', whereArgs: [id]);
//   }
// }
