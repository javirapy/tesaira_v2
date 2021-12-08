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
  _SincronizadosVisitaPageState createState() =>
      _SincronizadosVisitaPageState();
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
                      children: <Widget>[
                        ListTile(
                        //  onTap: () => mostrarDetalle(data['id']),
                          leading: Icon(Icons.check, color: Colors.green),
                          title: Text(
                            'Id: ' + snapshot.data[index].viviendaId.toString() +' - Fecha: '+
                            snapshot.data[index].fechaVisita.toString(),
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text('Paciente: ' +
                            snapshot.data[index].documentoBuscado +' ' + snapshot.data[index].nombre+' '+ snapshot.data[index].apellido
                            ),
                          // trailing: Row(
                          //   mainAxisSize: MainAxisSize.min,
                          //   children: <Widget>[
                          //     // _builCarita(persona),
                          //     GestureDetector(
                          //       child: Icon(Icons.arrow_forward,
                          //           color: Colors.green),
                          //     ),
                          //   ],
                          // ),
                        ),
                        Divider(
                          height: 1,
                          color: Colors.green,
                        )
                      ],
                    );
                    ;
                  });
            } else if (snapshot.data == null) {
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
                  child: Text("No hay datos sinxronizados!!",
                      style: new TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0)));
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

  sincronizar(VisitaBloc bloc, context, idVisita) async {
    InsertVisita sendData = new InsertVisita();
    // await obtenerUbicacion();
    // sendData.lat = latitud;
    // sendData.lon = longitud;
    // sendData.viviendaId = datosVivienda.vivienda.id;
    // sendData.detallesVisitas = await bloc.obtenerDetallesVisita();
    final visitaProvider = new VisitaProvider();
    String mensaje = 'ok';

    InsertVisita sendDataLocal = new InsertVisita();
    sendDataLocal = await bloc.getDatosVisitasLocal(idVisita);

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      print('not connected');
      mensaje = 'nok';
    }

    if (mensaje == 'ok') {
      mensaje = await visitaProvider.crearVisita(sendDataLocal);
      print('Enviado para sincronizar ${sendDataLocal.toJson()}');

      bloc.updateSincronizado(idVisita);
    }

    if (mensaje == 'ok') {
      showMessageSuccess(context, 'Visita sincronizada!!');
    } else {
      showMessageSuccess(context, 'Volver a probar no se pudo sincronizar');
    }
  }

  void showMessageSuccess(BuildContext context, String mensaje) {
    AppAlertDialog.success(
        context: context,
        tittle: 'Tesãira',
        desc: mensaje,
        btnOkOnPress: () =>
            Navigator.pushReplacementNamed(context, 'sincronizar'));
  }

  void mostrarAlerta(BuildContext context, String mensaje) {
    AppAlertDialog.error(
        context: context,
        tittle: 'Tesãira',
        desc: mensaje,
        btnCancelOnPress: () => print('Modal cerrado'));
  }
}
