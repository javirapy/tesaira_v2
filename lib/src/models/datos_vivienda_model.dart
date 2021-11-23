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
        this.documentoBuscado,
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
  String documentoBuscado;
  String fromView;

  PersonaModel({
    this.nombre,
    this.apellido,
    this.documento,
    this.paciente_id,
    this.cantProcedimiento,
    this.documentoBuscado

  });

  factory PersonaModel.fromJson(Map<String, dynamic> json) => new PersonaModel(
      nombre      : json['nombre'],
      apellido    : json['apellido'],
      documento   : json['documento'],
      paciente_id : json['paciente_id'],
      cantProcedimiento   : json['cantProcedimiento'],
      documentoBuscado : json['documento_buscado']

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
    String lat;
    String lon;
    String telefono_vivienda;

  ViviendaModel({
    this.id,
    this.direccion,
    this.numero_casa,
    this.referencia,
    this.tipos_parede,
    this.tipos_piso,
    this.tipos_techo,
        this.lat,
        this.lon,
        this.telefono_vivienda
    
  });

  factory ViviendaModel.fromJson(Map<String, dynamic> json) => new ViviendaModel(
        direccion     : json['direccion'],
        id            : json['id'],
        numero_casa   : json['numero_casa'],
        referencia    : json['referencia'],
        tipos_parede  : json['tipos_parede'],
        tipos_piso    : json['tipos_piso'],
        tipos_techo   : json['tipos_techo'],
        lat   : json['lat'],
        lon   : json['lon'],
        telefono_vivienda   : json['telefono_vivienda']
        
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
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['telefono_vivienda'] = this.telefono_vivienda;
    return data;
  }
}

class OpcionesModel{
    int id;
    String descripcion;

    OpcionesModel(this.id, this.descripcion);
  }



// To parse this JSON data, do
//
//     final persona2Model = persona2ModelFromJson(jsonString);



Persona2Model persona2ModelFromJson(String str) => Persona2Model.fromJson(json.decode(str));

String persona2ModelToJson(Persona2Model data) => json.encode(data.toJson());

class Persona2Model {
    Persona2Model({
        this.persona,
        
    });

    List<Persona> persona;
    //variables pivot
    String documentoBuscado;
    String fromView;
    String viviendaId;

    factory Persona2Model.fromJson(Map<String, dynamic> json) => Persona2Model(
        persona: List<Persona>.from(json["persona"].map((x) => Persona.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "persona": List<dynamic>.from(persona.map((x) => x.toJson())),
    };
}

class Persona {
    Persona({
        this.id,
        this.nombre,
        this.apellido,
        this.fechaNacimiento,
        this.sexo,
        this.numeroDocumento,
        this.tiposDocumentoId,
        this.paisOrigenDocumentoId,
        this.nacionalidadeId,
        this.estadosCivileId,
        this.relacionesPersonaId,
        this.etniaId,
        this.nivelesEducativoId,
        this.ocupacioneId,
        this.situacionesLaboraleId,
        this.estado,
        this.deleted,
        this.fallecido,
        this.identidad,
    });

    int id;
    String nombre;
    String apellido;
    DateTime fechaNacimiento;
    String sexo;
    String numeroDocumento;
    int tiposDocumentoId;
    int paisOrigenDocumentoId;
    int nacionalidadeId;
    int estadosCivileId;
    int relacionesPersonaId;
    int etniaId;
    int nivelesEducativoId;
    int ocupacioneId;
    int situacionesLaboraleId;
    int estado;
    int deleted;
    bool fallecido;
    String identidad;


    factory Persona.fromJson(Map<String, dynamic> json) => Persona(
        id: json["id"],
        nombre: json["nombre"],
        apellido: json["apellido"],
        fechaNacimiento: DateTime.parse(json["fecha_nacimiento"]),
        sexo: json["sexo"],
        numeroDocumento: json["numero_documento"],
        tiposDocumentoId: json["tipos_documento_id"],
        paisOrigenDocumentoId: json["pais_origen_documento_id"],
        nacionalidadeId: json["nacionalidade_id"],
        estadosCivileId: json["estados_civile_id"],
        relacionesPersonaId: json["relaciones_persona_id"],
        etniaId: json["etnia_id"],
        nivelesEducativoId: json["niveles_educativo_id"],
        ocupacioneId: json["ocupacione_id"],
        situacionesLaboraleId: json["situaciones_laborale_id"],
        estado: json["estado"],
        deleted: json["deleted"],
        fallecido: json["fallecido"],
        identidad: json["identidad"],
        
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "apellido": apellido,
        "fecha_nacimiento": fechaNacimiento.toIso8601String(),
        "sexo": sexo,
        "numero_documento": numeroDocumento,
        "tipos_documento_id": tiposDocumentoId,
        "pais_origen_documento_id": paisOrigenDocumentoId,
        "nacionalidade_id": nacionalidadeId,
        "estados_civile_id": estadosCivileId,
        "relaciones_persona_id": relacionesPersonaId,
        "etnia_id": etniaId,
        "niveles_educativo_id": nivelesEducativoId,
        "ocupacione_id": ocupacioneId,
        "situaciones_laborale_id": situacionesLaboraleId,
        "estado": estado,
        "deleted": deleted,
        "fallecido": fallecido,
        "identidad": identidad,
    };
}

class ScreenArguments {
   String idVivienda;
   DatosViviendaModel datosVivienda;
   Persona2Model info;

  ScreenArguments({this.idVivienda, this.datosVivienda, this.info});

  
}


class SalesData {
  SalesData({this.title, this.data, this.icon});

  final String title;
  final int data;
  final String icon;

  Map<String, dynamic> toJson() => {
        "title": title,
        "data": data,
        "icon": icon,

    };

    factory SalesData.fromJson(Map<String, dynamic> json) => SalesData(
        title: json["title"],
        data: json["data"],
        icon: json["icon"],
    );
}