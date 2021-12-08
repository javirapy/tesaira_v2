import 'dart:convert';

import 'package:formvalidation/src/models/datos_censo.dart';
import 'package:formvalidation/src/models/datos_visita.dart';
import 'package:formvalidation/src/models/datos_vivienda_model.dart';
import 'package:formvalidation/src/models/insert_visita_model.dart';
import 'package:formvalidation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;

class VisitaProvider {

  final _prefs = new PreferenciasUsuario();

  Future<DatosViviendaModel> buscarPaciente( String cedula) async {
    Map<String, String> headers = {"Authorization": "Bearer ${_prefs.token}", "Content-Type": "application/json"};
    final resp = await http.get(
      'https://www.tesairauc.com/api/datosvivienda/${cedula}',
      headers: headers
    );
    
    Map<String, dynamic> decodedData;
    DatosViviendaModel decodedResp;
    try {
      decodedData = json.decode(resp.body);
      decodedResp = DatosViviendaModel.fromJson( decodedData );
    } catch (e) {
      print('No existe hina el documento buscado');
    }
    
    if ( decodedResp != null ) {
      return decodedResp;
    } else {
      return null;
    }

  }

  //a medida que escribis el te sugiere algo
  Future<List<Map<String, dynamic>>> buscarProcedimiento( String textoProcedimiento) async {
    Map<String, String> headers = {"Authorization": "Bearer ${_prefs.token}", "Content-Type": "application/json"};
    final resp = await http.get(
      'https://www.tesairauc.com/api/getprocedimientos/${textoProcedimiento}',
      headers: headers
    );
    var lista = json.decode(resp.body);

    final List<Map<String, dynamic>> decodedData = new List<Map<String, dynamic>>.from(lista);
    print(decodedData);
    return decodedData;
    
  }

   Future<List<Map<String, dynamic>>> buscarPersonas( String textoPersona) async {
    Map<String, String> headers = {"Authorization": "Bearer ${_prefs.token}", "Content-Type": "application/json"};
    final resp = await http.get(
      'https://www.tesairauc.com/api/buscadorPersonas/${textoPersona}',
      headers: headers
    );

    List<Map<String, dynamic>> decodedData = [];
    Map<String, dynamic> dataraw;
     dataraw = json.decode(resp.body);
 print(dataraw);
    // final List<Map<String, dynamic>> decodedData = new List<Map<String, dynamic>>.from(lista[0].persona);
    // print(decodedData);
    // return decodedData;

     try{
      dataraw = json.decode(resp.body);
      
      if(dataraw != null && dataraw.containsKey('persona') ){
        for(var item in dataraw['persona']){
          decodedData.add(item);
        }
      }
      
    }catch(e){ 
      print('Error al convertir datos persona $e');
    }
        return decodedData;   

  }

  Future<String> crearVisita( InsertVisita visitaData ) async {
    //InsertData data = new InsertData();
    //data.data = visitaData;
    print('Se va a llamar para crear visita ${visitaData.detallesVisitas}');   
    Map<String, String> headers = {"Authorization": "Bearer ${_prefs.token}", "Content-Type": "application/json"};
    final bodydata = jsonEncode(visitaData); //visitaData.toJson();
    print('EL valor de bodydata $bodydata');
    final resp = await http.post(
      'https://www.tesairauc.com/api/guardarvisita.json',
      headers: headers,
      body : bodydata
    );

    print('el dato del body ${resp.body}');

    final decodedData = json.decode(resp.body);

    print( decodedData );
    if( !(decodedData['response'] == 'ok') ){
      return 'Ha ocurrido un error ';
    }

    return 'ok';
  }

  Future<DatosCensoModel> getDatosCenso() async {
    Map<String, String> headers = {"Authorization": "Bearer ${_prefs.token}"};
    print('se va a traer datos censo');
    final resp = await http.get(
      'https://www.tesairauc.com/api/datoscenso.json',
      headers: headers
    );
    print(resp);
    DatosCensoModel decodedResp ;

    try{
      final Map<String, dynamic> decodedData = json.decode(resp.body);
      decodedResp = DatosCensoModel.fromJson( decodedData );
      print("Llama a getDatosCenso() -> que usa el servicio https://www.tesairauc.com/api/datoscenso.json, con resultado: ${decodedResp.microterritorios[1].descripcion}");

    }catch(e){ 
      print('Error al convertir datos censo $e');
    }
    
    return decodedResp;   
  }

  Future<String> crearCenso( Map<String, dynamic> mapInsert) async {
    print('Se hara peticion crear censo ${mapInsert['microterritorio_id']}');
    Map<String, String> headers = {"Authorization": "Bearer ${_prefs.token}", "Content-Type": "application/json"};
    final bodydata = jsonEncode(mapInsert); 
    
    print(bodydata);

    final resp = await http.post(
      'https://www.tesairauc.com/api/crearVivienda.json',
      headers: headers,
      body : bodydata
    );

    print('La respuesta del json ${resp.body}');

    final Map<String, dynamic> decodedData = json.decode(resp.body);
     

    //print( decodedData );
    if( !(decodedData.containsKey('vivienda_id')) ){
      return 'Ha ocurrido un error';
    }

    return decodedData['vivienda_id'].toString();
  }

  Future<String> crearPaciente( Map<String, dynamic> mapInsert) async {
    Map<String, String> headers = {"Authorization": "Bearer ${_prefs.token}", "Content-Type": "application/json"};
    final bodydata = jsonEncode(mapInsert); 
    
    print("Crear Paciente ${bodydata}" );

    final resp = await http.post(
      'https://www.tesairauc.com/api/crearPersona.json',
      headers: headers,
      body : bodydata
    );

    print('La respuesta del json ${resp.body}');

    final Map<String, dynamic> decodedData = json.decode(resp.body);
     

    //print( decodedData );
    if( !(decodedData['response'] == 'ok') ){
      return 'Ha ocurrido un error';
    }

    return 'ok';
  }

  Future<String> crearNotificacion( Map<String, dynamic> mapInsert) async {
    print('Se hara peticion crear censo ${mapInsert['microterritorio_id']}');
    Map<String, String> headers = {"Authorization": "Bearer ${_prefs.token}", "Content-Type": "application/json"};
    final bodydata = jsonEncode(mapInsert); 
    
    print(bodydata);

    final resp = await http.post(
      'https://www.tesairauc.com/api/crearSuceso.json',
      headers: headers,
      body : bodydata
    );

    print('La respuesta del json ${resp.body}');

    final Map<String, dynamic> decodedData = json.decode(resp.body);
     

    //print( decodedData );
    if( !(decodedData['response'] == 'ok') ){
      return 'Ha ocurrido un error';
    }

    return 'ok';
  }


  Future<List<Map<String, dynamic>>> getBuzSalida() async {
    List<Map<String, dynamic>> decodedData = [];
    List<Object> dataraw;

    Map<String, String> headers = {"Authorization": "Bearer ${_prefs.token}"};
    
    final resp = await http.get(
      'https://www.tesairauc.com/api/listaSucesos.json',
      headers: headers
    );
    print(resp);
    try{
      dataraw = json.decode(resp.body);
      
      for (var item in dataraw) {
        decodedData.add(item);
      }
      
    }catch(e){ 
      print('Error al convertir datos buz salida $e');
    }
    
    return decodedData;   
  }

  Future<List<Map<String, dynamic>>> getBuzEntrada() async {
    List<Map<String, dynamic>> decodedData = [];
    Map<String, dynamic> dataraw;

    Map<String, String> headers = {"Authorization": "Bearer ${_prefs.token}"};
    
    final resp = await http.get(
      'https://www.tesairauc.com/api/listanotificaciones',
      headers: headers
    );
    print(resp);
    try{
      dataraw = json.decode(resp.body);
      
      if(dataraw != null && dataraw.containsKey('response') ){
        for(var item in dataraw['response']){
          decodedData.add(item);
        }
      }
      
    }catch(e){ 
      print('Error al convertir datos censo $e');
    }
    
    return decodedData;   
  }

    Future<int> getContadorNotificacion() async {
    List<Map<String, dynamic>> decodedData = [];
    Map<String, dynamic> dataraw;

    Map<String, String> headers = {"Authorization": "Bearer ${_prefs.token}"};
    
    final resp = await http.get(
      'https://www.tesairauc.com/api/contadornotificaciones',
      headers: headers
    );
    print("notificaciones ${resp.body}");
    // try{
       dataraw = json.decode(resp.body);
    //   print("notificaciones 2 ${dataraw["response"]}");
      
    //    if(dataraw != null && dataraw.containsKey('response') ){
    //   //  return dataraw["response"];

    //   // }
      
    // }catch(e){ 
    //   print('Error al convertir contador notificaciones $e');
    // }
    
    return dataraw["response"];   
  }

  Future<Map<String, dynamic>> getDetalleSalida(dynamic id) async {
    List<Object> rawList;
    Map<String, dynamic> decodedData ;
    

    Map<String, String> headers = {"Authorization": "Bearer ${_prefs.token}"};
    
    final resp = await http.get(
      'https://www.tesairauc.com/api/versuceso/$id',
      headers: headers
    );
    print(resp);
    try{
      rawList = json.decode(resp.body);
      decodedData = rawList[0];
    }catch(e){ 
      print('Error al convertir datos json $e');
    }
    
    return decodedData;   
  }

  Future<Map<String, dynamic>> getDetalleEntrada(dynamic id) async {
    Map<String, dynamic> decodedData ;
    

    Map<String, String> headers = {"Authorization": "Bearer ${_prefs.token}"};
    
    final resp = await http.get(
      'https://www.tesairauc.com/api/vernotificacion/$id',
      headers: headers
    );
    print(resp);
    try{
      decodedData = json.decode(resp.body);
    }catch(e){ 
      print('Error al convertir datos json $e');
    }
    
    return decodedData;   
  }

  Future<List<Map<String, dynamic>>> getProductividad() async {
    List<Map<String, dynamic>> decodedData = [];
    List<Object> dataraw;

    Map<String, String> headers = {"Authorization": "Bearer ${_prefs.token}"};
    
    final resp = await http.get(
      'https://www.tesairauc.com/api/getdatosproductividad',
      headers: headers
    );
    print(resp);
    try{
      dataraw = json.decode(resp.body);
      
      if(dataraw != null  ){
        for(var item in dataraw){
          decodedData.add(item);
        }
      }
      
    }catch(e){ 
      print('Error al convertir datos censo $e');
    }
    
    return decodedData;   
  }


  Future<List<Map<String, dynamic>>>  getProductividad1() async {
 
   List<Map<String, dynamic>> decodedData = [];
    List<Object> dataraw;


    Map<String, String> headers = {"Authorization": "Bearer ${_prefs.token}"};
    
    final resp = await http.get(
      'https://www.tesairauc.com/api/getdatosproductividad',
      headers: headers
    );
    
  print(resp);
    try{
      dataraw = json.decode(resp.body);
      
      for (var item in dataraw) {
        decodedData.add(item);
      }
      
    }catch(e){ 
      print('Error al convertir datos buz salida $e');
    }

     print(decodedData);
    
    return decodedData;   
  }

  Future<Persona2Model> buscarPaciente2( String cedula) async {
    Map<String, String> headers = {"Authorization": "Bearer ${_prefs.token}", "Content-Type": "application/json"};
    final resp = await http.get(
      'https://www.tesairauc.com/api/personas/${cedula}',
      headers: headers
    );
    
    Map<String, dynamic> decodedData;
    Persona2Model decodedResp;
    try {
      decodedData = json.decode(resp.body);
    //  print(decodedData);
    print("decodedData ${decodedData}" );
      decodedResp = Persona2Model.fromJson( decodedData );
    } catch (e) {
      print('No existe hina el documento buscado2');
      //print(e);
    }
    
    if ( decodedResp != null ) {
       return decodedResp;
      print("No es null ${decodedResp}");
    } else {
      return null;
    }

  }


  Future<Map<String, dynamic>> buscarPaciente12( String cedula) async {
    Map<String, String> headers = {"Authorization": "Bearer ${_prefs.token}", "Content-Type": "application/json"};
    final resp = await http.get(
      'https://www.tesairauc.com/api/personas/${cedula}',
      headers: headers
    );

    Map<String, dynamic> decodedResp = json.decode( resp.body );

    print(decodedResp.length);

    //return { 'ok': true, 'persona': decodedResp['persona'] };

     if ( decodedResp.length>0 ) {

      return { 'ok': true, 'persona': decodedResp['persona'] };
    } else {
      return { 'ok': false};
    }

  }



  Future<List<Map<String, dynamic>>> obtenerVisitas( InsertVisita data) async {

 List<Map<String, dynamic>> decodedData = [];
    List<Object> dataraw;

 final authData = {
       'fini'    : data.fini,
      'ffin' : data.ffin
    };
    print(authData.toString());
    Map<String, String> headers = {"Authorization": "Bearer ${_prefs.token}", "Content-Type": "application/json"};

    final resp = await http.post(
//      'http://192.168.0.100:9080/api/login.json',
        'https://www.tesairauc.com/api/listarVisitas',
      body: json.encode( authData ),
      headers: headers
    );

    print(resp.toString());
    try{
      dataraw = json.decode(resp.body);
      
      for (var item in dataraw) {
        decodedData.add(item);
      }
      
    }catch(e){ 
      print('Error al convertir datos obtener visitas lista $e');
    }
    
    return decodedData;    
  }


    Future<DatosVisita> detalleVisita( int idVisita) async {
    Map<String, String> headers = {"Authorization": "Bearer ${_prefs.token}", "Content-Type": "application/json"};
    final resp = await http.get(
      'https://www.tesairauc.com/api/detallevisita/${idVisita}',
      headers: headers
    );
          print(resp.body[0].toString());

    List<dynamic> decodedData;
    DatosVisita decodedResp;
    try {
      decodedData = json.decode(resp.body);
      decodedResp = DatosVisita.fromJson(decodedData[0]);
    } catch (e) {
      print('No existe hina el documento buscado');
    }
    
    if ( decodedResp != null ) {
      return decodedResp;
    } else {
      return null;
    }

  }


}
