import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/datos_vivienda_model.dart';
import 'package:formvalidation/src/widgets/app_alertdialog.dart';

class PacientePrincPage extends StatefulWidget {
  @override
  _PacientePrincPageState createState() => _PacientePrincPageState();
}

class _PacientePrincPageState extends State<PacientePrincPage> {

  String viviendaId;

  @override
  Widget build(BuildContext context) {
   viviendaId = ModalRoute.of(context).settings.arguments;
    final bloc = LocalProvider.visitaBloc(context);

    return Scaffold(
       appBar: _crearAppBar(),
       body: SingleChildScrollView(
          child: _crearPersonasList(bloc, context),
       ),
       floatingActionButton: buildBotonesFlotantes(),
    );
  }

    Widget _crearAppBar(){
    return AppBar(
          title: Text('Personas'),
          centerTitle: true,
          backgroundColor: Colors.green,
          leading: Container(),
      );
  }

  Widget _crearPersonasList(VisitaBloc bloc, context) {
    return StreamBuilder<List<PersonaModel>>(
      stream: bloc.personasStream,
      builder: (BuildContext context, AsyncSnapshot<List<PersonaModel> > snapshot) {
        List<PersonaModel> personas;
        if(snapshot.hasData){
          personas = snapshot.data;
        }

print("Viene de progress_page2.dart, retornar vivienda id ${viviendaId}");
        if ( personas == null ) {
          return Center(
            heightFactor: 3,
            child: Text('Presione el botón + para agregar personas'),
          );
        }

        return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: personas.length,
          itemBuilder: (context, i ) => 
          Dismissible(
            key: UniqueKey(),
            background: Container( color: Colors.green ),
            //onDismissed: ( direction ) => bloc.eliminarProcedimiento(detalleVisita.actividades[i], bloc.detalleVisita.pacienteId),
            child: _crearItem(i, context, personas[i])
          )          
        );


      },
    );
  }

  _crearItem(i, context, PersonaModel persona){
    return ListTile(
              leading: Icon( Icons.accessibility_new, color: Theme.of(context).primaryColor ),
              title: Text( persona.documento ),
              subtitle: Text(persona.nombre + ' ' + persona.apellido),
              trailing: Icon( Icons.delete_sweep, color: Colors.green ),
              onTap: () {},
    );
  }

  Widget crearFAB() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: (){
        Navigator.pushReplacementNamed(context, 'paciente', arguments: viviendaId);
      });
  }

  Widget buildBotonesFlotantes(){
    return SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        children: [
            SpeedDialChild(
              child: Icon(Icons.add, color: Colors.white,),
              backgroundColor: Colors.red,
              label: 'Agregar paciente',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'paciente', arguments: viviendaId);
              }
            ),
            SpeedDialChild(
              child: Icon(Icons.done, color: Colors.white),
              backgroundColor: Colors.blue,
              label: 'Finalizar',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: ()  {
                showMessageSuccess(context);
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.search, color: Colors.white,),
              backgroundColor: Colors.red,
              label: 'Buscar y Agregar paciente',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'buscarAgregarPersona', arguments: viviendaId);
              }
            ),
          ],
      );
  }

  /*insertPersona( context) async{
    //sendData.lat = -25;
    //sendData.lon = -26;
    VisitaProvider visitaProvider = new VisitaProvider();
    mapInsert['vivienda_id'] = int.parse(viviendaId);
    String mensaje = await visitaProvider.crearPaciente(mapInsert);
    if(mensaje == 'ok'){
      showMessageSuccess(context, 'Al presionar ok lo llevará a la pantalla menú');
    } 
  }*/

  void actionInsert(context ){
    Navigator.pushReplacementNamed(context, 'botones');
  }

  void showMessageSuccess(BuildContext context ) {
    AppAlertDialog.success(
      context: context,
      tittle: 'Tesãira', 
      desc: 'Ha finalizado exitosamente, será redirigido al inicio', 
      btnOkOnPress: () => actionInsert(context)
    );
  }
}