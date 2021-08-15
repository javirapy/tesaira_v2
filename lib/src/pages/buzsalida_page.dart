import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:formvalidation/src/providers/visita_provider.dart';
import 'package:formvalidation/src/widgets/loader.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:intl/intl.dart';

class BuzSalidaPage extends StatefulWidget {
  

  @override
  _BuzSalidaPageState createState() => _BuzSalidaPageState();
}

class _BuzSalidaPageState extends State<BuzSalidaPage> {
  final VisitaProvider provider = new VisitaProvider();
  Future _future;

  

   @override
  void initState() {
    super.initState();
    _future = provider.getBuzSalida();
  }

  @override
  Widget build(BuildContext context) {
    
   

    return  FutureBuilder(
          future: _future,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData){
              return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return buildTarjeta(snapshot.data[index]);
                    });
            }else{
             return LoadingScreen();
            }
          },
    );
  }

  Widget buildTarjeta(Map<String, dynamic> data){
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () => mostrarDetalle(data['id']),
          leading: Icon(Icons.send, color: Colors.green),
          title: Text(data['tipos_suceso']['nombre'], style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),),
          subtitle: Text('Creado el: ' + dateToSofia(DateTime.parse(data['created']))),
        ),
        Divider(height: 1, color: Colors.green,)
      ],
    );
  }

  mostrarDetalle(dynamic id){
    Navigator.pushNamed(context, 'detSuceso', arguments: id);
  }

  String dateToSofia(DateTime fecha) {
    final f = DateFormat("dd-MM-yyyy  HH:mm:ss");
    return f.format(fecha);
  }
}