import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:qrscaner/models/scan_model.dart';
export 'package:qrscaner/models/scan_model.dart';


class DBProvider{
  
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async{
    if(_database != null) return _database;

    _database = await initDb();
  
    return _database;
  }

  initDb() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentDirectory.path,'ScansDB.db');

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db){},
      onCreate: (Database db, int version) async{
         await db.execute(
          'CREATE TABLE Scans('
          'id INTEGER PRIMARY KEY,'
          'tipo TEXT,'
          'valor TEXT'
          ')'
        );
      }
    );

  }

  //Crear Registro
  nuevoScan(ScanModel nuevoScan) async{
    final db = await database;

    final res =  await db.insert('Scans', nuevoScan.toJson());
  }

  Future<ScanModel> getScanById(int id) async{

    final db = await database;

    final res = await db.query('Scans',where: "id = ?",whereArgs: [id]);

    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null; 
  }

  Future<List<ScanModel>> getAllScans() async{

    final db = await database;

    final res = await db.query('Scans');

    List<ScanModel> list = res.isNotEmpty 
                          ? res.map((scan){
                              return new ScanModel.fromJson(scan);
                            }).toList()
                          : [];
    return list;

  }

  Future<List<ScanModel>> getScanPorTipo(String tipo) async{
    final db = await database;

    final res = await db.rawQuery("SELECT * FROM Scans WHERE tipo = '$tipo'");

    List<ScanModel> list = res.isNotEmpty 
                          ? res.map((scan){
                              return new ScanModel.fromJson(scan);
                            }).toList()
                          : [];
    return list;
    
  }


  Future<int> updateScan(ScanModel nuevoScan) async{

    final db = await database;
    final res = await db.update('Scans', nuevoScan.toJson(),where: 'id = ?',whereArgs: [nuevoScan.id]);

    return res;

  }

  Future<int> deleteScan(int id) async{

    final db = await database;
    final res = db.delete('Scans',where: "id = ?",whereArgs: [id]);

    return res;

  }

  Future<int> deleteAllScan() async{

    final db = await database;
    final res = db.rawDelete('DELETE from Scans');

    return res;

  }

}