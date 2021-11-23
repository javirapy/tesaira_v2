import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/datos_vivienda_model.dart';
import 'package:formvalidation/src/providers/visita_provider.dart';
import 'package:formvalidation/src/widgets/app_alertdialog.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


//en esta pagina se carga la ci de la persona al cual se quiere visitar
class BuscarAgregarPersonaPage extends StatefulWidget {
  
  @override
  _BuscarAgregarPersonaPageState createState() => _BuscarAgregarPersonaPageState();
}

class _BuscarAgregarPersonaPageState extends State<BuscarAgregarPersonaPage> {
  
  final visitaProvider = new VisitaProvider();
  bool _wating = false;
    String viviendaId;
  
  @override
  Widget build(BuildContext context) {
    viviendaId = ModalRoute.of(context).settings.arguments;
print(viviendaId);
    final spinner = SpinKitWave(
        color: Colors.green,
        size: 50.0,
    );

    return Scaffold(
      appBar: _crearAppBar(context),
      body: ModalProgressHUD(
        inAsyncCall: _wating,
        opacity: 0.5,
        progressIndicator: spinner,
        child: _form(context)
        ),
    );
  }

  Widget _crearAppBar(context){
    return AppBar(
        title: Text('Ingrese cedula a buscar', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {

            Navigator.pushReplacementNamed(context, 'pacientePrinc', arguments: viviendaId);
          } 
        ),
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
            padding: EdgeInsets.symmetric( vertical: 50.0 ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0
                )
              ]
            ),
            child: Column(
              children: <Widget>[
                Text('Buscar Paciente a Agregar', style: TextStyle(fontSize: 20.0)),
                SizedBox( height: 60.0 ),
                _crearCedula(bloc),
                SizedBox( height: 30.0 ),
                _crearBoton( bloc )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearCedula(VisitaBloc bloc) {
      return StreamBuilder(
        stream: bloc.cedulaStream,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Ingrese Nro. Cedula a Buscar',
                errorText: snapshot.error
              ),
              onChanged: bloc.changeCedula,
            ),

          );

        },
      );
  }

  Widget _crearBoton( VisitaBloc bloc) {       
      return RaisedButton(
        child: Container(
          padding: EdgeInsets.symmetric( horizontal: 80.0, vertical: 15.0),
          child: Text('Buscar'),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)
        ),
        elevation: 0.0,
        color: Colors.green,
        textColor: Colors.white,
        onPressed: () => _buscar(bloc, context)
      );
      
  }

  _buscar(VisitaBloc bloc, BuildContext context) async {
    FocusScope.of(context).unfocus();
    setState(() {
      _wating = true;
    });
    await bloc.eliminarTodo();
    Persona2Model info = await visitaProvider.buscarPaciente2(bloc.cedula);
    setState(() {
      _wating = false;
    });
print("Info: ${info.persona.length}");
    if ( info.persona.length > 0 ) {
      info.documentoBuscado = bloc.cedula;
      info.fromView = 'BUSCARPERSONA';
      info.viviendaId=viviendaId;
      //Navigator.pushNamed(context, 'viviendapersona', arguments: info);
      Navigator.pushNamed(context, 'pacienteBuscarAgregar', arguments: info);
    } else {
      mostrarAlerta( context, 'No existe el documento buscado' );
    }
  }

  void mostrarAlerta(BuildContext context, String mensaje ) {
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
      tittle: 'Tesãira2',
      desc: mensaje,
      btnCancelOnPress: () => print('Modal cerrado')
    );
  }
}