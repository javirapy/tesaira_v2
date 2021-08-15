import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/datos_censo.dart';

class Methods {
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


class PageSlide1 extends StatefulWidget {
  
  final DatosCensoModel datosCenso;

  const PageSlide1({
    Key key,
    this.datosCenso,
  }) : super(key: key);

  
  @override
  _PageSlide1State createState() => _PageSlide1State();

}

class _PageSlide1State extends State<PageSlide1> with Methods {

  static const String DESCRIPCION = 'descripcion';
  static const String NOMBRE = 'nombre';  


  @override
  Widget build(BuildContext context) {
    return  Container(
      
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

 
}