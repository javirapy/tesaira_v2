class InsertData {
  InsertVisita data;
  InsertData({this.data});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.toJson();
    
    return data;
  }

}


class InsertVisita {
  int viviendaId;
  double lat;
  double lon;
  List<DetallesVisitas> detallesVisitas;

  InsertVisita({this.viviendaId, this.lat, this.lon, this.detallesVisitas});

  InsertVisita.fromJson(Map<String, dynamic> json) {
    viviendaId = json['vivienda_id'];
    lat = json['lat'];
    lon = json['lon'];
    if (json['detalles_visitas'] != null) {
      detallesVisitas = new List<DetallesVisitas>();
      json['detalles_visitas'].forEach((v) {
        detallesVisitas.add(new DetallesVisitas.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vivienda_id'] = this.viviendaId;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    if (this.detallesVisitas != null) {
      data['detalles_visitas'] = this.detallesVisitas.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DetallesVisitas {
  int pacienteId;
  List<Actividades> actividades;

  DetallesVisitas({this.pacienteId, this.actividades});

  DetallesVisitas.fromJson(Map<String, dynamic> json) {
    pacienteId = json['paciente_id'];
    if (json['actividades'] != null) {
      actividades = new List<Actividades>();
      json['actividades'].forEach((v) {
        actividades.add(new Actividades.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paciente_id'] = this.pacienteId;
    if (this.actividades != null) {
      data['actividades'] = this.actividades.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Actividades {
  int procedimientoId;
  String valor;
  String comentario;
  int tipoActividad;
  String nombreProcedimiento;

  Actividades(
      {this.procedimientoId, this.valor, this.comentario, this.tipoActividad});

  Actividades.fromJson(Map<String, dynamic> json) {
    procedimientoId = json['procedimiento_id'];
    valor = json['valor'];
    comentario = json['comentario'] == 'null' ? null : json['comentario'] ;
    tipoActividad = json['tipo_actividad'];
    nombreProcedimiento = json['nombre'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['procedimiento_id'] = this.procedimientoId;
    data['valor'] = this.valor;
    data['comentario'] = this.comentario;
    data['tipo_actividad'] = this.tipoActividad;
    return data;
  }
}


class ResponseCrearVisita {
  
}