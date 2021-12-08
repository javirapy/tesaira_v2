import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:formvalidation/src/models/datos_visita.dart';
import 'package:formvalidation/src/models/insert_visita_model.dart';
import 'package:formvalidation/src/providers/visita_provider.dart';
import 'package:formvalidation/src/widgets/loader.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:intl/intl.dart';

class ListaVisitasPage extends StatefulWidget {
  

  @override
  _ListaVisitasPageState createState() => _ListaVisitasPageState();
}

class _ListaVisitasPageState extends State<ListaVisitasPage> {
  final VisitaProvider provider = new VisitaProvider();
  Future _future;

    InsertVisita fechas = new InsertVisita();

  //  @override
  // void initState() {
  //   super.initState();
  //   _future = provider.obtenerVisitas(fechas[0].fini, fechas[0].ffin);
  // }

  @override
  Widget build(BuildContext context) {

    fechas= ModalRoute.of(context).settings.arguments;
    print(fechas);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Visitas Realizadas'),
      ),
      body: 

 Container(
        padding: new EdgeInsets.all(16.0),
        child: new  FutureBuilder(
          future: provider.obtenerVisitas(fechas),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData){
              if (snapshot.data.length > 0){
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                     return buildTarjeta(snapshot.data[index]);
                    /* return new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                             Container(
                               child: Text('Tex')
                             )
                           ]);*/

                    });
              }
              
            }else if ( snapshot.data == null  || snapshot.data.length <= 0) {
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
                              child: Text("...", style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0)));
            }else if (snapshot.hasError) {
              return new Text("${snapshot.error}");
            }
          //   return LoadingScreen();
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
                              child: Text("No existen datos para la fecha indicada!", style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0)));
          },
    ),
    ),
    );
  }
  

  Widget buildTarjeta(Map<String, dynamic> data){
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () => mostrarDetalle(data['id']),
          leading: Icon(Icons.home, color: Colors.green),
         title: Text('Id: '+ data['id'].toString(), style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),),
          subtitle: Text('Fecha Visita: '+ dateToSofia(DateTime.parse(data['fecha']))),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
             // _builCarita(persona),
              GestureDetector(
                child: Icon(Icons.arrow_forward,color: Colors.green),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.green,)
      ],
    );
  }

  mostrarDetalle(dynamic id) async{
    DatosVisita info = await provider.detalleVisita(id);
    print(info);
    Navigator.pushNamed(context, 'detVisita', arguments: info);
  }

  String dateToSofia(DateTime fecha) {
    final f = DateFormat("dd-MM-yyyy");
    return f.format(fecha);
  }
}