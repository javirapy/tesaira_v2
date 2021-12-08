import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/datos_visita.dart';
import 'package:formvalidation/src/models/datos_vivienda_model.dart';
import 'package:formvalidation/src/models/insert_visita_model.dart';
import 'package:formvalidation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:formvalidation/src/providers/visita_provider.dart';
import 'package:formvalidation/src/widgets/app_alertdialog.dart';
import 'package:formvalidation/src/widgets/loader.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
//import 'package:geolocator/geolocator.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'package:location/location.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';

class DetalleVisitaProcedimientoPage extends StatefulWidget {
  @override
  _DetalleVisitaProcedimientoPageState createState() => _DetalleVisitaProcedimientoPageState();
}

class _DetalleVisitaProcedimientoPageState extends State<DetalleVisitaProcedimientoPage> {
  DetallesVisitas2 datoVisita;
  double latitud;
  double longitud;
  final _prefs = new PreferenciasUsuario();

 

  @override
  Widget build(BuildContext context) {
    datoVisita = ModalRoute.of(context).settings.arguments;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _crearAppBar(context),
        body: Column(
          children: <Widget>[
            //  _mostrarMapa(),
            _crearCabecera3(datoVisita),
            Divider(
              height: 0.2,
              color: Colors.green,
              indent: 10,
            ),
           _crearFamiliaresListView(datoVisita,context),
            //   _crearVistaPersona(datoVisita),
            // Container(
            //   margin: EdgeInsets.only(left:15, right:15),
            //   child: _crearVistaPersona(datoVisita)
            // )
          ],
        ),
      ),
    );
  }

  Widget _crearAppBar(context) {
    bool notNull(Object o) => o != null;
    return AppBar(
      backgroundColor: Colors.green,
      title: Text('Consulta de Procedimientos',
          style: TextStyle(color: Colors.white)),
      centerTitle: true,
    );
  }

  Widget _crearCabecera3(DetallesVisitas2 visita) {
    // if (visita == null) return Container();

    // final _screenSize = MediaQuery.of(context).size;
    final estiloTexto = TextStyle(
        color: Colors.green, fontWeight: FontWeight.w600, fontSize: 16);
    final estiloInfo = TextStyle(color: Colors.green);
    // final _ssbr = Radius.circular(10.0);

    return Container(
      //height: _screenSize.height * 0.3,
      padding: EdgeInsets.only(left: 20.0, right: 20),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.only(bottomLeft: _ssbr, bottomRight: _ssbr),
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Expanded(child: Text('N° Documento', style: estiloTexto)),
                Expanded(child: Text('Paciente: ', style: estiloTexto))
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(child: Text(visita.paciente.persona.numeroDocumento, style: estiloInfo)),
                Expanded(
                    child: Text(visita.paciente.persona.nombre +' '+visita.paciente.persona.apellido,
                        style: estiloInfo)),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: <Widget>[],
            ),
          ],
        ),
      ),
    );
  }


    Widget _crearFamiliaresListView(
      DetallesVisitas2 actores, context) {

    List<Widget> actividades = [];
    actores.actividades.forEach((opt) {
      dynamic widgetTemp =
          _personaTarjeta(opt, context);
      actividades.add(widgetTemp);
      actividades.add(Divider(
        height: 1,
        color: Colors.green,
      ));
    });

    return Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * 0.47,
        child: ListView(
          children: actividades,
        ));
        
  }

    Widget _personaTarjeta(ActividadesVisitas actividad, context) {

    

    return Container(
        //elevation: 1,
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Color.fromRGBO(0, 204, 102, 0.1),
        child: //Column(
            //children: <Widget>[

        SingleChildScrollView(
          
          child:
            ListTile(
         // onTap: () => mostrarDetalle(persona),
          leading: Icon(Icons.system_security_update_good_sharp, color: Colors.green),
          title: Text(
            actividad.procedimiento.nombre,
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
          ),
          subtitle: Column(
           // mainAxisSize: MainAxisSize.min,
           mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text('Valor: '+actividad.valor ),
               Text('Comentario: ' + actividad.comentario),
            ],
          ),
        )
          
          
    
        ),
        //],
        //),
        );

        
  }

  //   mostrarDetalle(DetallesVisitas2 info) async{
  
  //   Navigator.pushNamed(context, 'detVisitaProcedimiento', arguments: info);
  // }

  String dateToSofia(DateTime fecha) {
    final f = DateFormat("dd-MM-yyyy");
    return f.format(fecha);
  }
}
