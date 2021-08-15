import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/datos_vivienda_model.dart';
import 'package:formvalidation/src/models/insert_visita_model.dart';
//import 'package:geolocation/geolocation.dart';

class ProcedimientoPage extends StatefulWidget {
  @override
  _ProcedimientoPageState createState() => _ProcedimientoPageState();
}

class _ProcedimientoPageState extends State<ProcedimientoPage> {
  
  DatosViviendaModel dataToSend;

  @override
  Widget build(BuildContext context) {
    final bloc = LocalProvider.visitaBloc(context);

    return Scaffold(
      appBar: _crearAppBar(bloc, context),
      body: SingleChildScrollView(
          child: _crearProcedimientoListView(bloc, context)
      ),
      floatingActionButton: buildBotonesFlotantes(bloc),
    );
  }

  Widget buildBotonesFlotantes(VisitaBloc bloc){
    return SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        children: [
            SpeedDialChild(
              child: Icon(Icons.add, color: Colors.white,),
              backgroundColor: Colors.red,
              label: 'Agregar procedimiento',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                bloc.changeProcedimiento(null);
                Navigator.pushNamed(context, 'busqueda', arguments: bloc.detalleVisita.pacienteId);
              }
            ),
            SpeedDialChild(
              child: Icon(Icons.cancel
              , color: Colors.white),
              backgroundColor: Colors.orange,
              label: 'Cancelar',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                bloc.eliminarProcedimiento(null, bloc.detalleVisita.pacienteId);
                bloc.detalleVisita.actividades = null;
                //esto hago para que al entrar a cargar procedimientos, no salga de que ya tiene cargado el usuario
                DetallesVisitas nuevoDetalle = DetallesVisitas();
                nuevoDetalle.pacienteId = bloc.detalleVisita.pacienteId;
                bloc.changeDetalleVisita(nuevoDetalle);
                bloc.changeProcedimiento(null);
                Navigator.pop(context);
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.done, color: Colors.white),
              backgroundColor: Colors.blue,
              label: 'Finalizar',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: ()  {
                obtenerParametrosDatosVivienda(bloc, context);
                DetallesVisitas nuevoDetalle = DetallesVisitas();
                nuevoDetalle.pacienteId = bloc.detalleVisita.pacienteId;
                bloc.changeDetalleVisita(nuevoDetalle);
                bloc.changeProcedimiento(null);
              },
            ),
          ],
      );
  }

  Widget _crearAppBar(VisitaBloc bloc, context){
    return AppBar(
          title: Text('Procedimientos'),
          centerTitle: true,
          backgroundColor: Colors.green,
          leading: Container(),
      );
  }

 obtenerParametrosDatosVivienda(VisitaBloc bloc, context) async{
    await bloc.obtenerDatosVivienda().then( (result){
        result.fromView = 'PROCEDIMIENTO';
        Navigator.pushReplacementNamed(context, 'vivienda', arguments: result);
    } );
    
  }

  

  Widget _crearProcedimientoListView(VisitaBloc bloc, context) {
    return StreamBuilder<DetallesVisitas>(
      stream: bloc.detalleVisitaStream,
      builder: (BuildContext context, AsyncSnapshot<DetallesVisitas > snapshot) {
        DetallesVisitas detalleVisita;
        if(snapshot.hasData){
          detalleVisita = snapshot.data;
        }


        if ( detalleVisita?.actividades == null ) {
          return Center(
            child: Text('No hay información'),
          );
        }

        return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: detalleVisita.actividades.length,
          itemBuilder: (context, i ) => 
          Dismissible(
            key: UniqueKey(),
            background: Container( color: Colors.green ),
            onDismissed: ( direction ) => bloc.eliminarProcedimiento(detalleVisita.actividades[i], bloc.detalleVisita.pacienteId),
            child: _crearItem(i, context, detalleVisita)
          )          
        );


      },
    );
  }

  _crearItem(i, context, DetallesVisitas detalleVisita){
    final comentario = detalleVisita.actividades[i].comentario == null || detalleVisita.actividades[i].comentario == "" ? 'Sin comentarios' : detalleVisita.actividades[i].comentario  ;
    final textSub = 'Valor: ' + detalleVisita.actividades[i].valor + '\n' + comentario;

    return ListTile(
              leading: Icon( Icons.accessibility_new, color: Theme.of(context).primaryColor ),
              title: Text( detalleVisita.actividades[i].nombreProcedimiento ),
              subtitle: Text(textSub),
              trailing: Icon( Icons.delete_sweep, color: Colors.green ),
              onTap: () {},
    );
  }
}

