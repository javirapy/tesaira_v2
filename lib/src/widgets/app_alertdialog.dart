import 'package:flutter/material.dart';

import 'package:awesome_dialog/awesome_dialog.dart';


class AppAlertDialog  {


  final DialogType dialogType;
  final String tittle;
  final String desc;
  final BuildContext context;

  String btnOkText;
  IconData btnOkIcon;
  Function btnOkOnPress;
  Color btnOkColor;

  String btnCancelText;
  IconData btnCancelIcon;
  Function btnCancelOnPress;
  Color btnCancelColor;
  

  AppAlertDialog.success({
    @required this.context,
    @required this.tittle,
    @required this.desc,
    this.dialogType = DialogType.SUCCES, 
    this.btnOkText = 'OK',
    this.btnOkIcon = Icons.check_circle,
    this.btnOkOnPress,
    this.btnOkColor,
  }){
    AppAlertDialog._(
      context: context,
      tittle: tittle,
      desc: desc,
      dialogType: dialogType,
      btnOkText: btnOkText,
      btnOkIcon: btnOkIcon,
      btnOkOnPress: btnOkOnPress,
      btnOkColor: btnOkColor
    );
  }

  /// Si se define la acción para Ok y para Cancel, se debe establecer los textos que estos deben llevar
  AppAlertDialog.warning({
    @required this.context,
    this.dialogType = DialogType.WARNING,
    @required this.tittle,
    @required this.desc,

    this.btnOkText = 'OK',
    this.btnOkIcon = Icons.check_circle,
    this.btnOkOnPress,
    this.btnOkColor,

    this.btnCancelText = 'Cancelar',
    this.btnCancelIcon = Icons.cancel,
    this.btnCancelOnPress,
    this.btnCancelColor,
  }){
    AppAlertDialog._(
      context: context,
      tittle:tittle,
      desc:desc,
      btnOkText:btnOkText,
      btnOkIcon:btnOkIcon,
      btnOkOnPress:btnOkOnPress,
      btnOkColor:btnOkColor,
      btnCancelText:btnCancelText,
      btnCancelIcon:btnCancelIcon,
      btnCancelOnPress:btnCancelOnPress,
      btnCancelColor:btnCancelColor
    );
  }

  AppAlertDialog.error({
    @required this.context,
    @required this.tittle,
    @required this.desc,
    this.dialogType = DialogType.ERROR,
    this.btnCancelText = 'Cerrar',
    this.btnCancelIcon = Icons.close,
    this.btnCancelOnPress,
  }){
    AppAlertDialog._(
      context: context,
      tittle: tittle,
      desc: desc,
      dialogType: dialogType,
      btnCancelText: btnCancelText,
      btnCancelIcon: btnCancelIcon,
      btnCancelOnPress: btnCancelOnPress
    );
  }
  

  
  AppAlertDialog._({
      @required this.context,
      this.dialogType,
      this.tittle,
      this.desc,
      this.btnOkText,
      this.btnOkIcon,
      this.btnOkOnPress,
      this.btnOkColor,
      this.btnCancelText,
      this.btnCancelIcon,
      this.btnCancelOnPress,
      this.btnCancelColor,
      }){
        AwesomeDialog(
          context: context,
          dialogType : dialogType,
          title : tittle,
          desc : desc,
          btnOkText : btnOkText,
          btnOkIcon : btnOkIcon,
          btnOkOnPress : btnOkOnPress,
          btnOkColor : btnOkColor,
          btnCancelText : btnCancelText,
          btnCancelIcon : btnCancelIcon,
          btnCancelOnPress : btnCancelOnPress,
          useRootNavigator: true,
          btnCancelColor : btnCancelColor,
          headerAnimationLoop: true,
          dismissOnTouchOutside: false,
          isDense: false
        ).show();
      }
 
  

}