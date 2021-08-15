import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/datos_censo.dart';


class Page1 extends StatefulWidget {

  final Future future;
  //final DatosCensoInsert insert;

  Page1({Key key, this.future}): super(key: key);

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {

  //DatosCensoInsert insert = new DatosCensoInsert();
  final formKey     = GlobalKey<FormState>();
  static const String DESCRIPCION = 'descripcion';
  static const String NOMBRE = 'nombre';
  Map<String, dynamic> mapInsert = new Map<String, dynamic>();
  
  @override
  Widget build(BuildContext context) {
    final bloc = LocalProvider.visitaBloc(context);
    return FutureBuilder<DatosCensoModel>(
      future: null, //bloc.getDatosCenso(),
      builder: (BuildContext context, AsyncSnapshot<DatosCensoModel> snapshot) {
        print('ENtra en el builder');
        print('Entra al build ');
        if ( snapshot.hasData ) {
          print('tiene data el snapshot');
          final datos = snapshot.data;
          return  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Form(
                          key: formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                _item(etiqueta: 'Microterritorio', property: 'microterritorio_id', atributo: mapInsert, listaValor: datos.microterritorios, valorTomar: DESCRIPCION),
                                _item(etiqueta: 'Barrio/compañía', property: 'barrios_compania_id', atributo: mapInsert, listaValor: datos.barriosCompanias, valorTomar: NOMBRE),
                                _item(etiqueta: 'Área', property:'area', atributo: mapInsert, listaValor: generarListaArea(), valorTomar: DESCRIPCION),
                                SizedBox( height: 35.0, width: double.infinity ),
                                _crearInput(etiqueta:'Nro. Casa', property:'numero_casa', atributo:mapInsert),
                                _crearInput(etiqueta:'Dirección', property:'direccion', atributo:mapInsert),
                                _crearInput(etiqueta:'Referencia', property:'referencia', atributo:mapInsert),
                                SizedBox( height: 35.0, width: double.infinity ),
                                _item(etiqueta: 'Propiedad de la vivienda', property: 'pertenencia_vivienda_id', atributo: mapInsert, listaValor: datos.pertenenciaViviendas, valorTomar: DESCRIPCION),
                                _item(etiqueta: 'Pared', property:'tipos_parede_id', atributo: mapInsert, listaValor: datos.tiposParedes, valorTomar: NOMBRE),
                                _item(etiqueta: 'Techo', property:'tipos_techo_id', atributo: mapInsert, listaValor: datos.tiposTechos, valorTomar: NOMBRE),
                                _item(etiqueta: 'Piso', property:'tipos_piso_id', atributo: mapInsert, listaValor: datos.tiposPisos, valorTomar: NOMBRE),
                                SizedBox( height: 35.0, width: double.infinity ),
                                _item(etiqueta: 'Hacinamiento', property:'hacinamiento', atributo: mapInsert, listaValor: generarListaBoolean(), valorTomar: DESCRIPCION),
                                _item(etiqueta: 'Aguateria', property:'aguateria_id', atributo: mapInsert, listaValor: datos.aguaterias, valorTomar: NOMBRE),
                                _item(etiqueta: 'Desague baño', property:'tipos_desague_banio_id', atributo: mapInsert, listaValor: datos.tiposDesagueBanios, valorTomar: NOMBRE),
                                _item(etiqueta: 'Tipo baño', property:'tipos_banio_id', atributo: mapInsert, listaValor: datos.tiposBanios, valorTomar: NOMBRE),
                                SizedBox( height: 35.0, width: double.infinity ),
                                _item(etiqueta: 'Luz electrica', property:'luz_electrica', atributo: mapInsert, listaValor: generarListaBoolean(), valorTomar: DESCRIPCION),
                                _item(etiqueta: 'Telefono Linea baja', property:'telefono_linea_baja', atributo: mapInsert, listaValor: generarListaBoolean(), valorTomar: DESCRIPCION),
                                _item(etiqueta: 'Telefono Celular', property:'telefono_celular', atributo: mapInsert, listaValor: generarListaBoolean(), valorTomar: DESCRIPCION),
                                _item(etiqueta: 'Heladera', property:'heladera', atributo: mapInsert, listaValor: generarListaBoolean(), valorTomar: DESCRIPCION),
                                _item(etiqueta: 'TV', property:'tv', atributo: mapInsert, listaValor: generarListaBoolean(), valorTomar: DESCRIPCION),
                                SizedBox( height: 35.0, width: double.infinity ),
                                _item(etiqueta: 'Automovil', property:'automovil', atributo: mapInsert, listaValor: generarListaBoolean(), valorTomar: DESCRIPCION),
                                _item(etiqueta: 'Motocicleta', property:'motocicleta', atributo: mapInsert, listaValor: generarListaBoolean(), valorTomar: DESCRIPCION),
                                _item(etiqueta: 'Taxi', property:'taxi', atributo: mapInsert, listaValor: generarListaBoolean(), valorTomar: DESCRIPCION),
                                _item(etiqueta: 'Transporte Publico', property:'transporte_publico', atributo: mapInsert, listaValor: generarListaBoolean(), valorTomar: DESCRIPCION),
                                _item(etiqueta: 'Carreta', property:'carreta', atributo: mapInsert, listaValor: generarListaBoolean(), valorTomar: DESCRIPCION),
                                _item(etiqueta: 'Caballo', property:'caballo', atributo: mapInsert, listaValor: generarListaBoolean(), valorTomar: DESCRIPCION),
                                SizedBox( height: 35.0, width: double.infinity ),
                                _item(etiqueta: 'Seguro Publico', property:'seguro_publico', atributo: mapInsert, listaValor: generarListaBoolean(), valorTomar: DESCRIPCION),
                                _item(etiqueta: 'Seguro Privado', property:'seguro_privado ', atributo: mapInsert, listaValor: generarListaBoolean(), valorTomar: DESCRIPCION),
                                _item(etiqueta: 'Farmacia', property:'farmacia', atributo: mapInsert, listaValor: generarListaBoolean(), valorTomar: DESCRIPCION),
                                _item(etiqueta: 'Medico Naturalista', property:'medico_naturalista', atributo: mapInsert, listaValor: generarListaBoolean(), valorTomar: DESCRIPCION)
                                //_crearBoton(mapInsert),
                                //Expanded(child: Text('.')),
                                //_crearAcciones()
                              ],
                            ),
                          ),
                    ),
            )
          ;
        }else{
          return Center();
        }
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

  //valorTomar: si va a ser la descripcion o name
  //atributo: en el campo que quiero setear para luego mandar en el insert
  //etiqueta es el label del combo nomas
  Widget _item({@required String etiqueta, @required String property, @required Map<String, dynamic> atributo, @required List<ItemModel> listaValor, @required valorTomar}) {
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
                        value: value.id,
                        child: new Text(valorTomar == DESCRIPCION ? value.descripcion : value.nombre),
                      );
                    }).toList()
                  ),
                )
              );

        }
    );
  }

  Widget _crearBoton( insert) {

    return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric( horizontal: 80.0, vertical: 15.0),
            child: Text('Ingresar'),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)
          ),
          elevation: 0.0,
          color: Colors.green,
          textColor: Colors.white,
          onPressed: (){
            print('El valor del micro ${insert['microterritorio_id']}');
          }
        );
  }

  Widget _crearAcciones(){
     return ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton.icon(
                onPressed: (){} ,//state.nextPage,
                label: Text('Start Quiz!'),
                icon: Icon(Icons.poll),
                color: Colors.green,
              )
            ],
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