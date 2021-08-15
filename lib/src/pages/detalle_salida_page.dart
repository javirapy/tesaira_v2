import 'package:flutter/material.dart';
import 'package:formvalidation/src/providers/visita_provider.dart';
import 'package:formvalidation/src/widgets/loader.dart';

class DetalleSalidaPage extends StatelessWidget {
  
  final VisitaProvider provider = new VisitaProvider();

  @override
  Widget build(BuildContext context) {

    int idNotificacion = ModalRoute.of(context).settings.arguments;

     return  FutureBuilder(
        future: provider.getDetalleSalida(idNotificacion),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData){
            return buildScreen(snapshot.data);
          }else{
            return LoadingScreen();
          }
        },
      );

     
  }

  Widget buildScreen(Map<String, dynamic> data){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(data['tipos_suceso']['nombre']),
        centerTitle: true,
      ),
      body: buildBody(data),
    );
  }

  Widget buildBody(Map<String, dynamic> data) {
    final estiloTexto = TextStyle(color: Colors.green, fontWeight: FontWeight.w600, fontSize: 16);
    final estiloInfo = TextStyle(color: Colors.grey );

    return Container(
      padding : EdgeInsets.only(left:20.0, right: 20),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20,),
            Row(
                children: <Widget>[
                  Expanded(
                    child: Text('Fecha de creación: ', style: estiloTexto)
                  )
                ],
              ),
                            Divider(height: 1, color: Colors.green,),

              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(data['created'], style: estiloInfo,)
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text('Detalles: ', style: estiloTexto)
                  )
                ],
              ),
                            Divider(height: 1, color: Colors.green,),

              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(data['comentario'], style: estiloInfo)
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text('Paciente suceso: ', style: estiloTexto)
                  )
                ],
              ),
                            Divider(height: 1, color: Colors.green,),

              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(data['paciente']['persona']['identidad'], style: estiloInfo)
                  )
                ],
              ),
          ]
        )
      )
    );

  }


}