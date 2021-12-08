import 'package:flutter/material.dart';

import 'dart:math';
import 'dart:ui';

import 'package:formvalidation/src/providers/visita_provider.dart';



class BotonesVisitaPage extends StatelessWidget {
  final VisitaProvider provider = new VisitaProvider();
  int cantidad = 0;
  

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Gestion Visitas', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        
      ), 
      body: FutureBuilder(
            future: provider.getBuzEntrada(),
            builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if(snapshot.hasData){
                cantidad = snapshot.data.length;
              }

              return Stack(
                children: <Widget>[
                  _fondoApp(),

                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        _titulos(),
                        _botonesRedondeados(context)
                      ],
                    ),
                  )

                ],
              );
            },
      )
    );
  }


  Widget _fondoApp(){

    final gradiente = Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        /*gradient: LinearGradient(
          begin: FractionalOffset(0.0, 0.6),
          end: FractionalOffset(0.0, 1.0),
          colors: [
            Color.fromRGBO(52, 54, 101, 1.0),
            Color.fromRGBO(35, 37, 57, 1.0)
          ]
        )*/
      ),
    );


    final cajaVerde = Transform.rotate(
      angle: -pi / 5.0,
      child: Container(
        height: 360.0,
        width: 360.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80.0),
          gradient: LinearGradient(
            colors: [
              //Color.fromRGBO(236, 98, 188, 1.0),
              //Color.fromRGBO(241, 142, 172, 1.0)
              Color.fromRGBO(8, 147, 51, 1.0),
              Color.fromRGBO(51, 255, 178, 2.0)
            ]
          )
        ),
      )
    );
    
    return Stack(
      children: <Widget>[
        gradiente,
        Positioned(
          top: 350.0,
          child: cajaVerde
        )
      ],
    );

  }

  Widget _titulos() {

    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Text('Classify transaction', style: TextStyle( color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold )),
            //SizedBox( height: 10.0 ),
            //Text('Classify this transaction into a particular category', style: TextStyle( color: Colors.white, fontSize: 18.0 )),
          ],
        ),
      ),
    );

  }

  Widget _botonesRedondeados(context) {
  return Table(
      children: [
        TableRow(
          children: [
            _crearBotonRedondeado( Colors.amberAccent, Icons.group_add, 'Nueva Visita' , 'nuevaVisita', context),
            _crearBotonRedondeado( Colors.blue, Icons.people, 'Consulta de Visitas' , 'visitasFecha', context),
          ]
        ),
      ],
    );

  }

  Widget botonEnumerado(int cantidad){
    return  Stack(
            children: <Widget>[
              new Icon(Icons.notifications,color: Colors.white, size: 30.0),
              new Positioned(
                right: 1,
                top: 1,
                child: new Container(
                  padding: EdgeInsets.all(2),
                  decoration: new BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Text(
                    cantidad.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ) 
            ],
          );
  }

  
  Widget _crearBotonRedondeado( Color color, IconData icono, String texto , String pagina, context, [cantidad]) {
    return ClipRect(
      child: GestureDetector(
          onTap: (){
            Navigator.pushNamed(context, pagina);
          },
              child: BackdropFilter(
                filter: ImageFilter.blur( sigmaX: 10.0, sigmaY: 10.0 ),
                child: Container(
                  height: 180.0,
                  margin: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(62, 66, 107, 0.9),
                    borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SizedBox( height: 5.0 ),
                      CircleAvatar(
                        backgroundColor: color,
                        radius: 35.0,
                        child:  Icon( icono, color: Colors.white, size: 30.0 ),
                      ),
                      Text( texto , style: TextStyle( color: color ,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                      SizedBox( height: 5.0 ),
                    ],
                  ),
  
            ),
          ),
      ),
    );
  }


}