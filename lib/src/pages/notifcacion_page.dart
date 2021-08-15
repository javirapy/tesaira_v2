import 'package:flutter/material.dart';
import 'package:formvalidation/src/models/datos_censo.dart';
import 'package:formvalidation/src/models/datos_vivienda_model.dart';
import 'package:formvalidation/src/providers/visita_provider.dart';
import 'package:formvalidation/src/utils/utils.dart';
import 'package:formvalidation/src/widgets/app_alertdialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class NotificacionPage extends StatefulWidget {
  @override
  _NotificacionPageState createState() => _NotificacionPageState();
}

class _NotificacionPageState extends State<NotificacionPage> {
final formKey     = GlobalKey<FormState>();
Map<String, dynamic> mapInsert = new Map<String, dynamic>();
String cedula = '';
PersonaModel persona ;
bool _wating = false;
BuildContext myContext;

  @override
  Widget build(BuildContext context) {
    final spinner = SpinKitWave(
        color: Colors.green,
        size: 50.0,
    );
    myContext = context;
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuevo Suceso', style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ), 
      body: ModalProgressHUD(
        inAsyncCall: _wating,
        opacity: 0.5,
        progressIndicator: spinner,
         child: _crearBody(),
      ),
    );
  }

  Widget _crearBody() {
    return  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Form(
                          key: formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _item(etiqueta: 'Tipo Suceso', property: 'tipos_suceso_id', atributo: mapInsert, listaValor: generarListaSuceso(), valorTomar: "descripcion"),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: _crearInputButton(etiqueta:'C.I. Paciente', property:'paciente_id', atributo:mapInsert)),  
                                  ],
                                ) ,
                                SizedBox( height: 5.0, width: double.infinity ),
                                Text('Presione la lupa para verificar si existe el paciente', style: TextStyle(fontSize: 12, color: Colors.black54),),
                                SizedBox( height: 30.0, width: double.infinity ),
                                _dibujarDatosPersona(),
                                _crearInput(etiqueta:'Comentario', property:'comentario', atributo:mapInsert),
                                SizedBox( height: 60.0, width: double.infinity ),
                                Text('Todos los campos son requeridos', style: TextStyle(fontSize: 12, color: Colors.black54),),
                                SizedBox( height: 5.0, width: double.infinity ),
                                _crearBoton()
                              ]
                            ),
                          ),
                    )
    );
  }

  

  List<ItemModel> generarListaSuceso(){
    List<ItemModel> listaValor = new List();
    ItemModel notificar = new ItemModel();
    notificar.id = 1;
    notificar.descripcion = 'Notificar';

    ItemModel fallecimiento = new ItemModel();
    fallecimiento.id = 2;
    fallecimiento.descripcion = 'Fallecimiento';

    ItemModel desvinculacion = new ItemModel();
    desvinculacion.id = 3;
    desvinculacion.descripcion = 'Desvinculación';

    listaValor.add(notificar);
    listaValor.add(fallecimiento);
    listaValor.add(desvinculacion);

    return listaValor;
  }

  Widget _item({@required String etiqueta, @required String property, @required Map<String, dynamic> atributo, @required List<ItemModel> listaValor, @required valorTomar }) {
    return FormField(
            builder: (FormFieldState state) {
              return InputDecorator(
                decoration: InputDecoration(
                  //icon: const Icon(Icons.color_lens),
                  labelText: etiqueta,
                ),
                //isEmpty: _color == '',
                child: new DropdownButtonHideUnderline(
                  child: new DropdownButton(
                    value: atributo[property],
                    isDense: true,
                    onChanged: (opt) {
                      setState(() {
                        atributo[property] = opt;
                        //_color = newValue;
                        //state.didChange(opt);
                      });
                    },
                    items: listaValor.map((value) {                      
                      return new DropdownMenuItem(
                        value: value.id,
                        child: new Text(value.descripcion),
                      );
                    }).toList()
                  ),
                )
              );

        }
    );
  }

  Widget _crearInputButton({@required String etiqueta, @required String property, @required Map<String, dynamic> atributo}) {

    return TextFormField(
      decoration: InputDecoration(
        labelText: etiqueta,
        suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              obtenerPersona();
            },)
      ),
      onSaved: (value) {
        cedula = value;
      } 
    );

  }

  obtenerPersona() async {
    final visitaProvider = new VisitaProvider();
    formKey.currentState.save();
    setState(() {
      _wating = true;
    });
    
    DatosViviendaModel info = await visitaProvider.buscarPaciente(cedula);
    if(info != null){
      for(var i = 0; i < info.personas.length ; i++){
        if(cedula.compareTo(info.personas[i].documento) == 0){
          mapInsert['paciente_id'] = info.personas[i].paciente_id;
          persona = info.personas[i];    
        }
      }
      setState(() {
        _wating = false;
      });
    }else{
      mapInsert['paciente_id'] = null;
      mostrarAlerta(myContext, 'No existe un paciente con el documento indicado');
      setState(() {
        _wating = false;
      });
    }
    
    
  }

  Widget _crearInput({@required String etiqueta, @required String property, @required Map<String, dynamic> atributo}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: etiqueta
      ),
      onSaved: (value) => atributo[property] = value,
    );
  }

  Widget _crearBoton( ) {       
      return RaisedButton(
        child: Container(
          padding: EdgeInsets.symmetric( horizontal: 80.0, vertical: 15.0),
          child: Text('Registrar'),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)
        ),
        elevation: 0.0,
        color: Colors.green,
        textColor: Colors.white,
        onPressed: () {
          formKey.currentState.save();
          final visitaProvider = new VisitaProvider();
          var mensaje;

          if(mapInsert['tipos_suceso_id'] == null){
            mostrarAlerta(myContext, 'Seleccione el Tipo de Suceso');
            return;
          }
          if(mapInsert['paciente_id'] == null || mapInsert['paciente_id'] == ""){
            mostrarAlerta(myContext, 'Debe cargar el documento de un paciente');
            return;
          }
          if(mapInsert['comentario'] == null || mapInsert['comentario'] == ""){
            mostrarAlerta(myContext, 'El comentario es requerido');
            return;
          }

          mensaje = visitaProvider.crearNotificacion(mapInsert);    
          if(mensaje != 'Ha ocurrido un error'){
            showMessageSuccess(myContext, 'Al presionar ok lo llevará a la pantalla de menú');
          }else{
            mostrarAlerta(myContext, mensaje);
          } 
        }
      );
      
  }

  Widget _dibujarDatosPersona() {
    if(mapInsert['paciente_id'] != null){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        Text("Nombre: " + persona.nombre),
        Text("Apellido: " + persona.apellido)
      ],);
    }else{
      return Container();
    }
  }

  void showMessageSuccess(BuildContext context, String mensaje ) {
    AppAlertDialog.success(
      context: context,
      tittle: 'Suceso guardado exitosamente', 
      desc: mensaje, 
      btnOkOnPress: () => Navigator.pushReplacementNamed(context, 'botones')
    );

  }

  
}
