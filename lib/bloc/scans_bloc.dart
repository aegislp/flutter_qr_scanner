import 'dart:async';

import 'package:qrscaner/bloc/validators.dart';
import 'package:qrscaner/providers/db_provider.dart';

class ScansBloc with Validators {

  static final ScansBloc _singleton = new ScansBloc.internal();

  factory ScansBloc(){
    return _singleton;
  }

  ScansBloc.internal(){
    obtenerScans();
  }

  final _streamController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream => _streamController.stream.transform(validarGeo);

  Stream<List<ScanModel>> get scansStreamHttp => _streamController.stream.transform(validarHttp);


  dispose(){
    _streamController?.close();
  } 

  obtenerScans() async {
    _streamController.sink.add(await DBProvider.db.getAllScans());
  }
  borrarScan(int id) async{
    await DBProvider.db.deleteScan(id);
    obtenerScans();
  }

  borraTodosScans() async{
    await DBProvider.db.deleteAllScan();

    _streamController.sink.add([]);
  }

  agregarScans(ScanModel scan) async {
   await DBProvider.db.nuevoScan(scan);
   obtenerScans();
  }



}