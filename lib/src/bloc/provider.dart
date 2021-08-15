import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/login_bloc.dart';
import 'package:formvalidation/src/bloc/visita_bloc.dart';
export 'package:formvalidation/src/bloc/login_bloc.dart';
export 'package:formvalidation/src/bloc/visita_bloc.dart';

class LocalProvider extends InheritedWidget {

//esto es un singleton
  static LocalProvider _instancia;
  final loginBloc = LoginBloc();
  final _visitaBloc = VisitaBloc();
  
  factory LocalProvider({ Key key, Widget child }) {
    if ( _instancia == null ) {
      _instancia = new LocalProvider._internal(key: key, child: child );
    }
    return _instancia;
  }

  LocalProvider._internal({ Key key, Widget child })
    : super(key: key, child: child );


  

  // Provider({ Key key, Widget child })
  //   : super(key: key, child: child );

 
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of ( BuildContext context ) {
    return  context.dependOnInheritedWidgetOfExactType<LocalProvider>().loginBloc;
  }

  static VisitaBloc visitaBloc ( BuildContext context ) {
    return  context.dependOnInheritedWidgetOfExactType<LocalProvider>()._visitaBloc;
  }

}