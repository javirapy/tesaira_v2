import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/utils/utils.dart';

class DataSearch extends SearchDelegate {

  Map<String, dynamic> seleccion;
  BuildContext contextClass;

  @override
  List<Widget> buildActions(BuildContext context) {
    // las acciones de nuestro appbar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // icono a la izquiera del appbar
    
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // crea los resultados que vamos a mostrar
    contextClass = context;
    return Container();
    
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final bloc = LocalProvider.visitaBloc(context);

    if(query != null && query.isNotEmpty){
      bloc.buscarProcedimiento(query);
    
      return StreamBuilder(
        stream: bloc.listProcedimientoStream,
        builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot){
          
          if ( snapshot.hasData ) {

            final productos = snapshot.data;

            return ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, i) => _crearItem(context, productos[i] , bloc),
            );

          } else {
            return Container();//Center( child: CircularProgressIndicator());
          }
        },
      );
    }else{
      return Container();
    }
    
    
  }

  bool existeProcedimiento(VisitaBloc bloc, int idProcedimiento){
   if(bloc.detalleVisita?.actividades != null){
      for (var item in bloc.detalleVisita.actividades) {
        if(item.procedimientoId.compareTo(idProcedimiento) == 0) {
          return true;
        }
      }
   }
    return false;
  }

  _crearItem(context, Map<String, dynamic> item, VisitaBloc bloc){
    return ListTile(
      title: Text(item['nombre']),
      onTap: (){
        if(existeProcedimiento(bloc, item['id'])){
          mostrarAlerta(context, 'Ya se cargado este tipo de procedimiento');
          return;
        }
        seleccion = item;
        bloc.changeProcedimiento(seleccion);
        //showResults(context);
        this.close(context, this.query);
      },
    );
  }



}