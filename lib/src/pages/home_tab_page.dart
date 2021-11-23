import 'package:flutter/material.dart';
import 'package:formvalidation/src/pages/botones_page.dart';
import 'package:formvalidation/src/pages/buzentrada_page.dart';
import 'package:formvalidation/src/pages/buzsalida_page.dart';
import 'package:formvalidation/src/pages/home_page.dart';

class HomeTapPage extends StatefulWidget {
  @override
  _HomeTapPageState createState() => _HomeTapPageState();
}

class _HomeTapPageState extends State<HomeTapPage> {

  int currentIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.green,
      //   title: Text('Home'),
      //   centerTitle: true,
      // ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   child: Icon( Icons.add ,color: Colors.white, ),
      //   onPressed: () {
      //     Navigator.pushNamed(context, 'home');
      //   }  ,
      //   backgroundColor: Colors.green,
      // ),
    );
  }

  Widget _callPage( int paginaActual ) {
    switch( paginaActual ) {
      case 0: return HomePage();
      case 1: return BotonesPage();
      default:
        return BuzEntradaPage();
    }
  }

   Widget _crearBottomNavigationBar() {

    return BottomNavigationBar(
      backgroundColor: Colors.green, selectedItemColor: Colors.white,
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index; 
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon( Icons.home),
          title: Text('Home')
        ),
        BottomNavigationBarItem(
          icon: Icon( Icons.menu),
          title: Text('Gestion')
        ),
      ],
    );


  }


}