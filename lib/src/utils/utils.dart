import 'package:flutter/material.dart';
import 'package:formvalidation/src/widgets/app_alertdialog.dart';

bool isNumeric( String s ) {

  if ( s.isEmpty ) return false;

  final n = num.tryParse(s);

  return ( n == null ) ? false : true;

}


void mostrarAlerta(BuildContext context, String mensaje ) {
  AppAlertDialog.error(
    context: context,
    tittle: 'Tesãira',
    desc: mensaje,
    btnCancelOnPress: () => print('Modal cerrado')
  );
}