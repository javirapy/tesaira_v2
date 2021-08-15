import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/datos_censo.dart';
import 'package:formvalidation/src/models/datos_vivienda_model.dart';
import 'package:formvalidation/src/providers/constantes.dart';
import 'package:formvalidation/src/providers/visita_provider.dart';
import 'package:formvalidation/src/utils/number.dart';
import 'package:formvalidation/src/widgets/app_alertdialog.dart';
import 'package:formvalidation/src/widgets/loader.dart';
import 'package:formvalidation/src/widgets/progress_bar.dart';

class PacientePage extends StatefulWidget {
  @override
  _PacientePageState createState() => _PacientePageState();
}

class _PacientePageState extends State<PacientePage> {
  
  Future _future;
  final formKey     = GlobalKey<FormState>();
  Map<String, dynamic> mapInsert = new Map<String, dynamic>();
  VisitaBloc bloc;
  VisitaProvider provider = new VisitaProvider();
  PageController controller = PageController();
  String viviendaId;


  @override
  void initState() {
    super.initState();
    _future = provider.getDatosCenso();
  }
  
  @override
  Widget build(BuildContext context) {
    viviendaId = ModalRoute.of(context).settings.arguments;
    bloc = LocalProvider.visitaBloc(context);
    return Scaffold(
      appBar: _crearAppBar(context),
      body: crearBody(context),
      
    );
  }

  Widget _crearAppBar(context){
    return AppBar(
        title: AnimatedProgressbar(value: bloc.progress?.valor ?? Numero(0).valor),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            bloc.changeProgress(Numero(0));

            Navigator.pushReplacementNamed(context, 'pacientePrinc', arguments: viviendaId);
          } 
        ),
    );
  }

  

  Widget crearBody(BuildContext context){
    //final bloc = Provider.visitaBloc(context);
    //print('Entra al build; ${insert.microterritorio_id}');
    return FutureBuilder<DatosCensoModel>(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<DatosCensoModel> snapshot) {
        if ( snapshot.hasData ) {
          final datos = snapshot.data;
          return  Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: PageView(
                      controller: controller,
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        Page1(mapInsert: mapInsert, datos: datos, controller: controller, callback: disparo,),
                        Page2(mapInsert: mapInsert, datos: datos, controller: controller, callback: disparo2, formKey: formKey),
                        Page3(mapInsert: mapInsert, datos: datos, controller: controller, callback: disparo3),
                        Page4(mapInsert: mapInsert, datos: datos, controller: controller, callback: disparo4),
                        Page6(mapInsert: mapInsert, datos: datos, controller: controller, callback: () => insertPersona(context),),
                      ],
                ),    
                    
                    /*child: Form(
                          key: formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                  
                                  
                                  _item(etiqueta: 'Etnia', property: 'etnia_id', atributo: mapInsert, listaValor: datos.etnia, valorTomar: NOMBRE),

                                //_crearBoton(mapInsert),
                                //Expanded(child: Text('.')),
                                //_crearAcciones()
                              ],
                            ),
                          ),
                    ),*/
            )
          ;
        }else{
          return LoadingScreen();
        }
      }
    );
  }

  disparo(){
    print('Ejecutando funcion');
    bloc.changeProgress(Numero(0.2));
    controller.jumpToPage(1);
    setState(() {    
              });
  }

  disparo2(){
    print('Ejecutando funcion');
    bloc.changeProgress(Numero(0.4));
    formKey.currentState.save();  
    controller.jumpToPage(2);
    setState(() {          
              });
  }

  disparo3(){
    print('Ejecutando funcion');
    bloc.changeProgress(Numero(0.6));
    controller.jumpToPage(3);
    setState(() {                
              });
  }

  disparo4(){
    print('Ejecutando funcion');
    bloc.changeProgress(Numero(0.8));
    controller.jumpToPage(4);
    setState(() {                
              });
  }

  insertPersona( context) async{
    
    
    //sendData.lat = -25;
    //sendData.lon = -26;
    VisitaProvider visitaProvider = new VisitaProvider();
    mapInsert['vivienda_id'] = int.parse(viviendaId);
    String mensaje = await visitaProvider.crearPaciente(mapInsert);
    if(mensaje == 'ok'){
      if(bloc.personas != null && bloc.personas.length > 0){
        List<PersonaModel> personas = bloc.personas;
        PersonaModel p = PersonaModel(documento: mapInsert['numero_documento'], nombre: mapInsert['nombre'], apellido: mapInsert['apellido']);
        personas.add(p);
        bloc.changePersonas(personas);
      }else{
        List<PersonaModel> personas = [];
        PersonaModel p = PersonaModel(documento: mapInsert['numero_documento'], nombre: mapInsert['nombre'], apellido: mapInsert['apellido']);
        personas.add(p);
        bloc.changePersonas(personas);
      }
      bloc.changeProgress(Numero(0));
      showMessageSuccess(context, 'Agregado correctamente');
    } else{
      showMessageError(context, mensaje);
    }
  }

  void showMessageError(BuildContext context, String mensaje){
    AppAlertDialog.error(
      context: context,
      tittle: 'Tesãira',
      desc: mensaje,
      btnCancelOnPress: () => print('Modal cerrado')
    );
  }

  void actionInsert(context ){
    mapInsert = null;  
    Navigator.pushReplacementNamed(context, 'pacientePrinc', arguments: viviendaId);
  }

  void showMessageSuccess(BuildContext context, String mensaje ) {
    AppAlertDialog.success(
      context: context,
      tittle: 'Tesãira', 
      desc: mensaje, 
      btnOkOnPress: () => actionInsert(context)
    );
  }



}


class Page1 extends StatefulWidget {
  final Map<String, dynamic> mapInsert;
  final DatosCensoModel datos;
  final PageController controller;
  final Numero progress;
  final VoidCallback callback;
  final formKey;
  

  const Page1({Key key, this.mapInsert, this.datos, this.controller, this.progress, this.callback, this.formKey}): super(key: key);

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  final formKey     = GlobalKey<FormState>();
  VisitaBloc bloc;
  
  
  @override
  Widget build(BuildContext context) {
    print('Se dibuja el page1');
    bloc = LocalProvider.visitaBloc(context);
    return Column(
      children: [
          Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  
                  
                  _item(etiqueta: 'Tipo de Documento', property: 'tipos_documento_id', atributo: widget.mapInsert, listaValor: widget.datos.tiposDocumentos, valorTomar: ConstantePage.NOMBRE),
                  _item(etiqueta: 'Pais Origen Documento', property: 'pais_origen_documento_id', atributo: widget.mapInsert, listaValor: widget.datos.paisOrigen, valorTomar: ConstantePage.NOMBRE),
                  _item(etiqueta: 'Nacionalidad', property: 'nacionalidade_id', atributo: widget.mapInsert, listaValor: widget.datos.nacionalidades, valorTomar: ConstantePage.DESCRIPCION),
                  
                  
                  //fecha nacimiento ndoikomo'ai
                  //sexo ndoikomo'ai
                  
                  //_item(etiqueta: 'Nivel Educativo', property: 'niveles_educativo_id', atributo: widget.mapInsert, listaValor: widget.datos.nivelesEducativos, valorTomar: ConstantePage.NOMBRE),
                 //// _item(etiqueta: 'Situación Laboral', property: 'situaciones_laborale_id', atributo: widget.mapInsert, listaValor: widget.datos.situacionesLaborales, valorTomar: ConstantePage.DESCRIPCION),
                ////_item(etiqueta: 'Ocupación', property: 'ocupacione_id', atributo: widget.mapInsert, listaValor: widget.datos.ocupaciones, valorTomar: ConstantePage.NOMBRE),
                //_item(etiqueta: 'Afección', property: 'afeccione_id', atributo: widget.mapInsert, listaValor: widget.datos.afecciones, valorTomar: ConstantePage.NOMBRE),
                
                ]
              ),
            ),
          ),
          
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                child: Container(
                          margin: EdgeInsets.symmetric( horizontal: 80.0, vertical: 5.0),
                          //padding: EdgeInsets.symmetric( horizontal: 30.0, vertical: 50.0),
                          child: Text('Siguiente'),
                        ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)
                ),
                elevation: 0.0,
                color: Colors.green,
                textColor: Colors.white,
                onPressed: (){
                  if(widget.mapInsert['tipos_documento_id'] == null || widget.mapInsert['pais_origen_documento_id'] == null || widget.mapInsert['nacionalidade_id'] == null){
                     AppAlertDialog.error(
                      context: context,
                      tittle: 'Tesãira',
                      desc: 'Todos los campos son obligatorios',
                      btnCancelOnPress: () => print('Modal cerrado'));
                  }else{
                    widget.callback();
                  }
                  
                }
              ),
            )),
            SizedBox(height: 40,)
      ]
    );
  }
  

  Widget _item({@required String etiqueta, @required String property, @required Map<String, dynamic> atributo, @required List<ItemModel> listaValor, @required valorTomar }) {
    String texto ="";
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
                        print('entra en el setstate $opt');
                        atributo[property] = opt;
                        print('despues setstate');
                        //_color = newValue;
                        //state.didChange(opt);
                      });
                    },
                    items: listaValor.map((value) {
                      
                      if(valorTomar == ConstantePage.GENTILICIO){
                         texto = value.gentilicio;
                      }

                      if(valorTomar == ConstantePage.NOMBRE){
                        texto = value.nombre;
                      }

                      if(valorTomar == ConstantePage.DESCRIPCION){
                        texto = value.descripcion;
                      }
                      
                      return new DropdownMenuItem(
                        value: value.id,
                        child: new Text(texto),
                      );
                    }).toList()
                  ),
                )
              );

        }
    );
  }





  Widget _crearInputFecha(){

  }

  Future<Null> _selectDate(BuildContext context) async {
      DateTime selectedDate = DateTime.now();

      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2015, 8),
          lastDate: DateTime(2101));
      if (picked != null && picked != selectedDate)
        setState(() {
          selectedDate = picked;
        });

  }
}

class Page2 extends StatefulWidget {
  final Map<String, dynamic> mapInsert;
  final DatosCensoModel datos;
   final PageController controller;
   final VoidCallback callback;
   final formKey;

  const Page2({Key key, this.mapInsert, this.datos, this.controller, this.callback, this.formKey}): super(key: key);

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  //final formKey     = GlobalKey<FormState>();

  TextEditingController textController = new TextEditingController(text: '') ;
  TextEditingController documentoController = new TextEditingController(text: '');
  TextEditingController nombreController= new TextEditingController(text: '') ;
  TextEditingController apellidoController= new TextEditingController(text: '') ;
  DateTime selectedDate = DateTime.now();

  /*@override
  void initState() { 
    super.initState();
    textController = new TextEditingController(text: '');
  }*/
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
          Form(
            key: widget.formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  _crearInputDocumento(etiqueta:'Nro. Documento', property:'numero_documento', atributo: widget.mapInsert),
                  _crearInputFecha(context, etiqueta:'Fecha Nacimiento', property:'fecha_nacimiento', atributo: widget.mapInsert),
                  _crearInputNombre(etiqueta:'Nombres', property:'nombre', atributo: widget.mapInsert),
                  _crearInputApellido(etiqueta:'Apellidos', property:'apellido', atributo: widget.mapInsert),
                ],
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                child: Container(
                          margin: EdgeInsets.symmetric( horizontal: 80.0, vertical: 5.0),
                          //padding: EdgeInsets.symmetric( horizontal: 30.0, vertical: 50.0),
                          child: Text('Siguiente'),
                        ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)
                ),
                elevation: 0.0,
                color: Colors.green,
                textColor: Colors.white,
                onPressed: (){
                  if( textController.text == '' || documentoController.text == '' || nombreController.text == '' || apellidoController.text == ''
                    ){
                     AppAlertDialog.error(
                      context: context,
                      tittle: 'Tesãira',
                      desc: 'Todos los campos son obligatorios',
                      btnCancelOnPress: () => print('Modal cerrado'));
                  }else{
                    widget.callback();
                  }
                  
                }
              ),
            )),
            SizedBox(height: 40),
      ]
    );
  }

  
  Widget _crearInputDocumento({@required String etiqueta, @required String property, @required Map<String, dynamic> atributo}) {
    return TextFormField(
      //initialValue: 'El inicial',
      //textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: etiqueta
      ),
      onSaved: (value) => atributo[property] = value,
      controller: documentoController,
    );

  }

  Widget _crearInputNombre({@required String etiqueta, @required String property, @required Map<String, dynamic> atributo}) {
    return TextFormField(
      //initialValue: 'El inicial',
      //textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: etiqueta
      ),
      onSaved: (value) => atributo[property] = value,
      controller: nombreController,
    );

  }



Widget _crearInputApellido({@required String etiqueta, @required String property, @required Map<String, dynamic> atributo}) {
    return TextFormField(
      //initialValue: 'El inicial',
      //textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: etiqueta
      ),
      onSaved: (value) => atributo[property] = value,
      controller: apellidoController,
    );

  }

  Widget _crearInputFecha(context ,{@required String etiqueta, @required String property, @required Map<String, dynamic> atributo}) {
    
    return GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                          //initialValue: 'El inicial',
                          //textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            labelText: etiqueta
                          ),
                         // onTap: () => _selectDate(context),
                          onSaved: (value) => atributo[property] = selectedDate.toLocal().toString().split(' ')[0],
                          controller: textController,
                        )
                  )
    );

  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1890, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        textController.text = selectedDate.toLocal().toString().split(' ')[0];
      });
  }

}

class Page3 extends StatefulWidget {
  final Map<String, dynamic> mapInsert;
  final DatosCensoModel datos;
   final PageController controller;
   final VoidCallback callback;
   

  const Page3({Key key, this.mapInsert, this.datos, this.controller, this.callback}): super(key: key);

  @override
  _Page3State createState() => _Page3State();
}



class _Page3State extends State<Page3> {
  final formKey     = GlobalKey<FormState>();
  

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
          Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),

                  //_dibujarFecha(context),
                  _itemSexo(etiqueta: 'Sexo', property: 'sexo', atributo: widget.mapInsert, listaValor: generarListaSexo()),
                  _item(etiqueta: 'Estado Civil', property: 'estados_civile_id', atributo: widget.mapInsert, listaValor: widget.datos.estadosCiviles, valorTomar: ConstantePage.NOMBRE),
                  _item(etiqueta: 'Relacion', property: 'relaciones_persona_id', atributo: widget.mapInsert, listaValor: widget.datos.relacionesPersonas, valorTomar: ConstantePage.NOMBRE),
                ],
              ),
            ),
          ),
          
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                child: Container(
                          margin: EdgeInsets.symmetric( horizontal: 80.0, vertical: 5.0),
                          //padding: EdgeInsets.symmetric( horizontal: 30.0, vertical: 50.0),
                          child: Text('Siguiente'),
                        ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)
                ),
                elevation: 0.0,
                color: Colors.green,
                textColor: Colors.white,
                onPressed: (){
                  if(widget.mapInsert['sexo'] == null || widget.mapInsert['estados_civile_id'] == null || widget.mapInsert['relaciones_persona_id'] == null){
                     AppAlertDialog.error(
                      context: context,
                      tittle: 'Tesãira',
                      desc: 'Todos los campos son obligatorios',
                      btnCancelOnPress: () => print('Modal cerrado'));
                  }else{
                    widget.callback();
                  }
                  
                }
              ),
            )
          ),
          SizedBox(height: 40,)  
      ]
    );
  }


  Widget _item({@required String etiqueta, @required String property, @required Map<String, dynamic> atributo, @required List<ItemModel> listaValor, @required valorTomar }) {
    
    String texto ="";
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
                      });
                    },
                    items: listaValor.map((value) {
                      
                      if(valorTomar == ConstantePage.GENTILICIO){
                         texto = value.gentilicio;
                      }

                      if(valorTomar == ConstantePage.NOMBRE){
                        texto = value.nombre;
                      }

                      if(valorTomar == ConstantePage.DESCRIPCION){
                        texto = value.descripcion;
                      }
                      
                      return new DropdownMenuItem(
                        value: value.id,
                        child: new Text(texto),
                      );
                    }).toList()
                  ),
                )
              );

        }
    );
  }
  
  Widget _itemSexo({@required String etiqueta, @required String property, @required Map<String, dynamic> atributo, @required List<ItemModel> listaValor }) {
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
                        print('entra en el setstate $opt');
                        atributo[property] = opt;
                        print('despues setstate');
                        //_color = newValue;
                        //state.didChange(opt);
                      });
                    },
                    items: listaValor.map((value) {
                      return new DropdownMenuItem(
                        value: value.nombre,
                        child: new Text(value.descripcion),
                      );
                    }).toList()
                  ),
                )
              );

        }
    );
  }




  List<ItemModel> generarListaBoolean(){
    List<ItemModel> listaValor = new List();
    ItemModel si = new ItemModel();
    si.id = 1;
    si.descripcion = 'Sí';

    ItemModel no = new ItemModel();
    no.id = 0;
    no.descripcion = 'No';

    listaValor.add(si);
    listaValor.add(no);

    return listaValor;
  }

  List<ItemModel> generarListaArea(){
    List<ItemModel> listaValor = new List();
    ItemModel si = new ItemModel();
    si.id = 0;
    si.descripcion = 'Rural';

    ItemModel no = new ItemModel();
    no.id = 1;
    no.descripcion = 'Urbana';

    listaValor.add(si);
    listaValor.add(no);

    return listaValor;
  }

    List<ItemModel> generarListaSexo(){
    List<ItemModel> listaValor = new List();
    ItemModel si = new ItemModel();
    si.nombre = 'M';
    si.descripcion = 'Masculino';

    ItemModel no = new ItemModel();
    no.nombre = 'F';
    no.descripcion = 'Femenino';

    listaValor.add(si);
    listaValor.add(no);

    return listaValor;
  }
}

class Page4 extends StatefulWidget {
  final Map<String, dynamic> mapInsert;
  final DatosCensoModel datos;
   final PageController controller;
   final VoidCallback callback;

  const Page4({Key key, this.mapInsert, this.datos, this.controller, this.callback}): super(key: key);

  @override
  _Page4State createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  final formKey     = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
          Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  _item(etiqueta: 'Nivel educativo', property: 'niveles_educativo_id', atributo: widget.mapInsert, listaValor: widget.datos.nivelesEducativos, valorTomar: 'nombre'),
                  _item(etiqueta: 'Ocupacion', property: 'ocupacione_id', atributo: widget.mapInsert, listaValor: widget.datos.ocupaciones, valorTomar: 'nombre'),
                  _item(etiqueta: 'Situacion Laboral', property: 'situaciones_laborale_id', atributo: widget.mapInsert, listaValor: widget.datos.situacionesLaborales, valorTomar: 'descripcion')
                ],
              ),
            ),
          ),
          
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                child: Container(
                          margin: EdgeInsets.symmetric( horizontal: 80.0, vertical: 5.0),
                          //padding: EdgeInsets.symmetric( horizontal: 30.0, vertical: 50.0),
                          child: Text('Siguiente'),
                        ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)
                ),
                elevation: 0.0,
                color: Colors.green,
                textColor: Colors.white,
                onPressed: (){
                  if(widget.mapInsert['niveles_educativo_id'] == null || widget.mapInsert['ocupacione_id'] == null || widget.mapInsert['situaciones_laborale_id'] == null){
                     AppAlertDialog.error(
                      context: context,
                      tittle: 'Tesãira',
                      desc: 'Todos los campos son obligatorios',
                      btnCancelOnPress: () => print('Modal cerrado'));
                  }else{
                    widget.callback();
                  }
                  
                }
              ),
            )
          ),
          SizedBox(height: 40,)  
      ]
    );
  }

  Widget _item({@required String etiqueta, @required String property, @required Map<String, dynamic> atributo, @required List<ItemModel> listaValor, @required valorTomar }) {
    String texto ="";
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
                      });
                    },
                    items: listaValor.map((value) {
                      
                      if(valorTomar == ConstantePage.GENTILICIO){
                         texto = value.gentilicio;
                      }

                      if(valorTomar == ConstantePage.NOMBRE){
                        texto = value.nombre;
                      }

                      if(valorTomar == ConstantePage.DESCRIPCION){
                        texto = value.descripcion;
                      }
                      
                      return new DropdownMenuItem(
                        value: value.id,
                        child: new Text(texto),
                      );
                    }).toList()
                  ),
                )
              );

        }
    );
  }
  
  Widget _crearInput({@required String etiqueta, @required String property, @required Map<String, dynamic> atributo}) {

    return TextFormField(
      //initialValue: 'El inicial',
      //textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: etiqueta
      ),
      onSaved: (value) => atributo[property] = value,
    );

  }


  List<ItemModel> generarListaBoolean(){
    List<ItemModel> listaValor = new List();
    ItemModel si = new ItemModel();
    si.id = 1;
    si.descripcion = 'Sí';

    ItemModel no = new ItemModel();
    no.id = 0;
    no.descripcion = 'No';

    listaValor.add(si);
    listaValor.add(no);

    return listaValor;
  }

  List<ItemModel> generarListaArea(){
    List<ItemModel> listaValor = new List();
    ItemModel si = new ItemModel();
    si.id = 0;
    si.descripcion = 'Rural';

    ItemModel no = new ItemModel();
    no.id = 1;
    no.descripcion = 'Urbana';

    listaValor.add(si);
    listaValor.add(no);

    return listaValor;
  }
}


class Page6 extends StatefulWidget {
  final Map<String, dynamic> mapInsert;
  final DatosCensoModel datos;
   final PageController controller;
   final VoidCallback callback;

  const Page6({Key key, this.mapInsert, this.datos, this.controller, this.callback}): super(key: key);

  @override
  _Page6State createState() => _Page6State();
}

class _Page6State extends State<Page6> {
  final formKey     = GlobalKey<FormState>();
  Map<String, bool> valoresAfecciones = {};
  List<int> idAfeccion = [];

  @override
  void initState() {
    super.initState();
    widget.datos.afecciones.forEach((afeccion){
      valoresAfecciones[afeccion.nombre] = false;
    });
  } 
  
  @override
  Widget build(BuildContext context) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:   
                  _itemCheck(etiqueta: 'Afecciones', property: 'afecciones', atributo: widget.mapInsert, listaValor: widget.datos.afecciones, valoresAfecciones: valoresAfecciones)
                ,
              ),
            ),
          ),
          
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                child: Container(
                          margin: EdgeInsets.symmetric( horizontal: 80.0, vertical: 5.0),
                          //padding: EdgeInsets.symmetric( horizontal: 30.0, vertical: 50.0),
                          child: Text('Finalizar paciente'),
                        ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)
                ),
                elevation: 0.0,
                color: Colors.orange,
                textColor: Colors.white,
                onPressed: (){
                  print(valoresAfecciones);
                  print(idAfeccion);
                  List<Map<String, dynamic>> afeccionesId = [];
                  for (var item in idAfeccion) {
                    Map<String, dynamic> afecc = {"afeccione_id":item};
                    afeccionesId.add(afecc);
                  }
                  
                  widget.mapInsert['afecciones'] = afeccionesId;
                  print(widget.mapInsert);
                  widget.callback();
                }
              ),
            )
          ),
          SizedBox(height: 40,)  
      ]
    );
  }

  
  List<Widget> _itemCheck({@required String etiqueta, @required String property,@required Map<String, dynamic> atributo, @required List<ItemModel> listaValor, Map<String, bool> valoresAfecciones}){
    print('Se redibuja ITEMCHECK');
    
    final List<Widget> items = [];
    
    listaValor.forEach((item){
      
      final widgetTmp = Row(
                          //mainAxisAlignment: MainAxisAlignment.start,
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                              Checkbox(
                                  value: valoresAfecciones[item.nombre],
                                  onChanged: (bool value) {
                                    print('El valor es: $value');
                                      setState(() {
                                        valoresAfecciones[item.nombre] = value;
                                        print('Valorcheck es ${valoresAfecciones[item.nombre]}');
                                        if(value){
                                          idAfeccion.add(item.id);
                                        }else{
                                          idAfeccion.remove(item.id);
                                        }
                                      });
                                  },
                              ),
                                Text(item.nombre),
                          ],
                      );

        items.add(widgetTmp);
    });

    return items;
    /*return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: items);*/
  }
}
