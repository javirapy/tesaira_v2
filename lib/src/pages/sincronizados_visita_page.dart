import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/insert_visita_model.dart';
import 'package:formvalidation/src/providers/db_provider.dart';
import 'package:formvalidation/src/providers/visita_provider.dart';
import 'package:formvalidation/src/widgets/app_alertdialog.dart';
import 'package:formvalidation/src/widgets/loader.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

Future<List<InsertVisita>> fetchEmployeesFromDatabase(VisitaBloc bloc) async {
  print(bloc.getListDatosVisitasLocal('S'));

  List<InsertVisita> todo = new List();

  todo = await bloc.getListDatosVisitasLocal('S');
  return todo;
}

class SincronizadosVisitaPage extends StatefulWidget {
  @override
  _SincronizadosVisitaPageState createState() => _SincronizadosVisitaPageState();
}

class _SincronizadosVisitaPageState extends State<SincronizadosVisitaPage> {
  VisitaBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = LocalProvider.visitaBloc(context);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Visitas Sincronizadas'),
      ),
      body: new Container(
        padding: new EdgeInsets.all(16.0),
        child: new FutureBuilder<List<InsertVisita>>(
          future: fetchEmployeesFromDatabase(bloc),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return new ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              height: 90.0,
                              margin: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 3.0,
                                    offset: Offset(0.0, 5.0),
                                    spreadRadius: 3.0)
                              ], borderRadius: BorderRadius.circular(10.0)),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.check,color: Colors.green, size: 50.0),
                                      onPressed: () {
                                        // sincronizar(bloc, context, snapshot.data[index].id);
                                      }),
                                      SizedBox(
                                    width: 15,
                                  ),
                                  
                                  // Text(
                                  //     "Visita: " +
                                  //         snapshot.data[index].id.toString(),
                                  //     style: new TextStyle(
                                  //         fontWeight: FontWeight.bold,
                                  //         fontSize: 18.0)),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                    height: 15,
                                  ),
                                    Text(
                                      "Vivienda Id: " +
                                          snapshot.data[index].viviendaId
                                              .toString(),
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0)),

                                          Text(
                                      "Fecha: " +
                                          snapshot.data[index].fechaVisita
                                              .toString(),
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0)),

                                          Text(
                                      "Paciente: " +
                                          snapshot.data[index].documentoBuscado
                                              .toString(),
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0)),
                                          Text(
                                          snapshot.data[index].nombre + ' ' + snapshot.data[index].apellido
                                              .toString(),
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0)),
                                    ],
                                  ),
                                  
                                  // SizedBox(
                                  //   width: 15,
                                  // ),
                                  
                                  // new Divider(),
                                  // IconButton(
                                  //     icon: Icon(Icons.check,color: Colors.green, size: 50.0),
                                  //     onPressed: () {
                                  //       // sincronizar(bloc, context, snapshot.data[index].id);
                                  //     })
                                ],
                              ))
                        ]);
                  });
            } else if ( snapshot.data == null) {
              return Container(
                              width: 600.0,
                              margin: EdgeInsets.all(60),
                              decoration: BoxDecoration(boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 3.0,
                                    offset: Offset(0.0, 5.0),
                                    spreadRadius: 3.0)
                              ], borderRadius: BorderRadius.circular(10.0)),
                              child: Text("No hay datoa sinxronizados!!", style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0)));
            
            } else if (snapshot.hasError) {
              return new Text("${snapshot.error}");
            }
            return new Container(
              alignment: AlignmentDirectional.center,
              child: new CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  sincronizar(VisitaBloc bloc, context, idVisita) async{
    InsertVisita sendData = new InsertVisita();
    // await obtenerUbicacion();
    // sendData.lat = latitud;
    // sendData.lon = longitud;
    // sendData.viviendaId = datosVivienda.vivienda.id;
    // sendData.detallesVisitas = await bloc.obtenerDetallesVisita();
    final visitaProvider = new VisitaProvider();
    String mensaje='ok';
   

    InsertVisita sendDataLocal = new InsertVisita(); 
    sendDataLocal = await bloc.getDatosVisitasLocal( idVisita );



 

     try { 
      final result = await InternetAddress.lookup('google.com'); 
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) 
    { print('connected'); } 
    } 
    on SocketException catch (_) { print('not connected'); 
    mensaje='nok';
    }

if(mensaje == 'ok'){
     mensaje = await visitaProvider.crearVisita(sendDataLocal);
     print('Enviado para sincronizar ${sendDataLocal.toJson()}');

     bloc.updateSincronizado(idVisita);
}
    

    if(mensaje == 'ok'){
      showMessageSuccess(context, 'Visita sincronizada!!');
    }else{
      showMessageSuccess(context, 'Volver a probar no se pudo sincronizar');

    }
    
  }

   void showMessageSuccess(BuildContext context, String mensaje ) {
    AppAlertDialog.success(
      context: context,
      tittle: 'Tesãira', 
      desc: mensaje, 
      btnOkOnPress: () => Navigator.pushReplacementNamed(context, 'sincronizar')
    );
  }

  void mostrarAlerta(BuildContext context, String mensaje ) {
    AppAlertDialog.error(
      context: context,
      tittle: 'Tesãira',
      desc: mensaje,
      btnCancelOnPress: () => print('Modal cerrado')
    );
  }
  
}
