import 'package:flutter/material.dart';
import 'package:qrscaner/bloc/scans_bloc.dart';
import 'package:qrscaner/providers/db_provider.dart';
import 'package:qrscaner/utils/scans_util.dart' as utils;


class MapaPage extends StatelessWidget {

  final scansBloc = ScansBloc();

  @override
  Widget build(BuildContext context) {
    scansBloc.obtenerScans();

    return Container(
      child: StreamBuilder(
        stream: scansBloc.scansStream,
        builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
          if( !snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          }

          final scans = snapshot.data;

          if(scans.length == 0){
            return Center(
              child: Text("NO hay scans"),
            );
          }

          return ListView.builder(
            itemCount: scans.length,
            itemBuilder: (BuildContext context, int index){
              return Dismissible(
                child: ListTile(
                  trailing: Icon(Icons.arrow_right,color: Theme.of(context).primaryColor,),
                  title: Text(scans[index].valor),
                  leading: Icon(Icons.location_on,color: Theme.of(context).primaryColor,),
                  onTap: (){
                    utils.abrirScanModel(context,scans[index]);
                  },
                ),
                background: Container(
                  color: Theme.of(context).primaryColor
                ),
                key: ValueKey(scans[index].id),
                onDismissed: (direction){
                  scansBloc.borrarScan(scans[index].id);
                },
              );
            },
          );
        },
      ),
    );
  }
}