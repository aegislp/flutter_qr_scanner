import 'package:flutter/material.dart';
import 'package:qrscaner/pages/direcciones_page.dart';
import 'package:qrscaner/pages/mapa_page.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        onPressed: (){
          _qrScann();
        },
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

    String barcodeScanRes = '';
    try {
       barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#000000", "Cancel", false, ScanMode.QR);
    } catch (e) {
      barcodeScanRes = e.toString();
    }

    if(barcodeScanRes != null){
      print(".--------------------------------- TNEMOS INFORMACION ------------------------$barcodeScanRes");
    }

  }
}