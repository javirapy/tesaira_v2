import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/datos_vivienda_model.dart';
import 'package:formvalidation/src/models/insert_visita_model.dart';
import 'package:formvalidation/src/search/search_delegate.dart';
import 'package:formvalidation/src/utils/utils.dart';
import 'package:showcaseview/showcaseview.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  
  int _actividadSeleccionada;
  String _valoracionSeleccionada;
  //List<Actividades> procedimientoPersona;
  String comentario;
  String valor;
  int pacienteId;
  GlobalKey _one = GlobalKey();
  BuildContext myContext;

  /*@override
  void initState() { 
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
            (_) {
          Future.delayed(Duration(milliseconds: 200), () =>
              ShowCaseWidget.of(myContext).startShowCase([_one])
          );
        }
    );
  }*/

  @override
  Widget build(BuildContext context) {
    final bloc = LocalProvider.visitaBloc(context);
    final size = MediaQuery.of(context).size;
    myContext = context;
    pacienteId = ModalRoute.of(context).settings.arguments;
    
    return ShowCaseWidget(
      builder: Builder(
        builder: (context) {
          myContext = context;
          return Scaffold(
              appBar: _crearAppBar(),
              body: _crearResult(bloc, size),
          );
        }
      )
    );
  }

  Widget _crearAppBar(){
    return AppBar(
          
          title: Text('Buscar procedimientos...'),
          centerTitle: false,
          backgroundColor: Colors.green,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: (){
                showSearch(
                  context: context,
                  delegate: DataSearch(),
                  //query: 'Hola'
                  );
              },
            )

            /*Showcase(
              key: _one,
              description: 'Aquí puede buscar los procedimientos',
              disableAnimation: true,
              title: 'Buscar',
              showArrow: false,
              child : IconButton(
              icon: Icon(Icons.search),
              onPressed: (){
                showSearch(
                  context: context,
                  delegate: DataSearch(),
                  //query: 'Hola'
                  );
              },
            )

            )*/
          ],
      );
  }

  Widget _crearResult(VisitaBloc bloc, size){
    if(bloc.procedimiento != null){
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SafeArea(
                child: Container(
                  height: 5.0,
                )
            ),
            dibujarStream(bloc, size)
          ]
        )
    );
    }else{
      return _crearBody(bloc);
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

  Widget _crearBody(VisitaBloc bloc){
    return Stack(
      children : <Widget>[
        Align(
          alignment: Alignment(0, -0.8),
          child: Wrap(
          children: <Widget>[
            Column(
              children: <Widget>[
                Text('Acceso rápido a procedimientos', style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 14,),
                Chip(
                  backgroundColor: Colors.green,
                  label: Text('Curación', style: TextStyle(color: Colors.white, fontSize: 18)),
                  onDeleted: (){
                    Map<String, dynamic> proc = {'id': 3, 'nombre': 'Curación', 'tipos_valore': {'nombre': 'Valoracion'}};
                      print('onntap en el child');
                      if(existeProcedimiento(bloc, proc['id'])){
                        mostrarAlerta(myContext, 'Ya se ha cargado este tipo de procedimiento');
                        return;
                      }

                      bloc.changeProcedimiento(proc);
                      setState(() {  });
                  },
                  deleteIcon: Icon(
                      Icons.local_hospital,
                      color: Colors.white,
                  ),
                ),
                Chip(
                  backgroundColor: Colors.green,
                  label: Text('Vacunación - BCG', style: TextStyle(color: Colors.white, fontSize: 18)),
                  onDeleted: (){
                    Map<String, dynamic> proc = {'id': 4, 'nombre': 'Vacunación - BCG', 'tipos_valore': {'nombre': 'Realizado'}};
                      print('onntap en el child');
                       if(existeProcedimiento(bloc, proc['id'])){
                        mostrarAlerta(myContext, 'Ya se ha cargado este tipo de procedimiento');
                        return;
                      }
                      bloc.changeProcedimiento(proc);
                      setState(() {  });
                  },
                  deleteIcon: Icon(
                      Icons.local_hospital,
                      color: Colors.white,
                  ),
                ),
                Chip(
                  backgroundColor: Colors.green,
                  label: Text('Nivel de Azúcar', style: TextStyle(color: Colors.white, fontSize: 18)),
                  onDeleted: (){
                    Map<String, dynamic> proc = {'id': 2, 'nombre': 'Nivel de Azúcar', 'tipos_valore': {'nombre': 'numeros'}};
                      print('onntap en el child');
                       if(existeProcedimiento(bloc, proc['id'])){
                        mostrarAlerta(myContext, 'Ya se ha cargado este tipo de procedimiento');
                        return;
                      }
                      bloc.changeProcedimiento(proc);
                      setState(() {  });
                  },
                  deleteIcon: Icon(
                      Icons.local_hospital,
                      color: Colors.white,
                  ),
                ),
                Chip(
                  backgroundColor: Colors.green,
                  //padding: EdgeInsets.all(0),
                  label: Text('Tomar Temperatura', style: TextStyle(color: Colors.white, fontSize: 18)),
                  onDeleted: (){
                    Map<String, dynamic> proc = {'id': 5, 'nombre': 'Tomar Temperatura', 'tipos_valore': {'nombre': 'numeros'}};
                      print('onntap en el child');
                      bloc.changeProcedimiento(proc);
                      setState(() {  });
                  },
                  deleteIcon: Icon(
                      Icons.local_hospital,
                      color: Colors.white,
                  ),
                ),
              ],
            )
          ],
      ),
        ),
      ] 
    );
  }

  Widget dibujarStream(bloc, size){
    return StreamBuilder(
                      stream: bloc.procedimientoStream,
                      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot){
                        if(snapshot.hasData){
                          return dibujarView(bloc, size, snapshot.data);
                        }
                        return Container();
                      },
                    ); 
  }

  Widget dibujarView(bloc, size, Map<String, dynamic> data){
    return _dibujarCaja(bloc, size, data);    
  }

  Widget _dibujarCaja(bloc, size, Map<String, dynamic> data){
    return Container(
            padding: EdgeInsets.all( 20.0 ),
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
              children: dibujarProcedimiento(data, bloc)
            ),
    );
  }

  List<Widget> dibujarProcedimiento(Map<String, dynamic> data, VisitaBloc bloc){
    if(data['tipos_valore']['nombre'] == 'Valoracion'){
      return dibujarValoracion(data, bloc);
    }

    if(data['tipos_valore']['nombre'] == 'numeros'){
      return dibujarNumero(data, bloc);
    }

    if(data['tipos_valore']['nombre'] == 'Realizado'){
      return dibujarRealizado(data, bloc);
    }

    if(data['tipos_valore']['nombre'] == 'par-cifras'){
      return dibujarParCifras(data, bloc);
    }
    
    return [];
  }

  List<Widget> dibujarParCifras(Map<String, dynamic> data, VisitaBloc bloc){
    return <Widget>[
      Text('Carga de Actividades ${ data['nombre'] }', style: TextStyle(fontSize: 25.0, color: Colors.green, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
      SizedBox( height: 30.0 ),
      _crearDropDownActividad(),
      SizedBox( height: 10.0 ),
      TextField(
        decoration: InputDecoration(
          hintText: 'Ejemplo:12/10',
          labelText: data['nombre'], 
        ),
        onChanged: (valor){
          this.valor = valor;
          setState(() {
            
          });
        },
      ),
      Divider(),
      TextField(
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: 'Comentario', 
        ),
        onChanged: (valor){
          this.comentario = valor;
          setState(() {});
        },
      ),
       Divider(),
      RaisedButton(
        child: Container(
          padding: EdgeInsets.symmetric( horizontal: 80.0, vertical: 15.0),
          child: Text('Agregar'),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)
        ),
        elevation: 0.0,
        color: Colors.green,
        textColor: Colors.white,
        onPressed: (){
          print('se esta creando el objeto para actividades');
          Actividades actividad = new Actividades();
          actividad.comentario = comentario;
          actividad.procedimientoId = data['id'];
          if(_actividadSeleccionada != null){
            actividad.tipoActividad = _actividadSeleccionada;
          }else{
            mostrarAlerta(myContext, 'Debe seleccionar el Tipo de Actividad');
            return ;
          }
          
          
          if(this.valor != null && this.valor.isNotEmpty ){
            if(isNumeric(this.valor)){
              actividad.valor = this.valor;  
            }else{
              mostrarAlerta(myContext, 'Para el campo ${data['nombre']} solo se permiten números');  
              return;
            }
          }else{
            mostrarAlerta(myContext, 'Debe cargar valor para ${data['nombre']}');
            return ;
          }
          
          actividad.nombreProcedimiento = data['nombre'];
          print('Se creo todo ');
          bloc.agregarProcedimiento(actividad, pacienteId);
          Navigator.pushReplacementNamed(context, 'procedimiento');
        },
      )
    ];
  }

  List<Widget> dibujarNumero(Map<String, dynamic> data, VisitaBloc bloc){
    return <Widget>[
      Text('Carga de Actividades ${ data['nombre'] }', style: TextStyle(fontSize: 25.0, color: Colors.green, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
      SizedBox( height: 30.0 ),
      _crearDropDownActividad(),
      SizedBox( height: 10.0 ),
      TextField(
        decoration: InputDecoration(
          hintText: 'Ejemplo:128',
          labelText: data['nombre'], 
        ),
        onChanged: (valor){
          this.valor = valor;
          setState(() {
            
          });
        },
      ),
      Divider(),
      TextField(
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: 'Comentario', 
        ),
        onChanged: (valor){
          this.comentario = valor;
          setState(() {});
        },
      ),
       Divider(),
      RaisedButton(
        child: Container(
          padding: EdgeInsets.symmetric( horizontal: 80.0, vertical: 15.0),
          child: Text('Agregar'),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)
        ),
        elevation: 0.0,
        color: Colors.green,
        textColor: Colors.white,
        onPressed: (){
          print('se esta creando el objeto para actividades');
          Actividades actividad = new Actividades();
          actividad.comentario = comentario;
          actividad.procedimientoId = data['id'];
          if(_actividadSeleccionada != null){
            actividad.tipoActividad = _actividadSeleccionada;
          }else{
            mostrarAlerta(myContext, 'Debe seleccionar el Tipo de Actividad');
            return ;
          }
          
          
          if(this.valor != null && this.valor.isNotEmpty ){
            if(isNumeric(this.valor)){
              actividad.valor = this.valor;  
            }else{
              mostrarAlerta(myContext, 'Para el campo ${data['nombre']} solo se permiten números');  
              return;
            }
          }else{
            mostrarAlerta(myContext, 'Debe cargar valor para ${data['nombre']}');
            return ;
          }
          
          actividad.nombreProcedimiento = data['nombre'];
          print('Se creo todo ');
          bloc.agregarProcedimiento(actividad, pacienteId);
          Navigator.pushReplacementNamed(context, 'procedimiento');
        },
      )
    ];
  }

  Widget _crearDropDownActividad() {
    return Row(
      children: <Widget>[
        Icon(Icons.done_outline),
        SizedBox(width: 30.0),
        DropdownButton(
          value: _actividadSeleccionada,
          items: getOpcionesActividadDropdown(),
          hint: Text('Seleccione un tipo de Actividad'),
          onChanged: (opt){
            setState(() {
              _actividadSeleccionada = opt;
            });
          },
        )
      ],
    );
  }

  List<DropdownMenuItem<int>> getOpcionesActividadDropdown(){
    //List<Map<String, dynamic>> tipos = new List();//['Deteccion', 'Seguimiento', 'Entrevista'];
    //List<Map<dynamic, String>> tiposd = [{1:"Deteccion"},{2:"Seguimiento"},{3:"Entrevista"}];
    List<OpcionesModel> listaVal = new List();
    
    OpcionesModel op1 = new OpcionesModel(1, 'Deteccion');
    OpcionesModel op2 = new OpcionesModel(2, 'Seguimiento');
    OpcionesModel op3 = new OpcionesModel(3, 'Entrevista');
    
    listaVal..add(op1)
            ..add(op2)
            ..add(op3);

    List<DropdownMenuItem<int>> lista = new List();
    listaVal.forEach( (poder) {
      lista.add(DropdownMenuItem(
        child: Text(poder.descripcion),
        value: poder.id));
    });

    return lista;
  }

  List<DropdownMenuItem<String>> getOpcionesValoracionDropdown(){
    //List<Map<String, dynamic>> tipos = new List();//['Deteccion', 'Seguimiento', 'Entrevista'];
    //List<Map<dynamic, String>> tiposd = [{1:"Deteccion"},{2:"Seguimiento"},{3:"Entrevista"}];
    List<OpcionesModel> listaVal = new List();
    
    OpcionesModel op1 = new OpcionesModel(1, 'Bueno');
    OpcionesModel op2 = new OpcionesModel(2, 'Malo');
    OpcionesModel op3 = new OpcionesModel(3, 'Curado');
    
    listaVal..add(op1)
            ..add(op2)
            ..add(op3);

    List<DropdownMenuItem<String>> lista = new List();
    listaVal.forEach( (poder) {
      lista.add(DropdownMenuItem(
        child: Text(poder.descripcion),
        value: poder.descripcion));
    });

    return lista;
  }

  List<Widget> dibujarRealizado(Map<String, dynamic> data, VisitaBloc bloc){
    return <Widget>[
      Text('Carga de Actividades ${ data['nombre'] }', style: TextStyle(fontSize: 25.0, color: Colors.green, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
      SizedBox( height: 30.0 ),
      _crearDropDownActividad(),
      Divider(),
      TextField(
        //autofocus: true,
        decoration: InputDecoration(
          labelText: 'Comentario', 
        ),
        onChanged: (valor){
          comentario = valor;
          setState(() {});
        },
      ),
       Divider(),
      RaisedButton(
        child: Container(
          padding: EdgeInsets.symmetric( horizontal: 80.0, vertical: 15.0),
          child: Text('Agregar'),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)
        ),
        elevation: 0.0,
        color: Colors.green,
        textColor: Colors.white,
        onPressed: (){
          print('se esta creando el objeto para actividades');
          Actividades actividad = new Actividades();
          actividad.comentario = comentario;
          actividad.procedimientoId = data['id'];
          if(_actividadSeleccionada != null){
            actividad.tipoActividad = _actividadSeleccionada;
          }else{
            mostrarAlerta(myContext, 'Debe seleccionar el Tipo de Actividad');
            return ;
          }
          actividad.valor = '1 Dosis';
          actividad.nombreProcedimiento = data['nombre'];
          print('Se creo todo ${ data['nombre'] }');
          bloc.agregarProcedimiento(actividad, pacienteId);
          //Navigator.pushNamed(context, 'procedimiento');
          Navigator.pushReplacementNamed(context, 'procedimiento');
        },
        //onPressed: () => _buscar(bloc, context)
      )
    ];
  }

  List<Widget> dibujarValoracion(Map<String, dynamic> data, VisitaBloc bloc){
    return <Widget>[
      Text('Carga de Actividades ${ data['nombre'] }', style: TextStyle(fontSize: 25.0, color: Colors.green, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
      SizedBox( height: 30.0 ),
      _crearDropDownActividad(),
      SizedBox( height: 10.0 ),
      _crearDropDownValoracion(),
      Divider(),
      TextField(
        //autofocus: true,
        decoration: InputDecoration(
          labelText: 'Comentario', 
        ),
        onChanged: (valor){
          comentario = valor;
          setState(() {});
        },
      ),
       Divider(),
       SizedBox( height: 50.0 ),
      RaisedButton(
        child: Container(
          padding: EdgeInsets.symmetric( horizontal: 80.0, vertical: 15.0),
          child: Text('Agregar'),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)
        ),
        elevation: 0.0,
        color: Colors.green,
        textColor: Colors.white,
        onPressed: (){
          print('se esta creando el objeto para actividades');
          Actividades actividad = new Actividades();
          actividad.comentario = comentario;
          actividad.procedimientoId = data['id'];

         if(_actividadSeleccionada != null){
            actividad.tipoActividad = _actividadSeleccionada;
          }else{
            mostrarAlerta(myContext, 'Debe seleccionar el Tipo de Actividad');
            return ;
          }

          if(_valoracionSeleccionada != null){
            actividad.valor = _valoracionSeleccionada;
          }else{
            mostrarAlerta(myContext, 'Debe seleccionar una Valoración');
            return ;
          }
          
          actividad.valor = _valoracionSeleccionada;
          actividad.nombreProcedimiento = data['nombre'];
          print('Se creo todo ${ data['nombre'] }');
          //bloc.changeDetalleVisita(actividad);
          bloc.agregarProcedimiento(actividad, pacienteId);
          Navigator.pushReplacementNamed(context, 'procedimiento');
        },
        //onPressed: () => _buscar(bloc, context)
      )
    ];
  }

  Widget _crearDropDownValoracion() {
    return Row(
      children: <Widget>[
        Icon(Icons.done_outline),
        SizedBox(width: 30.0),
        DropdownButton(
          value: _valoracionSeleccionada,
          items: getOpcionesValoracionDropdown(),
          hint: Text('Seleccione una Valoracion'),
          onChanged: (opt){
            setState(() {
              _valoracionSeleccionada = opt;
            });
          },
        )
      ],
    );
  }

  Widget _procedimientoTarjeta(Actividades actividad, context){
    return Card(
        elevation: 1.0,
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(actividad.procedimientoId.toString()),
              //subtitle: Text(persona.nombre + ' ' +persona.apellido),
              trailing: GestureDetector(
                child:Icon(Icons.delete_sweep, color: Colors.green),
                onTap: (){
                  Navigator.pushNamed(context, 'busqueda');
                }),
            )
          ],
        ),
      );
  }

  Widget _crearProcedimientoListView(VisitaBloc bloc, context) {

    return StreamBuilder<DetallesVisitas>(
      stream: bloc.detalleVisitaStream,
      builder: (BuildContext context, AsyncSnapshot<DetallesVisitas > snapshot) {
        DetallesVisitas detalleVisita = snapshot.data;

        if ( detalleVisita == null ) {
          return Center(
            child: Text('No hay información'),
          );
        }else{
          return Center(
            child: Text('Dibujemos esto'),
          );
        }

        

        return ListView.builder(
          itemCount: detalleVisita.actividades.length,
          itemBuilder: (context, i ) => _crearItem(context)//Dismissible(
            
        );


      },
    );
  }

  _crearItem(context){
    return ListTile(
              leading: Icon( Icons.map, color: Theme.of(context).primaryColor ),
              title: Text( 'cualquier texto'/*detalleVisita.actividades[i].comentario*/ ),
              //subtitle: Text('ID: ${ scans[i].id }'),
              trailing: Icon( Icons.keyboard_arrow_right, color: Colors.grey ),
              onTap: () {},
    );
  }
}