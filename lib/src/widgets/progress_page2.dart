import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/datos_censo.dart';
import 'package:formvalidation/src/providers/constantes.dart';
import 'package:formvalidation/src/providers/visita_provider.dart';
import 'package:formvalidation/src/utils/number.dart';
import 'package:formvalidation/src/widgets/loader.dart';
import 'package:formvalidation/src/widgets/progress_bar.dart';
import 'package:location/location.dart';
//import 'package:geolocator/geolocator.dart';
import 'app_alertdialog.dart';

class MyPages extends StatefulWidget {
  @override
  _MyPagesState createState() => _MyPagesState();
}
 
class _MyPagesState extends State<MyPages> {
  
  
  final formKey     = GlobalKey<FormState>();
  VisitaBloc bloc;
  
    
  Map<String, dynamic> mapInsert = new Map<String, dynamic>();
  
  final visitaProvider = new VisitaProvider();
  PageController controller = PageController();
  Future<DatosCensoModel> futureDatos;
  double latitud;
  double longitud;

  @override
  void initState() { 
    super.initState();
    futureDatos = visitaProvider.getDatosCenso();
  }

  @override
  Widget build(BuildContext context) {
    bloc = LocalProvider.visitaBloc(context);
    
    return Scaffold(
      appBar: _crearAppBar(bloc, context),
      //body: crearBody(context, bloc),
      body: _buildPage(context, bloc),
      
    );
  }

  disparo(){
    print('Ejecutando funcion');
    bloc.changeProgress(Numero(0.14));
    controller.jumpToPage(1);
    setState(() {    
              });
  }

  disparo2(){
    print('Ejecutando funcion');
    bloc.changeProgress(Numero(0.28));
    formKey.currentState.save();  
    controller.jumpToPage(2);
    setState(() {          
              });
  }

  disparo3(){
    print('Ejecutando funcion');
    bloc.changeProgress(Numero(0.42));
    controller.jumpToPage(3);
    setState(() {                
              });
  }

  disparo4(){
    print('Ejecutando funcion');
    bloc.changeProgress(Numero(0.56));
    controller.jumpToPage(4);
    setState(() {                
              });
  }

  disparo5(){
    print('Ejecutando funcion');
    bloc.changeProgress(Numero(0.7));
    controller.jumpToPage(5);
    setState(() {                
              });
  }

  disparo6(){
    print('Ejecutando funcion');
    bloc.changeProgress(Numero(0.9));
    controller.jumpToPage(6);
    setState(() {                
              });
  }

  Widget _buildPage(BuildContext context, VisitaBloc bloc){
    return FutureBuilder<DatosCensoModel>(
      future: futureDatos,
      builder: (BuildContext context, AsyncSnapshot<DatosCensoModel> snapshot) {
        print('ENtra en el builder');
        print('Entra al build ');
        if ( snapshot.hasData ) {
          print('tiene data el snapshot');
          final datos = snapshot.data;
          return  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: PageView(
                      controller: controller,
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        Page1(mapInsert: mapInsert, datos: datos, controller: controller, callback: disparo,),
                        Page2(mapInsert: mapInsert, datos: datos, controller: controller, callback: disparo2, formKey: formKey,),
                        Page3(mapInsert: mapInsert, datos: datos, controller: controller, callback: disparo3),
                        Page4(mapInsert: mapInsert, datos: datos, controller: controller, callback: disparo4,),
                        Page5(mapInsert: mapInsert, datos: datos, controller: controller, callback: disparo5),
                        Page6(mapInsert: mapInsert, datos: datos, controller: controller, callback: disparo6,),
                        Page7(mapInsert: mapInsert, datos: datos, controller: controller, callback: () => insertCenso(context))
                      ],
                    ),
                  );
        }else{
          return LoadingScreen();
          
        }
      }
      );

  }

  Widget _crearAppBar(VisitaBloc bloc, context){
    return AppBar(
                title: AnimatedProgressbar(value: bloc.progress?.valor ?? Numero(0).valor),
                leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    bloc.changeProgress(Numero(0));
                    Navigator.pop(context);
                  } 
                ),
              );
  }

  void actionInsert(context, String viviendaId ){
    Navigator.pushReplacementNamed(context, 'pacientePrinc', arguments: viviendaId);
  }

  void showMessageSuccess(BuildContext context, String mensaje, String viviendaId ) {
    AppAlertDialog.success(
      context: context,
      tittle: 'Tesãira', 
      desc: mensaje, 
      btnOkOnPress: () => actionInsert(context, viviendaId)
    );
  }

  void showMessageError(BuildContext context, String mensaje){
    AppAlertDialog.error(
    context: context,
    tittle: 'Tesãira',
    desc: mensaje,
    btnCancelOnPress: () => print('Modal cerrado')
  );
  }

  obtenerUbicacion() async{
    /*Position currentPosition = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitud = currentPosition.latitude;
      longitud = currentPosition.longitude;
    });*/

    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

  _locationData = await location.getLocation();
    print(location);
    setState(() {
      latitud = _locationData.latitude;
      longitud = _locationData.longitude;
    });
  }

  insertCenso( context) async{
    print('insert censo');
    await obtenerUbicacion();
    mapInsert['lat'] = latitud;
    mapInsert['lon'] = longitud;
    print('Se ejecuta crear censo');
    final visitaProvider = new VisitaProvider();
    String mensaje = await visitaProvider.crearCenso(mapInsert);
    if(mensaje != 'Ha ocurrido un error'){
      bloc.changeProgress(Numero(0));
      showMessageSuccess(context, 'Al presionar ok lo llevará a la pantalla de cargar datos de la familia', mensaje);
    }else{
      showMessageError(context, mensaje);
    }
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
  //final formKey     = GlobalKey<FormState>();
  VisitaBloc bloc; 
  
  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();
    print('Se dibuja el page1');
    bloc = LocalProvider.visitaBloc(context);
    return Column(
      children: [
          Form(
            key: widget.formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  _item(etiqueta: 'Microterritorio', property: 'microterritorio_id', atributo: widget.mapInsert, listaValor: widget.datos.microterritorios, valorTomar: ConstantePage.DESCRIPCION),
                  _item(etiqueta: 'Barrio/compañía', property: 'barrios_compania_id', atributo: widget.mapInsert, listaValor: widget.datos.barriosCompanias, valorTomar: ConstantePage.NOMBRE),
                  _item(etiqueta: 'Área', property:'area', atributo: widget.mapInsert, listaValor: generarListaArea(), valorTomar: ConstantePage.DESCRIPCION),
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
                onPressed:(){
                  if(widget.mapInsert['microterritorio_id'] == null || widget.mapInsert['barrios_compania_id'] == null || widget.mapInsert['area'] == null){
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

  TextEditingController casaController = new TextEditingController(text: '');
  TextEditingController direccionController= new TextEditingController(text: '') ;
  TextEditingController referenciaController= new TextEditingController(text: '') ;
  
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
                  _crearInputCasa(etiqueta:'Nro. Casa', property:'numero_casa', atributo:widget.mapInsert),
                  _crearInputDireccion(etiqueta:'Dirección', property:'direccion', atributo:widget.mapInsert),
                  _crearInputReferencia(etiqueta:'Referencia', property:'referencia', atributo:widget.mapInsert),
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
                  if( casaController.text == '' || referenciaController.text == '' || direccionController.text == '' ){
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

  Widget _crearInputCasa({@required String etiqueta, @required String property, @required Map<String, dynamic> atributo}) {
    return TextFormField(
      //initialValue: 'El inicial',
      //textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: etiqueta
      ),
      onSaved: (value) => atributo[property] = value,
      controller: casaController,
    );

  }

  Widget _crearInputDireccion({@required String etiqueta, @required String property, @required Map<String, dynamic> atributo}) {
    return TextFormField(
      //initialValue: 'El inicial',
      //textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: etiqueta
      ),
      onSaved: (value) => atributo[property] = value,
      controller: direccionController,
    );

  }

  Widget _crearInputReferencia({@required String etiqueta, @required String property, @required Map<String, dynamic> atributo}) {
    return TextFormField(
      //initialValue: 'El inicial',
      //textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: etiqueta
      ),
      onSaved: (value) => atributo[property] = value,
      controller: referenciaController,
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
    FocusScope.of(context).unfocus();

    return Column(
      children: [
          Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  _item(etiqueta: 'Propiedad de la vivienda', property: 'pertenencia_vivienda_id', atributo: widget.mapInsert, listaValor: widget.datos.pertenenciaViviendas, valorTomar: ConstantePage.DESCRIPCION),
                  _item(etiqueta: 'Pared', property:'tipos_parede_id', atributo: widget.mapInsert, listaValor: widget.datos.tiposParedes, valorTomar: ConstantePage.NOMBRE),
                  _item(etiqueta: 'Techo', property:'tipos_techo_id', atributo: widget.mapInsert, listaValor: widget.datos.tiposTechos, valorTomar: ConstantePage.NOMBRE),
                  _item(etiqueta: 'Piso', property:'tipos_piso_id', atributo: widget.mapInsert, listaValor: widget.datos.tiposPisos, valorTomar: ConstantePage.NOMBRE),
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
                  if(widget.mapInsert['pertenencia_vivienda_id'] == null || widget.mapInsert['tipos_parede_id'] == null || widget.mapInsert['tipos_techo_id'] == null || widget.mapInsert['tipos_piso_id'] == null){
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
    FocusScope.of(context).unfocus();
    return Column(
      children: [
          Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  _item(etiqueta: 'Hacinamiento', property:'hacinamiento', atributo: widget.mapInsert, listaValor: generarListaBoolean(), valorTomar: ConstantePage.DESCRIPCION),
                  _item(etiqueta: 'Aguateria', property:'aguateria_id', atributo: widget.mapInsert, listaValor: widget.datos.aguaterias, valorTomar: ConstantePage.NOMBRE),
                  _item(etiqueta: 'Desague baño', property:'tipos_desague_banio_id', atributo: widget.mapInsert, listaValor: widget.datos.tiposDesagueBanios, valorTomar: ConstantePage.NOMBRE),
                  _item(etiqueta: 'Tipo baño', property:'tipos_banio_id', atributo: widget.mapInsert, listaValor: widget.datos.tiposBanios, valorTomar: ConstantePage.NOMBRE),
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
                  if(widget.mapInsert['hacinamiento'] == null || widget.mapInsert['aguateria_id'] == null || widget.mapInsert['tipos_desague_banio_id'] == null || widget.mapInsert['tipos_banio_id'] == null){
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


class Page5 extends StatefulWidget {
  final Map<String, dynamic> mapInsert;
  final DatosCensoModel datos;
   final PageController controller;
   final VoidCallback callback;

  const Page5({Key key, this.mapInsert, this.datos, this.controller, this.callback}): super(key: key);

  @override
  _Page5State createState() => _Page5State();
}

class _Page5State extends State<Page5> {
  final formKey     = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();
    return Column(
      children: [
          Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  _item(etiqueta: 'Luz electrica', property:'luz_electrica', atributo: widget.mapInsert, listaValor: generarListaBoolean(), valorTomar: ConstantePage.DESCRIPCION),
                  _item(etiqueta: 'Telefono Linea baja', property:'telefono_linea_baja', atributo: widget.mapInsert, listaValor: generarListaBoolean(), valorTomar: ConstantePage.DESCRIPCION),
                  _item(etiqueta: 'Telefono Celular', property:'telefono_celular', atributo: widget.mapInsert, listaValor: generarListaBoolean(), valorTomar: ConstantePage.DESCRIPCION),
                  _item(etiqueta: 'Heladera', property:'heladera', atributo: widget.mapInsert, listaValor: generarListaBoolean(), valorTomar: ConstantePage.DESCRIPCION),
                  _item(etiqueta: 'TV', property:'tv', atributo: widget.mapInsert, listaValor: generarListaBoolean(), valorTomar: ConstantePage.DESCRIPCION),
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
                  if(widget.mapInsert['luz_electrica'] == null || widget.mapInsert['telefono_linea_baja'] == null || widget.mapInsert['telefono_celular'] == null || widget.mapInsert['tv'] == null || widget.mapInsert['heladera'] == null){
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
  
  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();
    return Column(
      children: [
          Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  _item(etiqueta: 'Automovil', property:'automovil', atributo: widget.mapInsert, listaValor: generarListaBoolean(), valorTomar: ConstantePage.DESCRIPCION),
                  _item(etiqueta: 'Motocicleta', property:'motocicleta', atributo: widget.mapInsert, listaValor: generarListaBoolean(), valorTomar: ConstantePage.DESCRIPCION),
                  _item(etiqueta: 'Taxi', property:'taxi', atributo: widget.mapInsert, listaValor: generarListaBoolean(), valorTomar: ConstantePage.DESCRIPCION),
                  _item(etiqueta: 'Transporte Publico', property:'transporte_publico', atributo: widget.mapInsert, listaValor: generarListaBoolean(), valorTomar: ConstantePage.DESCRIPCION),
                  _item(etiqueta: 'Carreta', property:'carreta', atributo: widget.mapInsert, listaValor: generarListaBoolean(), valorTomar: ConstantePage.DESCRIPCION),
                  _item(etiqueta: 'Caballo', property:'caballo', atributo: widget.mapInsert, listaValor: generarListaBoolean(), valorTomar: ConstantePage.DESCRIPCION),
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
                  if(widget.mapInsert['automovil'] == null || widget.mapInsert['motocicleta'] == null || widget.mapInsert['taxi'] == null || widget.mapInsert['transporte_publico'] == null || widget.mapInsert['carreta'] == null || widget.mapInsert['caballo'] == null){
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


class Page7 extends StatefulWidget {
  final Map<String, dynamic> mapInsert;
  final DatosCensoModel datos;
   final PageController controller;
   final Function callback;

  const Page7({Key key, this.mapInsert, this.datos, this.controller, this.callback}): super(key: key);

  @override
  _Page7State createState() => _Page7State();
}

class _Page7State extends State<Page7> {
  final formKey     = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();
    return Column(
      children: [
          Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),

                  _item(etiqueta: 'Seguro Publico', property:'seguro_publico', atributo: widget.mapInsert, listaValor: generarListaBoolean(), valorTomar: ConstantePage.DESCRIPCION),
                  _item(etiqueta: 'Seguro Privado', property:'seguro_privado', atributo: widget.mapInsert, listaValor: generarListaBoolean(), valorTomar: ConstantePage.DESCRIPCION),                               
                  _item(etiqueta: 'Farmacia', property:'farmacia', atributo: widget.mapInsert, listaValor: generarListaBoolean(), valorTomar: ConstantePage.DESCRIPCION),
                  _item(etiqueta: 'Medico Naturalista', property:'medico_naturalista', atributo: widget.mapInsert, listaValor: generarListaBoolean(), valorTomar: ConstantePage.DESCRIPCION)
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
                          child: Text('Finalizar vivienda'),
                        ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)
                ),
                elevation: 0.0,
                color: Colors.orange,
                textColor: Colors.white,
                onPressed: (){
                  if(widget.mapInsert['seguro_publico'] == null || widget.mapInsert['seguro_privado'] == null || widget.mapInsert['farmacia'] == null || widget.mapInsert['medico_naturalista'] == null){
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