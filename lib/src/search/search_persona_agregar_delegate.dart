import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/datos_vivienda_model.dart';
import 'package:formvalidation/src/providers/visita_provider.dart';
import 'package:formvalidation/src/utils/utils.dart';

class DataPersonaAgregarSearch extends SearchDelegate {
  Map<String, dynamic> seleccion;
  BuildContext contextClass;
           final visitaProvider = new VisitaProvider();


  @override
  List<Widget> buildActions(BuildContext context) {
    // las acciones de nuestro appbar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
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
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
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


    if (query != null && query.isNotEmpty) {
      bloc.buscarPersona(query);

      return StreamBuilder(
        stream: bloc.listPersonasStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            final productos = snapshot.data;

            return ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, i) =>
                  _crearItem(context, productos[i], bloc),
            );
          } else {
            return Container(); //Center( child: CircularProgressIndicator());
          }
        },
      );
    } else {
      return Container();
    }
  }

  bool existeProcedimiento(VisitaBloc bloc, int idProcedimiento) {
    if (bloc.detalleVisita?.actividades != null) {
      for (var item in bloc.detalleVisita.actividades) {
        if (item.procedimientoId.compareTo(idProcedimiento) == 0) {
          return true;
        }
      }
    }
    return false;
  }

  _crearItem(context, Map<String, dynamic> item, VisitaBloc bloc) {
        Color vinculo;
    if (item['indicador_vivienda'] == 0) {
               vinculo = Colors.red;
              } else {
                 vinculo = Colors.green;
              }
    return ListTile(
      tileColor: Colors.white,
      focusColor: Colors.green,
      // title: Text(item['numero_documento'] + ' ' + item['nombre'] + ' ' + item['apellido']),
      title: Container(
          child: Row(
        children: [
          Icon(Icons.people, color: Colors.green,),
          SizedBox(width: 5,),
          Text('N° Documento: ' + item['numero_documento'] + ' - ',
              style: TextStyle(color: Colors.black)),
          SizedBox(width: 5),
          Text(item['sexo'] == 'M' ? '(MASCULINO)' : '(FEMENINO)',
              style: TextStyle(color: Colors.deepOrange)),
        ],
      )),
      subtitle:Column(children: [
         Row(
        children: [
          SizedBox(width: 30),
          Text(item['nombre']+ ' ' + item['apellido'] ,
              style: TextStyle(color: Colors.black)),

        ],
      ),
       Text(item['indicador_vivienda'] == 0 ? '(No Vinculado a ninguna vivienda)' : '(Vinculado a vivienda)',
              style: TextStyle(color:vinculo)),
      
      Text('_____________________________________________', style: TextStyle(color: Colors.green)),
      ],) ,
      onTap: () {
    //    seleccion = item;
       var cedula=item['numero_documento'];
         _buscar(cedula, context);
       // bloc.changeProcedimiento(seleccion);
        //showResults(context);
      //  this.close(context, this.query);
      },
    );

  }
 _buscar(String cedula, BuildContext context) async {
    final bloc = LocalProvider.visitaBloc(context);

   // FocusScope.of(context).unfocus();

    await bloc.eliminarTodo();
    DatosViviendaModel info = await visitaProvider.buscarPaciente(cedula);
 

    if ( info != null ) {
      info.documentoBuscado = cedula;
   info.fromView = 'BUSCARPERSONA';
      Navigator.pushNamed(context, 'viviendapersona', arguments: info);

    } else {
      mostrarAlerta( context, 'No existe el documento buscado' );
    }
  }
  
}
 