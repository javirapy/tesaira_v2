import 'package:flutter/material.dart';
import 'package:formvalidation/src/pages/buzentrada_page.dart';
import 'package:formvalidation/src/pages/buzsalida_page.dart';

class DashNotiPage extends StatefulWidget {
  @override
  _DashNotiPageState createState() => _DashNotiPageState();
}

class _DashNotiPageState extends State<DashNotiPage> {

  int currentIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Notificaciones'),
        centerTitle: true,
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon( Icons.add ,color: Colors.white, ),
        onPressed: () {
          Navigator.pushNamed(context, 'notificaciones');
        }  ,
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _callPage( int paginaActual ) {
    switch( paginaActual ) {
      case 0: return BuzEntradaPage();
      case 1: return BuzSalidaPage();
      default:
        return BuzEntradaPage();
    }
  }

   Widget _crearBottomNavigationBar() {

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index; 
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon( Icons.inbox ),
          title: Text('Recibidos')
        ),
        BottomNavigationBarItem(
          icon: Icon( Icons.mobile_screen_share ),
          title: Text('Generados')
        ),
      ],
    );


  }


}