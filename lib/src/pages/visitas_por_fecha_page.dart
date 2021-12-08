import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/datos_vivienda_model.dart';
import 'package:formvalidation/src/models/insert_visita_model.dart';
import 'package:formvalidation/src/providers/visita_provider.dart';
import 'package:formvalidation/src/search/search_persona_agregar_delegate.dart';
import 'package:formvalidation/src/widgets/app_alertdialog.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

//en esta pagina se carga la ci de la persona al cual se quiere visitar
class VisitasPorFechaPage extends StatefulWidget {
  @override
  _VisitasPorFechaPageState createState() => _VisitasPorFechaPageState();
}

class _VisitasPorFechaPageState extends State<VisitasPorFechaPage> {
  final visitaProvider = new VisitaProvider();
  bool _wating = false;
  DateTime selectedDate = DateTime.now();
  DateTime selectedDate2 = DateTime.now();

  TextEditingController finiController = new TextEditingController(text: '');
  TextEditingController ffinController = new TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    final spinner = SpinKitWave(
      color: Colors.green,
      size: 50.0,
    );

    return Scaffold(
      appBar: _crearAppBar(),
      body: ModalProgressHUD(
          inAsyncCall: _wating,
          opacity: 0.5,
          progressIndicator: spinner,
          child: _form(context)),
    );
  }

  ///SE QUITA PARA AGREGAR BUSQUEDA DINAMICA
  // Widget _crearAppBar(context){
  //   return AppBar(
  //       title: Text('Ingrese cedula', style: TextStyle(color: Colors.white),),
  //       centerTitle: true,
  //     );
  // }

  Widget _crearAppBar() {
    return AppBar(
      title: Text('Consulta Visitas...'),
      centerTitle: false,
      backgroundColor: Colors.green,
     /* actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            showSearch(
              context: context,
              delegate: DataPersonaAgregarSearch(),
              //query: 'Hola'
            );
          },
        )
      ],*/
    );
  }

  Widget _form(BuildContext context) {
    final bloc = LocalProvider.visitaBloc(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              height: 5.0,
            ),
          ),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 3.0)
                ]),
            child: Column(
              children: <Widget>[
                Text('Consulta Visitas', style: TextStyle(fontSize: 20.0)),
                SizedBox(height: 60.0),
                // _crearFechaInicio(bloc),
                _crearInputFechaIni(context, etiqueta: 'Fecha Inicio'),
                SizedBox(height: 30.0),
                //   _crearFechaFin(bloc),
                _crearInputFechaFin(context, etiqueta: 'Fecha Fin'),
                SizedBox(height: 30.0),
                _crearBoton(bloc)
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _crearFechaInicio(VisitaBloc bloc) {
  //     return StreamBuilder(
  //       stream: bloc.cedulaStream,
  //       builder: (BuildContext context, AsyncSnapshot snapshot){

  //         return Container(
  //           padding: EdgeInsets.symmetric(horizontal: 20.0),
  //           child: TextField(
  //             decoration: InputDecoration(
  //               labelText: 'Fecha inicio',
  //               errorText: snapshot.error
  //             ),
  //             onChanged: bloc.changeCedula,
  //           ),

  //         );

  //       },
  //     );
  // }

  // Widget _crearFechaFin(VisitaBloc bloc) {
  //   return StreamBuilder(
  //     stream: bloc.cedulaStream,
  //     builder: (BuildContext context, AsyncSnapshot snapshot){

  //       return Container(
  //         padding: EdgeInsets.symmetric(horizontal: 20.0),
  //         child: TextField(
  //           decoration: InputDecoration(
  //             labelText: 'Fecha Fin',
  //             errorText: snapshot.error
  //           ),
  //           onChanged: bloc.changeCedula,
  //         ),

  //       );

  //     },
  //   );

  // }

  Widget _crearInputFechaIni(context,
      {@required String etiqueta, @required String property}) {
     return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: GestureDetector(
        onTap: () => _selectDateIni(context),
        child: AbsorbPointer(
            child: TextFormField(
          //initialValue: 'El inicial',
          //textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(labelText: etiqueta),
          onTap: () => _selectDateIni(context),
          //  onSaved: (value) => atributo[property] = selectedDate.toLocal().toString().split(' ')[0],
          controller: finiController,
        ))),
    );
  }

  Widget _crearInputFechaFin(context,
      {@required String etiqueta, @required String property}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: GestureDetector(
          onTap: () => _selectDateFin(context),
          child: AbsorbPointer(
              child: TextFormField(
            //initialValue: 'El inicial',
            //textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(labelText: etiqueta),
            onTap: () => _selectDateFin(context),
            // onSaved: (value) => atributo[property] = selectedDate.toLocal().toString().split(' ')[0],
            controller: ffinController,
          ))),
    );
  }

  Future<Null> _selectDateIni(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1890, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        finiController.text = selectedDate.toLocal().toString().split(' ')[0];
      });
  }

  Future<Null> _selectDateFin(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate2,
        firstDate: DateTime(1890, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate2)
      setState(() {
        selectedDate2 = picked;
        ffinController.text = selectedDate2.toLocal().toString().split(' ')[0];
      });
  }

  Widget _crearBoton(VisitaBloc bloc) {
    return RaisedButton(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
          child: Text('Buscar'),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        elevation: 0.0,
        color: Colors.green,
        textColor: Colors.white,
        onPressed: () => _buscar(context));
  }

  _buscar(BuildContext context)  {
    // FocusScope.of(context).unfocus();
    // setState(() {
    //   _wating = true;
    // });
    //  List<InsertData> info = await visitaProvider.obtenerVisitas('2021-01-01', '2021-01-01');
    // setState(() {
    //   _wating = false;
    // });

//  DateTime ini = DateTime(ffinController.text);
//  DateTime fin = DateTime.parse(ffinController.text);
//         initialDate: DateTime(int.parse(formatterAno.format(now))-18),

//  if (ini - 10 <=  fin)

//   print(dt); // 2020-01-02 03:04:05.000

    // if ( info != null ) {
    // info.documentoBuscado = bloc.cedula;
    //info.fromView = 'BUSCARPERSONA';

    if( finiController.text == '' || ffinController.text == '' ){
                     AppAlertDialog.error(
                      context: context,
                      tittle: 'Tesãira',
                      desc: 'Todos los campos son obligatorios',
                      btnCancelOnPress: () => print('Modal cerrado'));
                  }else{

    InsertVisita fechas = new InsertVisita();
    fechas.fini = finiController.text;
    fechas.ffin = ffinController.text;

    print(fechas);
    Navigator.pushNamed(context, 'listaVisitas', arguments: fechas);
                  }
    // } else {
    // mostrarAlerta( context,ffinController.text );
    // }
  }

  void mostrarAlerta(BuildContext context, String mensaje) {
    /*showDialog(
      context: context,
      builder: ( context ) {
        return AlertDialog(
          title: Text('Tesãira'),
          content: Text(mensaje),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: ()=> Navigator.of(context).pop(),
            )
          ],
        );
      }
    );*/

    AppAlertDialog.error(
        context: context,
        tittle: 'Tesãira',
        desc: mensaje,
        btnCancelOnPress: () => print('Modal cerrado'));
  }
}
