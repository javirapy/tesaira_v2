import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/datos_vivienda_model.dart';
import 'package:formvalidation/src/models/insert_visita_model.dart';
import 'package:formvalidation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:formvalidation/src/providers/visita_provider.dart';
import 'package:formvalidation/src/widgets/app_alertdialog.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
//import 'package:geolocator/geolocator.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'package:location/location.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';

class ViviendaPage extends StatefulWidget {
  @override
  _ViviendaPageState createState() => _ViviendaPageState();
}

class _ViviendaPageState extends State<ViviendaPage> {
  DatosViviendaModel datosVivienda;
  VisitaBloc bloc;
  double latitud;
  double longitud;
  final _prefs = new PreferenciasUsuario();

  Future<void> _launched;

  @override
  Widget build(BuildContext context) {
    datosVivienda = ModalRoute.of(context).settings.arguments;

    bloc = LocalProvider.visitaBloc(context);
    if ('NUEVAVISITA' == datosVivienda.fromView) {
      print('El documento buscado ${datosVivienda.documentoBuscado}');
      _prefs.documentoBuscado = datosVivienda.documentoBuscado;
      bloc.agregarDatosVivienda(datosVivienda);
      datosVivienda.fromView = null;
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _crearAppBar(context, datosVivienda.fromView),
        body: Column(
          children: <Widget>[
            //  _mostrarMapa(),
            _crearCabecera3(datosVivienda.vivienda),
            Divider(
              height: 0.5,
              color: Colors.green,
              indent: 10,
            ),
            _crearFamiliaresListView(
                datosVivienda.personas, context, datosVivienda.documentoBuscado)
            /*Container(
              margin: EdgeInsets.only(left:15, right:15),
              child: _crearFamiliaresListView(datosVivienda.personas, context, datosVivienda.documentoBuscado)
            )*/
          ],
        ),
      ),
    );
  }

  Widget _crearAppBar(context, dataConfirm) {
    bool notNull(Object o) => o != null;
    return AppBar(
      backgroundColor: Colors.green,
      title: Text('Datos vivienda', style: TextStyle(color: Colors.white)),
      centerTitle: true,
      actions: <Widget>[
        dataConfirm != null
            ? IconButton(
                tooltip: 'Generar visita',
                icon: Icon(Icons.done),
                onPressed: () {
                  crearObjetoInsert(bloc, context);
                },
              )
            : null
      ].where(notNull).toList(),
    );
  }

  Widget _crearCabecera3(ViviendaModel vivienda) {
    if (vivienda == null) return Container();

    final _screenSize = MediaQuery.of(context).size;
    final estiloTexto = TextStyle(
        color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16);
    final estiloInfo = TextStyle(color: Colors.white60);
    final _ssbr = Radius.circular(10.0);

    return Container(
      height: _screenSize.height * 0.3,
      padding: EdgeInsets.only(left: 20.0, right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: _ssbr, bottomRight: _ssbr),
        color: Colors.green,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Expanded(child: Text('No. Casa', style: estiloTexto)),
                Expanded(child: Text('Direccion', style: estiloTexto))
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(child: Text(vivienda.numero_casa, style: estiloInfo)),
                Expanded(child: Text(vivienda.direccion, style: estiloInfo))
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: <Widget>[
                Expanded(child: Text('Referencia', style: estiloTexto)),
                Expanded(child: Text('Tipo Techo', style: estiloTexto))
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(child: Text(vivienda.referencia, style: estiloInfo)),
                Expanded(child: Text(vivienda.tipos_techo, style: estiloInfo))
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: <Widget>[
                Expanded(child: Text('Tipo Pared', style: estiloTexto)),
                Expanded(child: Text('Tipo Piso', style: estiloTexto))
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(child: Text(vivienda.tipos_parede, style: estiloInfo)),
                Expanded(child: Text(vivienda.tipos_piso, style: estiloInfo))
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() {
                      // _launched = _launchInBrowser('https://maps.google.com/?q=23.135249,-82.359685');
                      var dir = 'https://maps.google.com/?q='+ vivienda.lat.toString() +','+vivienda.lon.toString();
                      print(dir);
                        _launched = _launchInBrowser(dir);
                    }),
                    child:  Row(
                    children: [
                       Icon(Icons.map_outlined), const Text(' Como llegar'),
                    ]
                      ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child:
                      ElevatedButton(
                        onPressed: () => setState(() {
                          var cel = 'https://wa.me/'+ vivienda.telefono_vivienda.toString()+'?text=Lo contactamos desde la USF Kumbarity';
                      print(cel);
                          _launched =
                              _launchInBrowser(cel);
                        }),
                        child: Row(
                    children: [
                       Icon(Icons.mark_chat_read), const Text(' Contactar'),
                    ]
                      ),

                    
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _builCarita(PersonaModel persona) {
    if (persona.cantProcedimiento != null && persona.cantProcedimiento > 0) {
      return Icon(
        Icons.insert_emoticon,
        color: Colors.green,
      );
    } else {
      return Container();
    }
  }

  Widget _personaTarjeta(PersonaModel persona, context, bool pintar) {
    return Container(
        //elevation: 1,
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: pintar ? Color.fromRGBO(0, 204, 102, 0.1) : Colors.white,
        child: //Column(
            //children: <Widget>[
            ListTile(
          title: Text(
            persona.documento,
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(persona.nombre + ' ' + persona.apellido),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _builCarita(persona),
              GestureDetector(
                child: Icon(Icons.add_box, color: Colors.green),
                onTap: () {
                  bloc.changeProcedimiento(null);
                  Navigator.pushNamed(context, 'busqueda',
                      arguments: persona);
                },
              ),
            ],
          ),
        )
        //],
        //),
        );
  }

  _launchInBrowser(url) async {
    //const url = 'https://www.google.com/';
    // html.window.open('https://www.google.com/', '');
    // if (await canLaunch(url)) {
      await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }

    //  try {
    //   final result = await InternetAddress.lookup('google.com');
    //   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    //     print('connected');
    //      await launch(url);
    //   }
    // } on SocketException catch (_) {
    //   print('not connected');
    // }
  }

  obtenerUbicacion() async {
    print('Entre en obtener');
    /*Position currentPosition = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitud = currentPosition.latitude;
      longitud = currentPosition.longitude;
    });*/

    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    print(location);
    setState(() {
      latitud = _locationData.latitude;
      longitud = _locationData.longitude;
    });
  }

  crearObjetoInsert(VisitaBloc bloc, context) async {
    InsertVisita sendData = new InsertVisita();
    await obtenerUbicacion();
    sendData.lat = latitud;
    sendData.lon = longitud;

    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    print(formattedDate);

    sendData.fechaVisita = formattedDate;
    sendData.viviendaId = datosVivienda.vivienda.id;
    sendData.documentoBuscado = datosVivienda.personas[0].documento;
    sendData.nombre = datosVivienda.personas[0].nombre;
    sendData.apellido = datosVivienda.personas[0].apellido;
    sendData.detallesVisitas = await bloc.obtenerDetallesVisita();
    final visitaProvider = new VisitaProvider();
    String mensaje = 'ok';

    print(datosVivienda.toJson());

    InsertVisita sendDataLocal = new InsertVisita();

    //sendDataLocal = await bloc.getDatosVisitasLocal( 17 );

    List<InsertVisita> sendDataLocalList = new List();

    // sendDataLocalList = await bloc.getListDatosVisitasLocal('N');

    // print('sendDataLocal   vvvvvvvv ${sendDataLocal.toJson()}');

    //print('sendDataLocalList   xxxx ${sendDataLocalList.toList()}');

    // for (var i = 0; i < count; i++) {
    //   bloc.agregarActividadVisitas(sendData.detallesVisitas[0].actividades[0], sendData.detallesVisitas[0].pacienteId, sendData.viviendaId);
    //}
    //bloc.agregarActividadVisitas(sendData.detallesVisitas[1].actividades[0], sendData.detallesVisitas[1].pacienteId, sendData.viviendaId);

    // InsertVisita sendData1 = new InsertVisita();

    // sendData1.detallesVisitas = await bloc.obtenerActividadVisitas(sendData.detallesVisitas[0].pacienteId);
    //print('datos de actividades ${ bloc.obtenerActividadVisitas(sendData.detallesVisitas[0]).toString()}');
    // print('sendata 1 ${sendData1.toJson()}');

    //  InsertVisita sendData2 = new InsertVisita();

    // sendData1.detallesVisitas = await bloc.obtenerActividadVisitas(sendData.detallesVisitas[1].pacienteId);
    //print('datos de actividades ${ bloc.obtenerActividadVisitas(sendData.detallesVisitas[0]).toString()}');
    // print('sendata 2 ${sendData2.toJson()}');

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
      mensaje = await visitaProvider.crearVisita(sendData);
      // mensaje = await visitaProvider.crearVisita(sendDataLocal);
      print('Datos apra ver sendDataLocal ${sendDataLocal.toJson()}');
    }
    // DatosViviendaModel datos = await bloc.obtenerDatosVivienda();

    // print('Datos para ver vivienda xx1 ${datos.toJson()}');

    if (mensaje == 'ok') {
      showMessageSuccess(
          context, 'Al presionar ok lo llevará a la pantalla de menú');
    } else {
      // mostrarAlerta(context, mensaje);
      await bloc.insertVisitasLocal(sendData);
      // sendDataLocal = await bloc.getDatosVisitasLocal( 23 );///ACA RECUPERO UNA VISITA
      // print('sendDataLocal   xxxxxxxxxxxxxxxxxxxxxxx ${sendDataLocal.toJson()}');
      mostrarAlertaSinRed(context,
          'Sin conexion a internet, se guardara para sincronizar Visita');
      // showMessageSuccess(context, 'Al presionar ok lo llevará a la pantalla de menú');
      print('Sincronizar xx11 ${sendData.toJson()}');
    }
  }

  void showMessageSuccess(BuildContext context, String mensaje) {
    AppAlertDialog.success(
        context: context,
        tittle: 'Tesãira',
        desc: mensaje,
        btnOkOnPress: () => Navigator.pushReplacementNamed(context, 'botones'));
  }

  void mostrarAlerta(BuildContext context, String mensaje) {
    AppAlertDialog.error(
        context: context,
        tittle: 'Tesãira',
        desc: mensaje,
        btnCancelOnPress: () => print('Modal cerrado'));
  }

  void mostrarAlertaSinRed(BuildContext context, String mensaje) {
    AppAlertDialog.error(
        context: context,
        tittle: 'Tesãira',
        desc: mensaje,
        btnCancelOnPress: () =>
            Navigator.pushReplacementNamed(context, 'botones'));
  }

  Widget _crearFamiliaresListView(
      List<PersonaModel> actores, context, docBuscado) {
    docBuscado = _prefs.documentoBuscado;

    List<Widget> personas = [];
    actores.forEach((opt) {
      dynamic widgetTemp =
          _personaTarjeta(opt, context, docBuscado == opt.documento);
      personas.add(widgetTemp);
      personas.add(Divider(
        height: 1,
        color: Colors.green,
      ));
    });

    return Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * 0.47,
        child: ListView(
          children: personas,
        ));
  }

  // Widget _mostrarMapa() {
  //   return  MapboxMap(
  //       accessToken: "pk.eyJ1Ijoic2NvdGhpcyIsImEiOiJjaWp1Y2ltYmUwMDBicmJrdDQ4ZDBkaGN4In0.sbihZCZJ56-fsFNKHXF8YQ",
  //     //  styleString: style,
  //       initialCameraPosition: CameraPosition(
  //         zoom: 15.0,
  //         target: LatLng(14.508, 46.048),
  //       ),
  //     );
        
  // }

}
