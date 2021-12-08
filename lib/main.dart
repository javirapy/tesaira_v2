
import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/insert_visita_model.dart';
import 'package:formvalidation/src/pages/botones_censo_page.dart';
import 'package:formvalidation/src/pages/botones_page.dart';
import 'package:formvalidation/src/pages/botones_visita_page.dart';
import 'package:formvalidation/src/pages/buscar_agregar_persona_2_page.dart';
import 'package:formvalidation/src/pages/buscar_agregar_persona_page.dart';
import 'package:formvalidation/src/pages/buscar_persona_page.dart';
import 'package:formvalidation/src/pages/dash_noti_page.dart';
import 'package:formvalidation/src/pages/det_visita.dart';
import 'package:formvalidation/src/pages/det_visita_procedimiento.dart';
import 'package:formvalidation/src/pages/detalle_salida_page.dart';
import 'package:formvalidation/src/pages/home_page.dart';
import 'package:formvalidation/src/pages/home_tab_page.dart';
import 'package:formvalidation/src/pages/lista_visitas_page.dart';
import 'package:formvalidation/src/pages/login_page.dart';
import 'package:formvalidation/src/pages/notifcacion_page.dart';
import 'package:formvalidation/src/pages/paciente_buscar_agregar_2_page.dart';
import 'package:formvalidation/src/pages/paciente_page.dart';
import 'package:formvalidation/src/pages/paciente_buscar_agregar_page.dart';
import 'package:formvalidation/src/pages/paciente_page_censo.dart';
import 'package:formvalidation/src/pages/paciente_princ_page.dart';
import 'package:formvalidation/src/pages/procedimiento_page.dart';
import 'package:formvalidation/src/pages/productividad_page.dart';
import 'package:formvalidation/src/pages/search_page.dart';
import 'package:formvalidation/src/pages/search_persona_page.dart';
import 'package:formvalidation/src/pages/sincronizados_visita_page.dart';
import 'package:formvalidation/src/pages/sincronizar_visita_page.dart';
import 'package:formvalidation/src/pages/visitas_por_fecha_page.dart';
import 'package:formvalidation/src/pages/vivienda_page.dart';
import 'package:formvalidation/src/pages/vivienda_persona_page.dart';
import 'package:formvalidation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:formvalidation/src/widgets/progress_page2.dart';
import 'package:location/location.dart';
//import 'package:location/location.dart';

import 'src/pages/detalle_entrada_page.dart';
import 'src/pages/nueva_visita_page.dart';
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

  runApp(MyApp());

}
 

 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LocalProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tesaira',
        //home: MyHomePage(title: '',),
        initialRoute: 'botones',
        routes: {     
          'login'         : ( BuildContext context ) => LoginPage(),//
          'botones'       : ( BuildContext context ) => BotonesPage(),
          'botonescenso'  : ( BuildContext context ) => BotonesCensoPage(),//
          'nuevaVisita'   : ( BuildContext context ) => NuevaVisitaPage(),//
          'buscarPesona'   : ( BuildContext context ) => BuscarPersonaPage(),
          'vivienda'      : ( BuildContext context ) => ViviendaPage(),
          'viviendapersona'      : ( BuildContext context ) => ViviendaPersonaPage(),
          'busqueda'      : ( BuildContext context ) => SearchPage(),
          'procedimiento' : ( BuildContext context ) => ProcedimientoPage(),
          'censo'         : ( BuildContext context ) => MyPages(),
          'paciente'      : ( BuildContext context ) => PacientePage(),
          'pacientecenso'      : ( BuildContext context ) => PacienteCensoPage(),
          'notificaciones': ( BuildContext context ) => NotificacionPage(),//
          'dashnoti'      : (BuildContext context) => DashNotiPage(),
          'detNotificacion'  : (BuildContext context) => DetalleEntradaPage(),
          'detSuceso'     :(BuildContext context) => DetalleSalidaPage(),
          'pacientePrinc'  : (BuildContext context) => PacientePrincPage(),//
          'productividad' :  (BuildContext context) => ProductividadPage(),
          'buscarAgregarPersona'   : ( BuildContext context ) => BuscarAgregarPersonaPage(),//
          'pacienteBuscarAgregar'   : ( BuildContext context ) => PacienteBuscarAgregarPage(),

          'buscarAgregarPersona2'   : ( BuildContext context ) => BuscarAgregarPersona2Page(),
          'pacienteBuscarAgregar2'   : ( BuildContext context ) => PacienteBuscarAgregar2Page(),
          'home'   : ( BuildContext context ) => HomePage(),
          'homeTap'   : ( BuildContext context ) => HomeTapPage(),
          'sincronizar':( BuildContext context ) => SincronizarVisitaPage(), //
          'buscarPersona':( BuildContext context ) => SearchPersonaPage(), //
          'sincronizados':( BuildContext context ) => SincronizadosVisitaPage(), //
'visitasFecha':( BuildContext context ) => VisitasPorFechaPage(), //
'listaVisitas':( BuildContext context ) => ListaVisitasPage(), //
'detVisita':( BuildContext context ) => DetalleVisitaPage(), //
'detVisitaProcedimiento':( BuildContext context ) => DetalleVisitaProcedimientoPage(), //
          'botonesVisitas'  : ( BuildContext context ) => BotonesVisitaPage(),//

         // ListaSincronizarPage
        },
        theme: ThemeData(
          primaryColor: Colors.green,
          accentColor: Colors.green
        ),
      ),
    );
      
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
   double latitud;
  double longitud;

  obtenerUbicacion() async{
    print('entra en obtener');
    //Position currentPosition = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

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
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Lat: $latitud'),
            Text('Lon: $longitud'),
            SizedBox(height: 20.0,),
            RaisedButton(
              onPressed:  obtenerUbicacion,
              child: Text('Get ubicacion'),
            ),
          ],
        ),
      ),
    );
  }
  }