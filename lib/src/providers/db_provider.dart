import 'dart:io';

import 'package:formvalidation/src/models/datos_vivienda_model.dart';
import 'package:formvalidation/src/models/insert_visita_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';


class DBProvider {

  static Database _database; 
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {

    if ( _database != null ) return _database;

    _database = await initDB();
    return _database;
  }


  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join( documentsDirectory.path, 'VisitaDB.db' );
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: ( Database db, int version ) async {
        await db.execute(
          'CREATE TABLE Procedimientos ('
          ' procedimiento_id INTEGER,'
          ' comentario TEXT,'
          ' valor TEXT,'
          ' paciente_id INTEGER,' 
          ' tipo_actividad INTEGER,'
          ' nombre TEXT'
          ')'
        );
        await db.execute(
          'CREATE TABLE Vivienda ('
          ' id INTEGER  PRIMARY KEY,'
          ' direccion TEXT,'
          ' numero_casa TEXT,'
          ' referencia TEXT,' 
          ' tipos_piso TEXT,'
          ' tipos_parede TEXT,'
          ' tipos_techo TEXT'
          ')'
        );
        await db.execute(
          'CREATE TABLE Personas ('
          ' paciente_id INTEGER PRIMARY KEY,'
          ' nombre TEXT,'
          ' apellido TEXT,'
          ' documento TEXT'
          ')'
        );
      }
    );
  }

  // CREAR Registros
  insertProcedimiento( Actividades actividad, int idPaciente ) async {
    final db  = await database;
    var res;
    try{
      res = await db.rawInsert(
        "INSERT Into Procedimientos (procedimiento_id, comentario, valor, paciente_id, tipo_actividad, nombre) "
        "VALUES ( ${ actividad.procedimientoId }, '${ actividad.comentario }', '${ actividad.valor }', '$idPaciente', '${ actividad.tipoActividad }' ,'${ actividad.nombreProcedimiento}' )"
      );
    }catch(e){
      return 0;
    }
    return res;
  }

  Future<DetallesVisitas> getDetallePaciente(int pacienteId) async {
    DetallesVisitas detalleVisita = new DetallesVisitas();
    detalleVisita.pacienteId = pacienteId;
    detalleVisita.actividades = new List();

    final db  = await database;
    List<Map> maps = await db.query('Procedimientos',
        columns: ['procedimiento_id', 'comentario', 'valor', 'tipo_actividad', 'nombre'],
        where: 'paciente_id = ?',
        whereArgs: [pacienteId]);

    if (maps.length > 0) {
      for (var item in maps) {
        detalleVisita.actividades.add(Actividades.fromJson(item));
      }
    }else{
      return null;
    }

    return detalleVisita;
  }

  //retorna todos los registros encontrados en la base de datos
  Future<List<DetallesVisitas>> getListDetallePaciente() async {
    final db  = await database;
    List<Map> pacientes = await db.query('Procedimientos',
      columns: ["paciente_id"],
      distinct: true);    
    
    if (pacientes.length == 0) {
      return null;
    }
    List<DetallesVisitas> detalleVisita = new List(pacientes.length);
    List<int> listPacientes = new List(pacientes.length);

    pacientes.asMap().forEach( (index, pac) {
    listPacientes[index] = pac['paciente_id'];
    });

    for (int index = 0 ; index < listPacientes.length; index++) {
        detalleVisita[index] = new DetallesVisitas();
      detalleVisita[index].actividades = [];
      detalleVisita[index].pacienteId = listPacientes[index];
      List<Map> maps = await db.query('Procedimientos',
        columns: ['procedimiento_id', 'comentario', 'valor', 'tipo_actividad'],
        where: 'paciente_id = ?',
        whereArgs: [listPacientes[index]]);
      if (maps.length > 0) {
        for (var item in maps) {
          detalleVisita[index].actividades.add(Actividades.fromJson(item));

        }
      }  
    }

    return detalleVisita;
  }

  // Eliminar registros
  Future<int> deleteProcedimiento( Actividades actividad, int pacienteId ) async {

    final db  = await database;
    if(actividad != null){
      final res = await db.delete('Procedimientos', 
          where: 'paciente_id = ? and procedimiento_id = ?',
          whereArgs: [pacienteId, actividad.procedimientoId]);
      return res;
    }else{
      final res = await db.delete('Procedimientos', 
          where: 'paciente_id = ?',
          whereArgs: [pacienteId]);
      return res;
    }
  }
  

  Future<int> deleteAll() async {
    final db  = await database;
    final res = await db.rawDelete('DELETE FROM Procedimientos');
    return res;
  }

  insertDatosVivienda( DatosViviendaModel datosVivienda ) async {
    //await deleteAll();
    final db  = await database;
    var res;
    try{
      await db.rawDelete('DELETE FROM Vivienda');
      await db.rawDelete('DELETE FROM Personas');
      res = await db.insert('Vivienda', datosVivienda.vivienda.toJson());
    }catch(e){ 
      return 0;
    }

    for (var item in datosVivienda.personas) {
      try{
        res = await db.insert('Personas', item.toJson());
      }catch(e){
        return 0;
      }  
    }
    print('Se pudo insertar todo sin problemas');
    return res;
  }  

  Future<DatosViviendaModel> getDatosViviendaSQL() async {
    DatosViviendaModel resul = new DatosViviendaModel();
    try{
      final db  = await database;
      var resVi = await db.query('Vivienda');
      resul.vivienda = ViviendaModel.fromJson(resVi.first);

      var resPe = await db.rawQuery('''SELECT count(pr.paciente_id) cantProcedimiento, 
                                    p.nombre,
                                    p.apellido,
                                    p.documento,
                                    p.paciente_id
                                    FROM personas p
                                    left join procedimientos pr on pr.paciente_id = p.paciente_id
                                    group by p.nombre,
                                    p.apellido,
                                    p.documento,
                                    p.paciente_id
                                    ''');
      resul.personas = [];
      resul.personas = resPe.map( (c) => PersonaModel.fromJson(c) ).toList();
    }catch(e){
      print('Ocurrio un error al leer datos vivienda $e');
    }
    print('Se termino de recuperar datos de datosvivienda');
    return resul;
    
  }

}

