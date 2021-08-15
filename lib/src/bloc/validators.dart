import 'dart:async';



class Validators {


  final validarEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: ( email, sink ) {
      sink.add( email );

      /*Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp   = new RegExp(pattern);

      if ( regExp.hasMatch( email ) ) {
        sink.add( email );
      } else {
        sink.addError('Email no es correcto');
      }*/

    }
  );


  final validarPassword = StreamTransformer<String, String>.fromHandlers(
    handleData: ( password, sink ) {
      if ( password.length >= 3 ) {
        sink.add( password );
      } else {
        sink.addError('Más de 3 caracteres por favor');
      }
    }
  );

  final validarCedula = StreamTransformer<String, String>.fromHandlers(
    handleData: ( cedula, sink ) {
      if ( cedula.length >= 3 ) {
        sink.add( cedula );
      } else {
        sink.addError('Más de 5 caracteres por favor');
      }
    }
  );

}

