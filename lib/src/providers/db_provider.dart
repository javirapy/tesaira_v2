import 'dart:ffi';
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
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'VisitaDB13.db');
    print('path bd ${path}');
    return await openDatabase(path, version: 3, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Procedimientos ('
          ' procedimiento_id INTEGER,'
          ' comentario TEXT,'
          ' valor TEXT,'
          ' paciente_id INTEGER,'
          ' tipo_actividad INTEGER,'
          ' nombre TEXT'
          ')');
      await db.execute('CREATE TABLE Vivienda ('
          ' id INTEGER  PRIMARY KEY,'
          ' direccion TEXT,'
          ' numero_casa TEXT,'
          ' referencia TEXT,'
          ' tipos_piso TEXT,'
          ' tipos_parede TEXT,'
          ' tipos_techo TEXT ,'
          ' lat TEXT,'
          ' lon TEXT,'
          ' telefono_vivienda TEXT'
          ')');
      await db.execute('CREATE TABLE Personas ('
          ' paciente_id INTEGER PRIMARY KEY,'
          ' nombre TEXT,'
          ' apellido TEXT,'
          ' documento TEXT'
          ')');

      await db.execute('CREATE TABLE ViviendaVisitas ('
          ' id INTEGER ,'
          ' vivienda_id INTEGER,'
          ' lat DOUBLE,'
          ' lon DOUBLE,'
          ' sincronizado TEXT,'
          ' fecha_visita TEXT,'
          ' documento_buscado TEXT,'
          ' nombre TEXT,'
          ' apellido TEXT'
          ')');

      await db.execute('CREATE TABLE PacientesVisitas ('
          ' id INTEGER ,'
          ' paciente_id INTEGER,'
          ' lat DOUBLE,'
          ' lon DOUBLE'
          ')');

      await db.execute('CREATE TABLE ActividadesVisitas ('
          ' id INTEGER,'
          ' paciente_id INTEGER,'
          ' procedimiento_id INTEGER,'
          ' comentario TEXT,'
          ' valor TEXT,'
          ' tipo_actividad INTEGER,'
          ' nombre TEXT'
          ')');
    });
  }

  // CREAR Registros
  insertProcedimiento(Actividades actividad, int idPaciente) async {
    final db = await database;
    var res;
    try {
      res = await db.rawInsert(
          "INSERT Into Procedimientos (procedimiento_id, comentario, valor, paciente_id, tipo_actividad, nombre) "
          "VALUES ( ${actividad.procedimientoId}, '${actividad.comentario}', '${actividad.valor}', '$idPaciente', '${actividad.tipoActividad}' ,'${actividad.nombreProcedimiento}' )");
    } catch (e) {
      return 0;
    }
    return res;
  }

  Future<DetallesVisitas> getDetallePaciente(int pacienteId) async {
    DetallesVisitas detalleVisita = new DetallesVisitas();
    detalleVisita.pacienteId = pacienteId;
    detalleVisita.actividades = new List();

    final db = await database;
    List<Map> maps = await db.query('Procedimientos',
        columns: [
          'procedimiento_id',
          'comentario',
          'valor',
          'tipo_actividad',
          'nombre'
        ],
        where: 'paciente_id = ?',
        whereArgs: [pacienteId]);

    if (maps.length > 0) {
      for (var item in maps) {
        detalleVisita.actividades.add(Actividades.fromJson(item));
      }
    } else {
      return null;
    }

    return detalleVisita;
  }

  //retorna todos los registros encontrados en la base de datos
  Future<List<DetallesVisitas>> getListDetallePaciente() async {
    final db = await database;
    List<Map> pacientes = await db.query('Procedimientos',
        columns: ["paciente_id"], distinct: true);

    if (pacientes.length == 0) {
      return null;
    }
    List<DetallesVisitas> detalleVisita = new List(pacientes.length);
    List<int> listPacientes = new List(pacientes.length);

    pacientes.asMap().forEach((index, pac) {
      listPacientes[index] = pac['paciente_id'];
    });

    for (int index = 0; index < listPacientes.length; index++) {
      detalleVisita[index] = new DetallesVisitas();
      detalleVisita[index].actividades = [];
      detalleVisita[index].pacienteId = listPacientes[index];
      List<Map> maps = await db.query('Procedimientos',
          columns: [
            'procedimiento_id',
            'comentario',
            'valor',
            'tipo_actividad'
          ],
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
  Future<int> deleteProcedimiento(Actividades actividad, int pacienteId) async {
    final db = await database;
    if (actividad != null) {
      final res = await db.delete('Procedimientos',
          where: 'paciente_id = ? and procedimiento_id = ?',
          whereArgs: [pacienteId, actividad.procedimientoId]);
      return res;
    } else {
      final res = await db.delete('Procedimientos',
          where: 'paciente_id = ?', whereArgs: [pacienteId]);
      return res;
    }
  }

  Future<int> deleteAll() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Procedimientos');
    return res;
  }

  insertDatosVivienda(DatosViviendaModel datosVivienda) async {
    //await deleteAll();
    final db = await database;
    var res;
    try {
      await db.rawDelete('DELETE FROM Vivienda');
      await db.rawDelete('DELETE FROM Personas');
      res = await db.insert('Vivienda', datosVivienda.vivienda.toJson());
    } catch (e) {
      return 0;
    }

    for (var item in datosVivienda.personas) {
      try {
        res = await db.insert('Personas', item.toJson());
      } catch (e) {
        return 0;
      }
    }
    print('Se pudo insertar todo sin problemas');
    return res;
  }

  Future<DatosViviendaModel> getDatosViviendaSQL() async {
    DatosViviendaModel resul = new DatosViviendaModel();
    try {
      final db = await database;
      var resVi = await db.query('Vivienda');
      resul.vivienda = ViviendaModel.fromJson(resVi.first);
      print('Viviendas get${resVi.toList()}');
      var resPe =
          await db.rawQuery('''SELECT count(pr.paciente_id) cantProcedimiento, 
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
      resul.personas = resPe.map((c) => PersonaModel.fromJson(c)).toList();
    } catch (e) {
      print('Ocurrio un error al leer datos vivienda $e');
    }
    print('Se termino de recuperar datos de datosvivienda');
    return resul;
  }

  //PARA SINCRONIZAR

//personas

  insertPacientessVisitas(
      int idVivienda, int idPaciente, Double lat, Double long) async {
    final db = await database;
    var res;
    try {
      res = await db.rawInsert(
          "INSERT Into PacienteVisitas (vivienda_id, paciente_id, lat, long) "
          "VALUES ('$idVivienda', '$idPaciente', '$lat', '$long' )");
    } catch (e) {
      return 0;
    }
    return res;
  }

  insertVisitasLocal(InsertVisita visita) async {
    final db = await database;

print('Insert visita ${visita.toJson()}');
    var cantidad = 0;
    var res;
    try {
      List<Map> visitasCant =
          await db.query('ViviendaVisitas', columns: ["id"]);
      // distinct: true);

      if (visitasCant.length == 0) {
        cantidad = 1;
      } else {
        cantidad = visitasCant.length + 1;
      }

      // var resPe = await db.rawQuery('''SELECT count(pr.paciente_id) cantVisitas
      //                               FROM ViviendaVisitas
      //                               ''');
      res = await db.rawInsert(
          "INSERT Into ViviendaVisitas (id, vivienda_id, lat, lon, sincronizado, fecha_visita, documento_buscado, nombre, apellido)"
          "VALUES ('$cantidad',${visita.viviendaId}, ${visita.lat}, '${visita.lon}', 'N', '${visita.fechaVisita}', '${visita.documentoBuscado}', '${visita.nombre}', '${visita.apellido}' )");

      List<DetallesVisitas> detalleVisita =
          new List(visita.detallesVisitas.length);
      for (int index = 0; index < visita.detallesVisitas.length; index++) {


            res = await db.rawInsert(
              "INSERT Into PacientesVisitas (id,paciente_id) "
              "VALUES ('$cantidad', ${visita.detallesVisitas[index].pacienteId})");
       
          
        for (int index1 = 0;
            index1 < visita.detallesVisitas[index].actividades.length;
            index1++) {
          res = await db.rawInsert(
              "INSERT Into ActividadesVisitas (id,paciente_id, procedimiento_id, comentario, valor, tipo_actividad, nombre) "
              "VALUES ('$cantidad', ${visita.detallesVisitas[index].pacienteId}, '${visita.detallesVisitas[index].actividades[index1].procedimientoId}','${visita.detallesVisitas[index].actividades[index1].comentario}', '${visita.detallesVisitas[index].actividades[index1].valor}' ,'${visita.detallesVisitas[index].actividades[index1].tipoActividad}' ,'${visita.detallesVisitas[index].actividades[index1].nombreProcedimiento}'  )");
        }
      }


//     insertVisitasLocal( InsertVisita visita ) async {
//     final db  = await database;
//     var res;
//     try{

// List<DetallesVisitas> detalleVisita = new List(visita.detallesVisitas.length);
//     for (int index = 0 ; index < visita.detallesVisitas.length; index++) {
//       detalleVisita[index] = new DetallesVisitas();
//       detalleVisita[index].actividades = [];
//       detalleVisita[index].pacienteId = visita.detallesVisitas[index].pacienteId;
//       List<Map> maps = await db.query('ActividadesVisitas',
//         columns: ['procedimiento_id', 'comentario', 'valor', 'tipo_actividad'],
//         where: 'paciente_id = ?',
//         whereArgs:  [detalleVisita[index].pacienteId]);
//       if (maps.length > 0) {
//         for (var item in maps) {
//           detalleVisita[index].actividades.add(Actividades.fromJson(item));

//         }
//       }
//     }

    

    } catch (e) {
      return 0;
    }

    print('iiiiiddddddd visitas ${res}');
    return res;
  }



  Future<InsertVisita> getDatosVisitasLocal( id ) async {
        InsertVisita resul = new InsertVisita();
        try {
          final db = await database;
          var resVi = await db.query('ViviendaVisitas',
          where: 'id = ?',whereArgs:  [id]);

          resul = InsertVisita.fromJson(resVi.first);

          List<Map> pacientes = await db.query('PacientesVisitas',
              columns: ['id', 'paciente_id'],
              where: 'id = ?', whereArgs: [id]);
              
          // distinct: true);

          if (pacientes.length == 0) {
            return null;
          }
          List<DetallesVisitas> detalleVisita = new List(pacientes.length);
          List<int> listPacientes = new List(pacientes.length);

          pacientes.asMap().forEach( (index, pac) {
            listPacientes[index] = pac['paciente_id'];
            });

         resul.detallesVisitas = detalleVisita;

     //      resul.detallesVisitas = [];
     // resul.personas = resPe.map((c) => PersonaModel.fromJson(c)).toList();

   // List<DetallesVisitas> detalleVisita = new List(visita.detallesVisitas.length);
    for (int index = 0 ; index < listPacientes.length; index++) {
      detalleVisita[index] = new DetallesVisitas();
      detalleVisita[index].actividades = [];
      detalleVisita[index].pacienteId = listPacientes[index];
      //resul.detallesVisitas[index].pacienteId=listPacientes[index];
     // resul.detallesVisitas[index]=new DetallesVisitas();
      resul.detallesVisitas[index].pacienteId=listPacientes[index];
      resul.detallesVisitas[index].id=id;
      List<Map> maps = await db.query('ActividadesVisitas',
        columns: ['id','procedimiento_id', 'comentario', 'valor', 'tipo_actividad'],
        where: 'paciente_id = ? and id = ?',
        whereArgs:  [detalleVisita[index].pacienteId,resul.id ]);
        
      if (maps.length > 0) {
       // for (var item in maps) {

         // print('mappppp ${maps.toList()}');
          for (int i = 0 ; i < maps.length; i++){
         // detalleVisita[index].actividades.add(Actividades.fromJson(maps[i]));
         // resul.detallesVisitas= detalleVisita[index];
         resul.detallesVisitas[index].actividades.add(Actividades.fromJson(maps[i]));
       //  print('maps[i] ${maps[i].toString()}');
       //  print('resul detalleVisita ${resul.toJson()}');

        }
      }
    }





          // for (int index = 0; index < listPacientes.length; index++) {
          //   detalleVisita[index] = new DetallesVisitas();
          //   detalleVisita[index].actividades = [];
          //   detalleVisita[index].pacienteId = listPacientes[index];
          //   List<Map> maps = await db.query('ActividadesVisitas',
          //       columns: [
          //         'procedimiento_id',
          //         'comentario',
          //         'valor',
          //         'tipo_actividad'
          //       ],
          //       where: 'paciente_id = ?',
          //       whereArgs: [listPacientes[index]]);
          //   if (maps.length > 0) {
          //     for (var item in maps) {
          //       detalleVisita[index]
          //           .actividades
          //           .add(Actividades.fromJson(item));
          //     }
          //   }
          // }


          

        } catch (e) {
          print('Ocurrio un error al leer datos vivienda $e');
        }
        print('Se termino de recuperar datos de datosvivienda');

        
       // print('resul visita ${resul.toJson()}');
        return resul;
      }





  Future<List<InsertVisita>> getListDatosVisitasLocal( sincronizado ) async {
        List<InsertVisita> resul1;
        try {
          final db = await database;
          var resVi = await db.query('ViviendaVisitas',
          where: 'sincronizado = ?',whereArgs:  [sincronizado]);
          
          if (resVi.length == 0) {
            return null;
          }
         resul1 = new List(resVi.length);
          List<int> listVisitas = new List(resVi.length);

    for (int index1 = 0 ; index1 < listVisitas.length; index1++) {
         
            resul1[index1] = InsertVisita.fromJson(resVi[index1]);


      
    }
       

        } catch (e) {
          print('Ocurrio un error al leer datos vivienda $e');
        }
        print('Se termino de recuperar datos de datosvivienda');

        
      //  print('resul visita ${resul.toJson()}');
        return resul1;
      }











  //actividades

  insertActividadesVisitas(
      Actividades actividad, int idPaciente, int idVivienda) async {
    final db = await database;
    var res;
    try {
      res = await db.rawInsert(
          "INSERT Into ActividadesVisitas (vivienda_id, procedimiento_id, comentario, valor, paciente_id, tipo_actividad, nombre) "
          "VALUES ('$idVivienda', ${actividad.procedimientoId}, '${actividad.comentario}', '${actividad.valor}', '$idPaciente', '${actividad.tipoActividad}' ,'${actividad.nombreProcedimiento}' )");
    } catch (e) {
      return 0;
    }
    return res;
  }

  //retorna todos los registros encontrados en la base de datos
  Future<List<DetallesVisitas>> getActividadesVisitas(int pacienteId) async {
    final db = await database;
    List<Map> pacientes = await db.query('ActividadesVisitas',
        columns: ["paciente_id"],
        where: 'paciente_id = ?',
        whereArgs: [pacienteId]);
    // distinct: true);

    if (pacientes.length == 0) {
      return null;
    }
    List<DetallesVisitas> detalleVisita = new List(pacientes.length);
    List<int> listPacientes = new List(pacientes.length);

    pacientes.asMap().forEach((index, pac) {
      listPacientes[index] = pac['paciente_id'];
    });

    for (int index = 0; index < listPacientes.length; index++) {
      detalleVisita[index] = new DetallesVisitas();
      detalleVisita[index].actividades = [];
      detalleVisita[index].pacienteId = listPacientes[index];
      List<Map> maps = await db.query('ActividadesVisitas',
          columns: [
            'procedimiento_id',
            'comentario',
            'valor',
            'tipo_actividad'
          ],
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


    updateSincronizado(id) async {
    final db = await database;
    var res;
    try {
      res =await db.rawUpdate('''
    UPDATE ViviendaVisitas 
    SET sincronizado = ?
    WHERE id = ?
    ''', 
    ['S', id]);
         
    } catch (e) {
      return 0;
    }
    return res;
  }
}
