import 'package:flutter/material.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:qrscaner/bloc/scans_bloc.dart';
import 'package:qrscaner/pages/direcciones_page.dart';
import 'package:qrscaner/pages/mapa_page.dart';
import 'package:qrscaner/providers/db_provider.dart';
import 'package:qrscaner/utils/scans_util.dart' as utils;


class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scansBloc = ScansBloc();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QrScanner"),
        actions:<Widget>[
          IconButton(
            icon: Icon(Icons.delete), 
            onPressed: (){
              scansBloc.borraTodosScans();
            }
          )
        ]
      ),
      body: _cargarPage(currentPage),
      bottomNavigationBar: _crearBottomNavigation(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.filter_center_focus),
        onPressed: _qrScann
      ),
      
    );
  }

  Widget _cargarPage(int page){
    switch (page) {
      case 0:
          return MapaPage();
        break;
      case 1:
        return DireccionesPage();
      break;
      default:
        return DireccionesPage();
    }
  }

  Widget _crearBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: currentPage,
      onTap: (index){
        setState(() {
          currentPage = index;
        });
      },
      items: [
         BottomNavigationBarItem(
           icon: Icon(Icons.map),
           title: Text("Mapa")
         ),
         BottomNavigationBarItem(
           icon: Icon(Icons.brightness_5),
           title: Text("Direcciones")
         ),
      ],
    );
  }

  void _qrScann() async {

    //geo:40.66175814219636,-73.96199598750003
    //http://google.com.ar
    String futureString = '';

    try {
       futureString = await QRCodeReader().scan();

    } catch (e) {
      futureString = e.toString();
    }   

    if(futureString != null){
      ScanModel nuevoScan =  ScanModel(valor: futureString);
      
      scansBloc.agregarScans(nuevoScan);

      utils.abrirScanModel(context, nuevoScan);

    }
  }
}