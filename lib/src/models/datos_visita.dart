class DatosVisita {
  int id;
  int esfId;
  int viviendaId;
  String fecha;
  String hora;
  String lat;
  String lon;
  Null estado;
  Null deleted;
  List<DetallesVisitas2> detallesVisitas;

  DatosVisita(
      {this.id,
      this.esfId,
      this.viviendaId,
      this.fecha,
      this.hora,
      this.lat,
      this.lon,
      this.estado,
      this.deleted,
      this.detallesVisitas});

  DatosVisita.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    esfId = json['esf_id'];
    viviendaId = json['vivienda_id'];
    fecha = json['fecha'];
    hora = json['hora'];
    lat = json['lat'];
    lon = json['lon'];
    estado = json['estado'];
    deleted = json['deleted'];
    if (json['detalles_visitas'] != null) {
      detallesVisitas = new List<DetallesVisitas2>();
      json['detalles_visitas'].forEach((v) {
        detallesVisitas.add(new DetallesVisitas2.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['esf_id'] = this.esfId;
    data['vivienda_id'] = this.viviendaId;
    data['fecha'] = this.fecha;
    data['hora'] = this.hora;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['estado'] = this.estado;
    data['deleted'] = this.deleted;
    if (this.detallesVisitas != null) {
      data['detalles_visitas'] =
          this.detallesVisitas.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DetallesVisitas2 {
  int id;
  int visitaId;
  int pacienteId;
  Null estadoVisita;
  List<ActividadesVisitas> actividades;
  Paciente paciente;

  DetallesVisitas2(
      {this.id,
      this.visitaId,
      this.pacienteId,
      this.estadoVisita,
      this.actividades,
      this.paciente});

  DetallesVisitas2.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    visitaId = json['visita_id'];
    pacienteId = json['paciente_id'];
    estadoVisita = json['estado_visita'];
    if (json['actividades'] != null) {
      actividades = new List<ActividadesVisitas>();
      json['actividades'].forEach((v) {
        actividades.add(new ActividadesVisitas.fromJson(v));
      });
    }
    paciente = json['paciente'] != null
        ? new Paciente.fromJson(json['paciente'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['visita_id'] = this.visitaId;
    data['paciente_id'] = this.pacienteId;
    data['estado_visita'] = this.estadoVisita;
    if (this.actividades != null) {
      data['actividades'] = this.actividades.map((v) => v.toJson()).toList();
    }
    if (this.paciente != null) {
      data['paciente'] = this.paciente.toJson();
    }
    return data;
  }
}

class ActividadesVisitas {
  int id;
  int procedimientoId;
  String valor;
  String comentario;
  String created;
  Null estadoActivdad;
  int detallesVisitaId;
  String tipoActividad;
  Procedimiento procedimiento;

  ActividadesVisitas(
      {this.id,
      this.procedimientoId,
      this.valor,
      this.comentario,
      this.created,
      this.estadoActivdad,
      this.detallesVisitaId,
      this.tipoActividad,
      this.procedimiento});

  ActividadesVisitas.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    procedimientoId = json['procedimiento_id'];
    valor = json['valor'];
    comentario = json['comentario'];
    created = json['created'];
    estadoActivdad = json['estado_activdad'];
    detallesVisitaId = json['detalles_visita_id'];
    tipoActividad = json['tipo_actividad'];
    procedimiento = json['procedimiento'] != null
        ? new Procedimiento.fromJson(json['procedimiento'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['procedimiento_id'] = this.procedimientoId;
    data['valor'] = this.valor;
    data['comentario'] = this.comentario;
    data['created'] = this.created;
    data['estado_activdad'] = this.estadoActivdad;
    data['detalles_visita_id'] = this.detallesVisitaId;
    data['tipo_actividad'] = this.tipoActividad;
    if (this.procedimiento != null) {
      data['procedimiento'] = this.procedimiento.toJson();
    }
    return data;
  }
}

class Procedimiento {
  int id;
  String nombre;
  int tiposValoreId;
  Null estado;
  Null deleted;

  Procedimiento(
      {this.id, this.nombre, this.tiposValoreId, this.estado, this.deleted});

  Procedimiento.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
    tiposValoreId = json['tipos_valore_id'];
    estado = json['estado'];
    deleted = json['deleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nombre'] = this.nombre;
    data['tipos_valore_id'] = this.tiposValoreId;
    data['estado'] = this.estado;
    data['deleted'] = this.deleted;
    return data;
  }
}

class Paciente {
  int id;
  int personaId;
  Null planificacionFamiliar;
  Null fechaIngresoPani;
  Null estado;
  Null deleted;
  PersonaVisita persona;

  Paciente(
      {this.id,
      this.personaId,
      this.planificacionFamiliar,
      this.fechaIngresoPani,
      this.estado,
      this.deleted,
      this.persona});

  Paciente.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    personaId = json['persona_id'];
    planificacionFamiliar = json['planificacion_familiar'];
    fechaIngresoPani = json['fecha_ingreso_pani'];
    estado = json['estado'];
    deleted = json['deleted'];
    persona =
        json['persona'] != null ? new PersonaVisita.fromJson(json['persona']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['persona_id'] = this.personaId;
    data['planificacion_familiar'] = this.planificacionFamiliar;
    data['fecha_ingreso_pani'] = this.fechaIngresoPani;
    data['estado'] = this.estado;
    data['deleted'] = this.deleted;
    if (this.persona != null) {
      data['persona'] = this.persona.toJson();
    }
    return data;
  }
}

class PersonaVisita {
  int id;
  String nombre;
  String apellido;
  String fechaNacimiento;
  String sexo;
  String numeroDocumento;
  int tiposDocumentoId;
  int paisOrigenDocumentoId;
  int nacionalidadeId;
  int estadosCivileId;
  int relacionesPersonaId;
  Null etniaId;
  int nivelesEducativoId;
  int ocupacioneId;
  int situacionesLaboraleId;
  Null estado;
  Null deleted;
  Null fallecido;
  String identidad;

  PersonaVisita(
      {this.id,
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
      this.identidad});

  PersonaVisita.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
    apellido = json['apellido'];
    fechaNacimiento = json['fecha_nacimiento'];
    sexo = json['sexo'];
    numeroDocumento = json['numero_documento'];
    tiposDocumentoId = json['tipos_documento_id'];
    paisOrigenDocumentoId = json['pais_origen_documento_id'];
    nacionalidadeId = json['nacionalidade_id'];
    estadosCivileId = json['estados_civile_id'];
    relacionesPersonaId = json['relaciones_persona_id'];
    etniaId = json['etnia_id'];
    nivelesEducativoId = json['niveles_educativo_id'];
    ocupacioneId = json['ocupacione_id'];
    situacionesLaboraleId = json['situaciones_laborale_id'];
    estado = json['estado'];
    deleted = json['deleted'];
    fallecido = json['fallecido'];
    identidad = json['identidad'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nombre'] = this.nombre;
    data['apellido'] = this.apellido;
    data['fecha_nacimiento'] = this.fechaNacimiento;
    data['sexo'] = this.sexo;
    data['numero_documento'] = this.numeroDocumento;
    data['tipos_documento_id'] = this.tiposDocumentoId;
    data['pais_origen_documento_id'] = this.paisOrigenDocumentoId;
    data['nacionalidade_id'] = this.nacionalidadeId;
    data['estados_civile_id'] = this.estadosCivileId;
    data['relaciones_persona_id'] = this.relacionesPersonaId;
    data['etnia_id'] = this.etniaId;
    data['niveles_educativo_id'] = this.nivelesEducativoId;
    data['ocupacione_id'] = this.ocupacioneId;
    data['situaciones_laborale_id'] = this.situacionesLaboraleId;
    data['estado'] = this.estado;
    data['deleted'] = this.deleted;
    data['fallecido'] = this.fallecido;
    data['identidad'] = this.identidad;
    return data;
  }
}
