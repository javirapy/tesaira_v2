import 'dart:async';
import 'package:formvalidation/src/bloc/validators.dart';
import 'package:formvalidation/src/models/datos_censo.dart';
import 'package:formvalidation/src/models/datos_vivienda_model.dart';
import 'package:formvalidation/src/models/insert_visita_model.dart';
import 'package:formvalidation/src/providers/db_provider.dart';
import 'package:formvalidation/src/providers/visita_provider.dart';
import 'package:formvalidation/src/utils/number.dart';
import 'package:rxdart/rxdart.dart';

class VisitaBloc with Validators {

  final _cedulaController    = BehaviorSubject<String>();
  final _listProcedimientoController    = BehaviorSubject<List<Map<String, dynamic>>>();
    final _listPersonasController    = BehaviorSubject<List<Map<String, dynamic>>>();

  final _procedimientoController    = BehaviorSubject<Map<String, dynamic>>();
  final _detalleVisitaController    = BehaviorSubject<DetallesVisitas>();
  final _insertCensoController     = BehaviorSubject<DatosCensoInsert>();
  VisitaProvider _visitaProvider = VisitaProvider();
  final _progressController = BehaviorSubject<Numero>();
  final _personasController = BehaviorSubject<List<PersonaModel>>();

  
  // Insertar valores al Stream
  Function(String) get changeCedula    => _cedulaController.sink.add;
  Function(Map<String,dynamic>) get changeProcedimiento => _procedimientoController.sink.add;
  Function(DetallesVisitas) get changeDetalleVisita => _detalleVisitaController.sink.add;
  Function(DatosCensoInsert) get changeInsertCenso => _insertCensoController.sink.add;
  Function(Numero) get changeProgress => _progressController.sink.add;
  Function(List<PersonaModel>) get changePersonas => _personasController.sink.add;

  void buscarProcedimiento( String textoProcedimiento ) async {
    if(textoProcedimiento != null){
      List<Map<String, dynamic>> procedimientos = await _visitaProvider.buscarProcedimiento(textoProcedimiento);
    _listProcedimientoController.sink.add( procedimientos );

    }
  }

  void buscarPersona( String textoPersona ) async {
    if(textoPersona != null){
      List<Map<String, dynamic>> personas = await _visitaProvider.buscarPersonas(textoPersona);
    _listPersonasController.sink.add( personas );

    }
  }

  // Recuperar los datos del Stream
  Stream<String> get cedulaStream    => _cedulaController.stream.transform( validarCedula );
  Stream<List<Map<String, dynamic>>> get listProcedimientoStream => _listProcedimientoController.stream;
   Stream<List<Map<String, dynamic>>> get listPersonasStream => _listPersonasController.stream;
  Stream<Map<String, dynamic>> get procedimientoStream => _procedimientoController.stream;
  Stream<DetallesVisitas> get detalleVisitaStream => _detalleVisitaController.stream;
  Stream<DatosCensoInsert> get insertCensoStream => _insertCensoController.stream;
  Stream<Numero> get progressStream => _progressController.stream;
  Stream<List<PersonaModel>> get personasStream => _personasController.stream;
  
  // Obtener el último valor ingresa| a los streams
  String get cedula    => _cedulaController.value;
  Map<String, dynamic> get procedimiento => _procedimientoController.value;
  DetallesVisitas get detalleVisita => _detalleVisitaController.value;
  DatosCensoInsert get insertCenso => _insertCensoController.value;
  Numero get progress => _progressController.value;
  List<PersonaModel> get personas => _personasController.value;

  dispose() {
    _cedulaController?.close();
    _listProcedimientoController?.close();
    _listPersonasController?.close();
    _procedimientoController?.close();
    _detalleVisitaController?.close();
    _insertCensoController?.close();
    _progressController?.close();
    _personasController?.close();
  }

  //BD
  //Procedimientos
  agregarProcedimiento( Actividades actividad, idPaciente ) async{
    await DBProvider.db.insertProcedimiento(actividad, idPaciente);
    await obtenerProcedimientos(idPaciente);
  }

  eliminarProcedimiento( Actividades actividad, int idPaciente ) async{
    await DBProvider.db.deleteProcedimiento(actividad, idPaciente);
    await obtenerProcedimientos(idPaciente);
  }

  obtenerProcedimientos(int pacienteId) async{
    _detalleVisitaController.sink.add(await DBProvider.db.getDetallePaciente(pacienteId)) ;
  }

  eliminarTodo() async{
    await DBProvider.db.deleteAll();
  }

  //DatosVivienda
   agregarDatosVivienda( DatosViviendaModel vivienda ) async{
     await DBProvider.db.insertDatosVivienda(vivienda);
   }

   Future<DatosViviendaModel> obtenerDatosVivienda() async {
    return await DBProvider.db.getDatosViviendaSQL();
  }

  obtenerDetallesVisita() async {
    return await DBProvider.db.getListDetallePaciente();
  }

  /*Future<DatosCensoModel> getDatosCenso() async {
    print('llega la peticion al bloc');
    return await _visitaProvider.getDatosCenso();
    //_listProcedimientoController.sink.add( procedimientos );
    
  }*/



  ///PARA SINCRONIZAR
  
   agregarActividadVisitas( Actividades actividad, idPaciente, idVivienda ) async{
    await DBProvider.db.insertActividadesVisitas(actividad, idPaciente, idVivienda);
   // await obtenerProcedimientos(idPaciente);
  }

  obtenerActividadVisitas( idPaciente ) async{
   return await DBProvider.db.getActividadesVisitas(idPaciente);
   // await obtenerProcedimientos(idPaciente);
  }

     insertVisitasLocal( InsertVisita visita ) async{
    await DBProvider.db.insertVisitasLocal(visita);
   // await obtenerProcedimientos(idPaciente);
  }


       getDatosVisitasLocal( id ) async{
    return await DBProvider.db.getDatosVisitasLocal(id);
   // await obtenerProcedimientos(idPaciente);
  }

    getListDatosVisitasLocal( sincornizado ) async{
    return await DBProvider.db.getListDatosVisitasLocal(sincornizado);
   // await obtenerProcedimientos(idPaciente);
  }
  
   updateSincronizado( id ) async{
    return await DBProvider.db.updateSincronizado(id);
   // await obtenerProcedimientos(idPaciente);
  }
  
  
} 