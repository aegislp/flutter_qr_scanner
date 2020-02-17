




import 'package:flutter/material.dart';
import 'package:qrscaner/models/scan_model.dart';
import 'package:url_launcher/url_launcher.dart';

abrirScanModel(BuildContext context, ScanModel scan) async {

  if(scan.tipo == 'http'){

    if (await canLaunch(scan.valor)) {
      await launch(scan.valor);
    } else {
      throw 'Could not launch ${scan.valor}';
    }
  }else{
    Navigator.pushNamed(context, 'map',arguments: scan);
    
  }
}

Map<String,double> getGeoCodeFromGeoScan(ScanModel scan){

  //geo:40.66175814219636,-73.96199598750003
  String geoStr =  scan.valor.replaceAll('geo:', '');
  List<String> splGeoSrt = geoStr.split(','); 
  return {
    'lat': double.parse( splGeoSrt[0]),
    'lng': double.parse( splGeoSrt[1]) 
  };


}