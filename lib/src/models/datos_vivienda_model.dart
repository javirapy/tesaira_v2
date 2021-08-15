import 'dart:convert';

DatosViviendaModel datosViviendaModelFromJson(String str) => DatosViviendaModel.fromJson(json.decode(str));

String productoModelToJson(DatosViviendaModel data) => json.encode(data.toJson());

class DatosViviendaModel {
    ViviendaModel vivienda;
    List<PersonaModel> personas;
    //variables pivot
    String documentoBuscado;
    String fromView;

    DatosViviendaModel({
        this.vivienda,
        this.personas
    });

    DatosViviendaModel.fromDB({
        this.vivienda,
        this.personas,
        this.documentoBuscado
    });

    
    factory DatosViviendaModel.fromJson(Map<String, dynamic> json) {
      var list = json['personas'] as List;
      List<PersonaModel> personaList = list.map((i) => PersonaModel.fromJson(i)).toList();

      return new DatosViviendaModel(
        vivienda  : ViviendaModel.fromJson(json['vivienda']),
        personas  : personaList
      );
    }

    factory DatosViviendaModel.fromJsonDB(Map<String, dynamic> json) {
      var list = json['personas'] as List;
      List<PersonaModel> personaList = list.map((i) => PersonaModel.fromJson(i)).toList();

      return new DatosViviendaModel.fromDB(
        vivienda         : ViviendaModel.fromJson(json['vivienda']),
        personas         : personaList,
        documentoBuscado : json['documento_buscado']
      );
    }

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['documento_buscado'] = this.documentoBuscado;

      if (this.personas != null) {
        data['personas'] = this.personas.map((v) => v.toJson()).toList();
      }
      
      if (this.vivienda != null) {
        data['vivienda'] = this.vivienda.toJson();
      }
      return data;
  }
    
    
}

class PersonaModel {
  String nombre;
  String apellido;
  String documento;
  int paciente_id;
  int cantProcedimiento;

  PersonaModel({
    this.nombre,
    this.apellido,
    this.documento,
    this.paciente_id,
    this.cantProcedimiento
  });

  factory PersonaModel.fromJson(Map<String, dynamic> json) => new PersonaModel(
      nombre      : json['nombre'],
      apellido    : json['apellido'],
      documento   : json['documento'],
      paciente_id : json['paciente_id'],
      cantProcedimiento   : json['cantProcedimiento']
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nombre'] = this.nombre;
    data['apellido'] = this.apellido;
    data['documento'] = this.documento;
    data['paciente_id'] = this.paciente_id;
    return data;
  }
}

//MOdelo de la Vivienda
class ViviendaModel{
  int id;
  String direccion;
  String numero_casa;
  String referencia;
  String tipos_parede;
  String tipos_piso;
  String tipos_techo;

  ViviendaModel({
    this.id,
    this.direccion,
    this.numero_casa,
    this.referencia,
    this.tipos_parede,
    this.tipos_piso,
    this.tipos_techo
  });

  factory ViviendaModel.fromJson(Map<String, dynamic> json) => new ViviendaModel(
        direccion     : json['direccion'],
        id            : json['id'],
        numero_casa   : json['numero_casa'],
        referencia    : json['referencia'],
        tipos_parede  : json['tipos_parede'],
        tipos_piso    : json['tipos_piso'],
        tipos_techo   : json['tipos_techo']
    );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['direccion'] = this.direccion;
    data['numero_casa'] = this.numero_casa;
    data['referencia'] = this.referencia;
    data['tipos_parede'] = this.tipos_parede;
    data['tipos_piso'] = this.tipos_piso;
    data['tipos_techo'] = this.tipos_techo;
    return data;
  }
}

class OpcionesModel{
    int id;
    String descripcion;

    OpcionesModel(this.id, this.descripcion);
  }