import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/preferencias_usuario/preferencias_usuario.dart';

import 'dart:math';
import 'dart:ui';

import 'package:formvalidation/src/providers/visita_provider.dart';



class BotonesPage extends StatelessWidget {
  final VisitaProvider provider = new VisitaProvider();
  int cantidad = 0;
  final _prefs = new PreferenciasUsuario();
  

  @override
  Widget build(BuildContext context) {

    final estiloNegrita = TextStyle(color: Colors.green, fontWeight: FontWeight.w600);
    final estiloNormal = TextStyle(fontWeight: FontWeight.normal );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Menú principal', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        leading: Container(),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (choice) => choiceAction(choice, context),
            icon: Icon(Icons.perm_identity),
            itemBuilder: (BuildContext context){
              return ConstPopUp().retrieveListaPop().map((String choice){
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice, style: ConstPopUp.salir != choice ? estiloNormal : estiloNegrita,),
                  );
              }).toList();
            }      
         )
          
          /*IconButton(
              icon: Icon(Icons.search),
              onPressed: (){
             
              },
            )*/


          /*CircleAvatar(
            backgroundImage: Icons.perm_identity,
            child: PopupMenuButton(
              itemBuilder: (BuildContext context){
                return ConstPopUp().retrieveListaPop().map((String choice){
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              }
            ),
          )*/
        ]    
      ), 
      body: FutureBuilder(
            future: provider.getContadorNotificacion(),
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              if(snapshot.hasData){
                cantidad = snapshot.data;
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

  void choiceAction(String choice, BuildContext context){
    if(choice == ConstPopUp.salir){

      final bloc = LocalProvider.of(context);
     bloc.changeEmail("");

      //elimino el token que habia usado para loguearme
      final _prefs = new PreferenciasUsuario();
      print( _prefs.token.toString());
      _prefs.token="null";
      _prefs.infoUser ="";
      print( _prefs.token.toString());
     // Navigator.pushNamed(context, 'login');
     Navigator.pushReplacementNamed(context, 'login');
    }
     
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
          top: -100.0,
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
            _crearBotonRedondeado( Colors.orange, Icons.group_add, 'Nueva Visita' , 'nuevaVisita', context),
            _crearBotonRedondeado( Colors.purpleAccent, Icons.multiline_chart, 'Mi productividad' , 'productividad', context),
          ]
        ),
        TableRow(
          children: [
            _crearBotonRedondeado( Colors.pinkAccent, Icons.home, 'Datos Censo' , 'botonescenso', context),
            _crearBotonRedondeado( Colors.blue, Icons.notifications, 'Notificaciones' , 'dashnoti', context, cantidad),
          ]
        ),
        TableRow(
          children: [
            _crearBotonRedondeado( Colors.pink, Icons.sync_problem, 'Sincronizar Visitas' , 'sincronizar', context),
            // SizedBox(width: 50,)
           _crearBotonRedondeado( Colors.green, Icons.sync, 'Visitas Sincronizadas' , 'sincronizados', context),

          ]
        )
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
                        child: cantidad != null ? botonEnumerado(cantidad) : Icon( icono, color: Colors.white, size: 30.0 ),
                      ),
                      Text( texto , style: TextStyle( color: color ,fontWeight: FontWeight.bold)),
                      SizedBox( height: 5.0 )
                    ],
                  ),
  
            ),
          ),
      ),
    );
  }


}

class ConstPopUp {
  static const String salir = 'Cerrar sesión';
  String userInfo;

  final _prefs = new PreferenciasUsuario();


  List<String> listaPop = new List();
  
  List<String> retrieveListaPop(){
    listaPop.add("Version: 2.0");
    listaPop.add(_prefs.infoUser);
    listaPop.add(salir);
    
    return listaPop;
  }
  
  

}