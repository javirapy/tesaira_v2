import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/providers/visita_provider.dart';
import 'package:formvalidation/src/widgets/loader.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ListaSincronizarPage extends StatefulWidget {
  @override
  _ListaSincronizarPageState createState() => _ListaSincronizarPageState();
}

class _ListaSincronizarPageState extends State<ListaSincronizarPage> {

  final VisitaProvider provider = new VisitaProvider();
    VisitaBloc bloc;

  
  @override
  Widget build(BuildContext context) {
        bloc = LocalProvider.visitaBloc(context);


    return  FutureBuilder(
          future: bloc.getListDatosVisitasLocal('N'),
          builder: (BuildContext context, AsyncSnapshot snapshot) {

            print(snapshot..data[0]);
            // if(snapshot.hasData){
            //   return ListView.builder(
            //         itemCount: snapshot.data.length,
            //         itemBuilder: (BuildContext ctxt, int index) {
            //           return buildTarjeta(snapshot.data[index]);
            //         });
            // }else{
            //   return LoadingScreen();
            // }
          },
    );
  }

  Widget buildTarjeta(Map<String, dynamic> data){

    final estiloNegrita = TextStyle(color: Colors.black87, fontWeight: FontWeight.w600);
    final estiloNormal = TextStyle(fontWeight: FontWeight.normal );
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () => mostrarDetalle(data['id']),
          leading: data['estado'] == 'V' ? Icon(Icons.drafts, color: Colors.green) : Icon(Icons.markunread, color: Colors.green),
          title: Text(data['tipo_notificacion'], style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),),
          subtitle: Text('Creado el: ' + dateToSofia(DateTime.parse(data['created'])),
                    style: data['estado'] == 'V' ? estiloNormal : estiloNegrita,),
        ),
        Divider(height: 1, color: Colors.green,)
      ],
    );
  }

  mostrarDetalle(dynamic id){
    Navigator.pushNamed(context, 'detNotificacion', arguments: id);
  }

  String dateToSofia(DateTime fecha) {
    final f = DateFormat("dd-MM-yyyy  HH:mm:ss");
    return f.format(fecha);
  }
  
}