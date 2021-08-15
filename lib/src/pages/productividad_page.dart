import 'package:flutter/material.dart';
import 'package:formvalidation/src/providers/visita_provider.dart';
import 'package:formvalidation/src/widgets/loader.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProductividadPage extends StatelessWidget {

  final VisitaProvider provider = new VisitaProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Mi Productividad', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: FutureBuilder(
            future: provider.getProductividad(),
            builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if(snapshot.hasData){
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return buildTarjeta(snapshot.data[index]);
                    });
              }else{
                return LoadingScreen();
              }
            }  
        ),
    );
  }

  Widget buildTarjeta(Map<String, dynamic> data){

    final estiloNegrita = TextStyle(color: Colors.black87, fontWeight: FontWeight.w600);
    final estiloNormal = TextStyle(fontWeight: FontWeight.normal );

    return Column(
      children: <Widget>[
        ListTile(
          //onTap: () => mostrarDetalle(data['id']),
          leading: Icon(MdiIcons.fromString(data['icon']) , color: Colors.green),
          title: Text(data['title']),
          //trailing: Text(data['data'].toString(), style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
          trailing: botonEnumerado(data['data']),
        ),
        Divider(height: 1, color: Colors.green,)
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
}