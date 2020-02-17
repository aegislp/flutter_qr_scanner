import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import 'package:qrscaner/models/scan_model.dart';
import 'package:qrscaner/utils/scans_util.dart' as utils;

class MapPage extends StatefulWidget {
  
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController mapController = MapController();
  String mapLayer = 'streets';
  @override
  Widget build(BuildContext context) {

    final ScanModel scan = ModalRoute.of(context).settings.arguments;
    final  geoLoc = utils.getGeoCodeFromGeoScan(scan);

    return Scaffold(
      appBar: AppBar(
        title: Text("MapPage Scanner"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location), 
            onPressed: (){
              mapController.move(LatLng(geoLoc['lat'],geoLoc['lng']), 15.0);
            })
        ],
      ),
      body: _createMap(utils.getGeoCodeFromGeoScan(scan)),
      floatingActionButton: _createFloatingAction(context),
    );
  }

  Widget _createFloatingAction(BuildContext context){
    return FloatingActionButton(
      child: Icon(Icons.repeat,),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: (){
        if(mapLayer == 'streets'){
          mapLayer = 'dark';
        }else if(mapLayer == 'dark'){
          mapLayer = 'light';
        }else if(mapLayer == 'light'){
          mapLayer = 'outdoors';
        }else if(mapLayer == 'outdoors'){
          mapLayer = 'satellite';
        }else{
           mapLayer = 'streets';
        }

        setState(() {});
      },
      
    );
  }

  Widget _createMap(Map<String, double> geoCodeFromGeoScan) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        center: LatLng(geoCodeFromGeoScan['lat'],geoCodeFromGeoScan['lng']),
        zoom: 15.0
      ),
      layers: [
       _creteMapLayer(),
       _createMarker(geoCodeFromGeoScan) 
      ],

    );
  }

  TileLayerOptions _creteMapLayer(){
    return  new TileLayerOptions(
      urlTemplate: "https://api.tiles.mapbox.com/v4/"
          "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
      additionalOptions: {
        'accessToken': 'MAP_BOX_API_KEY',
        'id': 'mapbox.$mapLayer',
      },
    );
  }

  MarkerLayerOptions _createMarker(geoCodeFromGeoScan){
    return new MarkerLayerOptions(
      markers: [
        new Marker(
          width: 100.0,
          height: 100.0,
          point: new LatLng(geoCodeFromGeoScan['lat'],geoCodeFromGeoScan['lng']),
          builder: (ctx) =>
          new Container(
            child: Icon(Icons.location_on,color: Theme.of(ctx).primaryColor,size: 45.0,),
          ),
        ),
      ],
    );
  }
}