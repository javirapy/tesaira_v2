import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/datos_vivienda_model.dart';
import 'package:formvalidation/src/models/insert_visita_model.dart';
import 'package:formvalidation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:formvalidation/src/providers/visita_provider.dart';
import 'package:formvalidation/src/widgets/app_alertdialog.dart';
import 'package:location/location.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:geolocator/geolocator.dart';

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

  
  @override
  Widget build(BuildContext context) {
    datosVivienda = ModalRoute.of(context).settings.arguments;
    
    bloc = LocalProvider.visitaBloc(context);
    if('NUEVAVISITA' == datosVivienda.fromView ){
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
            _crearCabecera3(datosVivienda.vivienda),
            Divider(height: 0.5, color: Colors.green, indent: 10,),
            _crearFamiliaresListView(datosVivienda.personas, context, datosVivienda.documentoBuscado)
            /*Container(
              margin: EdgeInsets.only(left:15, right:15),
              child: _crearFamiliaresListView(datosVivienda.personas, context, datosVivienda.documentoBuscado)
            )*/
          ],
        ),
      ),  
    );
  }

  Widget _crearAppBar(context, dataConfirm){
    bool notNull(Object o) => o != null;
    return AppBar(
        backgroundColor: Colors.green,
        title: Text('Datos vivienda', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: <Widget>[
          dataConfirm != null ?
          IconButton(
              tooltip: 'Generar visita',
              icon: Icon(Icons.done),
              onPressed: (){
                crearObjetoInsert(bloc, context);
              },
          ) :
          null
        ].where(notNull).toList(),
    );
  }

  Widget _crearCabecera3(ViviendaModel vivienda){
    if(vivienda == null)
      return Container();
  
    final _screenSize = MediaQuery.of(context).size;
    final estiloTexto = TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16);
    final estiloInfo = TextStyle(color: Colors.white60 );
    final _ssbr = Radius.circular(10.0);
    
      return Container(
        height: _screenSize.height * 0.4,
        padding : EdgeInsets.only(left:20.0, right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: _ssbr, bottomRight: _ssbr),
          color: Colors.green,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20,),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text('No. Casa', style: estiloTexto)
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(vivienda.numero_casa, style: estiloInfo,)
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text('Direccion', style: estiloTexto)
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(vivienda.direccion, style: estiloInfo)
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text('Referencia', style: estiloTexto)
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(vivienda.referencia, style: estiloInfo)
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text('Tipo Pared', style: estiloTexto)
                  ),
                  Expanded(
                    child: Text('Tipo Piso', style: estiloTexto)
                  )
                ],
              ),
              Row(
                children: <Widget>[
                 Expanded(
                    child: Text(vivienda.tipos_parede, style: estiloInfo)
                  ),
                  Expanded(
                    child: Text(vivienda.tipos_piso, style: estiloInfo)
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text('Tipo Techo', style: estiloTexto)
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                 Expanded(
                    child: Text(vivienda.tipos_techo, style: estiloInfo)
                  )
                ],
              ),
            ],
          ),
        ),
      );
  }

  Widget _builCarita(PersonaModel persona){
    if(persona.cantProcedimiento != null && persona.cantProcedimiento > 0 ){
     return Icon(Icons.insert_emoticon, color: Colors.green,) ;
    }else{ 
       return Container();
    }
  }

  Widget _personaTarjeta(PersonaModel persona, context, bool pintar){
    return Container(
        //elevation: 1,
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: pintar ?  Color.fromRGBO(0, 204, 102, 0.1): Colors.white ,
        child: //Column(
          //children: <Widget>[
            ListTile(
              title: Text(persona.documento, style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),),
              subtitle: Text(persona.nombre + ' ' +persona.apellido),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _builCarita(persona),
                  GestureDetector(
                    child:Icon(Icons.add_box, color: Colors.green),
                    onTap: (){
                      bloc.changeProcedimiento(null);
                      Navigator.pushNamed(context, 'busqueda', arguments: persona.paciente_id);
                    },),
                ],
              ),
            )
          //],
        //),
      );
  }

  obtenerUbicacion() async{

    
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

  crearObjetoInsert(VisitaBloc bloc, context) async{
    InsertVisita sendData = new InsertVisita();
    await obtenerUbicacion();
    sendData.lat = latitud;
    sendData.lon = longitud;
    sendData.viviendaId = datosVivienda.vivienda.id;
    sendData.detallesVisitas = await bloc.obtenerDetallesVisita();
    final visitaProvider = new VisitaProvider();
    String mensaje = await visitaProvider.crearVisita(sendData);
    if(mensaje == 'ok'){
      showMessageSuccess(context, 'Al presionar ok lo llevará a la pantalla de menú');
    }else{
      mostrarAlerta(context, mensaje);
    }
    
  }
  

  void showMessageSuccess(BuildContext context, String mensaje ) {
    AppAlertDialog.success(
      context: context,
      tittle: 'Tesãira', 
      desc: mensaje, 
      btnOkOnPress: () => Navigator.pushReplacementNamed(context, 'botones')
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

  Widget _crearFamiliaresListView(List<PersonaModel> actores, context, docBuscado) {
    docBuscado = _prefs.documentoBuscado;
    
    List<Widget> personas = [];
    actores.forEach( (opt){
      dynamic widgetTemp = _personaTarjeta(opt, context, docBuscado == opt.documento);
      personas.add(widgetTemp);
      personas.add(Divider(height: 1, color: Colors.green,));
    });

    return Container(
               color: Colors.white,
               height: MediaQuery.of(context).size.height * 0.47,
               child: ListView(      
               children : personas,
          )
    );
  }
}