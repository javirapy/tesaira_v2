import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/providers/usuario_provider.dart';

import 'package:formvalidation/src/utils/utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  final usuarioProvider = new UsuarioProvider();
  bool _wating = false;
  bool _claveVisible = true;

   

  @override
  Widget build(BuildContext context) {
    final spinner = SpinKitWave(
        color: Colors.green,
        size: 50.0,
    );


    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _wating,
        opacity: 0.5,
        progressIndicator: spinner,
        child: Stack(
          children: <Widget>[
            _crearFondo( context ),
            _loginForm( context ),
          ],
        ),
      )
    );
  }

  Widget _loginForm(BuildContext context) {

    final bloc = LocalProvider.of(context);
    final size = MediaQuery.of(context).size;
    

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[

          SafeArea(
            child: Container(
              height: 180.0,
            ),
          ),

          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric( vertical: 50.0 ),
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
              children: <Widget>[
                Text('Ingreso', style: TextStyle(fontSize: 20.0)),
                SizedBox( height: 60.0 ),
                _crearUsuario( bloc ),
                SizedBox( height: 30.0 ),
                _crearPassword( bloc ),
                SizedBox( height: 30.0 ),
                _crearBoton( bloc )
              ],
            ),
          ),
          SizedBox( height: 100.0 )
        ],
      ),
    );


  }

  Widget _crearUsuario(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            icon: Icon( Icons.person, color: Colors.green ),
            hintText: 'Usuario',
            labelText: 'Usuario',
            //counterText: snapshot.data,
            //errorText: snapshot.error
          ),
          onChanged: bloc.changeEmail,
        ),
      );
      },
    );
  }

  Widget _crearPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: _claveVisible,
            decoration: InputDecoration(
              icon: Icon( Icons.lock_outline, color: Colors.green ),
              labelText: 'Contraseña',
              //counterText: snapshot.data,
              errorText: snapshot.error,
              suffixIcon: IconButton(
                      color: Colors.green,
                      icon: Icon(
                            _claveVisible 
                        ? Icons.visibility
                        : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _claveVisible = !_claveVisible;
                        });
                      }
                     )
            ),
            onChanged: bloc.changePassword,
          ),

        );

      },
    );
  }

  /*return StreamBuilder<String>(
      stream: widget.stream,
      builder: (context, snapshot) {
        return TextField(
          readOnly: widget.readOnly,
          controller: controller,
          keyboardType: widget.keyboardType,
          textCapitalization: widget.textCapitalization,
          obscureText: widget.isPassword && _claveVisible,
          decoration: InputDecoration(
            labelText: _label,
            hintText: _hint,
            labelStyle: _labelStyle,
            hintStyle: _hintStyle,
            enabledBorder: _borderText,
            errorText: snapshot.error,
            errorBorder: _borderErr,
            errorStyle: TextStyle(color: Colors.redAccent.shade100),
            suffixIcon: widget.isPassword ? _passwIcon() : widget.suffixIcon,
          ),
          style: _inputStyle,
          onChanged: widget.onChange,
        );
      }
    );*/

  Widget _crearBoton( LoginBloc bloc) {

    // formValidStream
    // snapshot.hasData
    //  true ? algo si true : algo si false

    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
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
            onPressed: snapshot.hasData ? ()=> _login(bloc, context) : null
          );
      },
    );
  }

  _login(LoginBloc bloc, BuildContext context) async {
    FocusScope.of(context).unfocus();
    setState(() {
      _wating = true;
    });
    Map info = await usuarioProvider.login(bloc.email, bloc.password);
    setState(() {
      _wating = false;
    });
    if ( info['ok'] ) {
      //pushReplacementNamed hace que se borre la pila de actividades y esa sea la raiz(tal como android)
       Navigator.pushReplacementNamed(context, 'botones');
       //Navigator.pushReplacementNamed(context, 'homeTap');
    } else {
      mostrarAlerta( context, info['message'] );
    }
    
  }

  Widget _crearFondo(BuildContext context) {

    final size = MediaQuery.of(context).size;

    final fondoModaro = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color.fromRGBO(8, 147, 51, 1.0)
        /*gradient: LinearGradient(
          colors: <Color> [
            Color.fromRGBO(8, 147, 51, 1.0),
            Color.fromRGBO(51, 255, 178, 2.0)
          ]
        )*/
      ),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.05)
      ),
    );


    return Stack(
      children: <Widget>[
        fondoModaro,
        Positioned( top: 90.0, left: 30.0, child: circulo ),
        Positioned( top: -40.0, right: -30.0, child: circulo ),
        Positioned( bottom: -50.0, right: -10.0, child: circulo ),
        Positioned( bottom: 120.0, right: 20.0, child: circulo ),
        Positioned( bottom: -50.0, left: -20.0, child: circulo ),
        
        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: <Widget>[
              Icon( Icons.person_pin_circle, color: Colors.white, size: 100.0 ),
              SizedBox( height: 10.0, width: double.infinity ),
              Text('Tesãira', style: TextStyle( color: Colors.white, fontSize: 25.0 ))
            ],
          ),
        )

      ],
    );

  }
}



/*

import 'package:cdapagos_flutter/src/blocs/validators/validators.dart';
import 'package:flutter/material.dart';


import 'package:cdapagos_flutter/src/utils/constantes.dart' as constantes;

class AppTextField extends StatefulWidget {

  final Stream<String>  stream;
  final String label;
  final String hint;
  final bool   readOnly;
  //final TextEditingController controller;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final bool isPassword;
  final Widget suffixIcon;
  final Function(String) onChange;
  final AppStyleTextField styleColor;
  final String initialValue;

  AppTextField({Key key, @required this.stream, this.label, this.readOnly = false,
                /*this.controller,*/ this.isPassword = false,
                this.keyboardType = TextInputType.text, this.suffixIcon, @required this.onChange,
                this.textCapitalization = TextCapitalization.none, this.styleColor = AppStyleTextField.black,
                this.hint, this.initialValue}) : super(key: key);

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  TextEditingController controller;
  TextStyle _labelStyle;
  TextStyle _hintStyle;
  TextStyle _inputStyle;
  UnderlineInputBorder _borderText;
  UnderlineInputBorder _borderErr;
  String _label;
  String _hint;
  var _context;

  bool _claveVisible = true;

  @override
  Widget build(BuildContext context) {
    _context = context;
    _setTextos();
    _setColorStyle();
    _setInitialValue();

    return StreamBuilder<String>(
      stream: widget.stream,
      builder: (context, snapshot) {
        return TextField(
          readOnly: widget.readOnly,
          controller: controller,
          keyboardType: widget.keyboardType,
          textCapitalization: widget.textCapitalization,
          obscureText: widget.isPassword && _claveVisible,
          decoration: InputDecoration(
            labelText: _label,
            hintText: _hint,
            labelStyle: _labelStyle,
            hintStyle: _hintStyle,
            enabledBorder: _borderText,
            errorText: snapshot.error,
            errorBorder: _borderErr,
            errorStyle: TextStyle(color: Colors.redAccent.shade100),
            suffixIcon: widget.isPassword ? _passwIcon() : widget.suffixIcon,
          ),
          style: _inputStyle,
          onChanged: widget.onChange,
        );
      }
    );
  }

   
  void _setColorStyle(){
    switch (widget.styleColor){
      case AppStyleTextField.white:
        _paint(Colors.white, Colors.grey, Colors.white, Colors.white);
        break;
      case AppStyleTextField.black:
        _paint(Colors.black, Colors.black, Colors.black, Colors.black);
        break;
      case AppStyleTextField.blue:
        _paint(constantes.ENDEAVOUR, Colors.grey, Colors.black, constantes.ENDEAVOUR);
        break;
      default:
          _paint(Colors.white, Colors.white, Colors.white, Colors.white);
    }
  }

  /// Label: es la etiqueta que queda arriba cuando el TextField tiene el foco
  /// Hint: es la etiqueta que se visualiza SOBRE LA LINEA cuando el TextField tiene el foco y el user aun no escribió nada
  /// Input: Lo que el user escribe, obvio 
  void _paint(Color label, Color hint, Color input, Color colorBorde){
    _labelStyle = TextStyle(color: label, fontSize: Theme.of(_context).textTheme.body1.fontSize);
    _hintStyle = TextStyle(color: hint, fontSize: Theme.of(_context).textTheme.body1.fontSize);
    _inputStyle = TextStyle(color: input, fontSize: Theme.of(_context).textTheme.body1.fontSize);

    _borderText = UnderlineInputBorder(borderSide: BorderSide(color: colorBorde));
    _borderErr = UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.redAccent.shade100));
  }

  /// Devuelve el icono con el ojito y el comportamiento de mostrar/ocultar contraseña, en el caso de 
  /// que haya sido declarado con la propiedad isPassword
  Widget _passwIcon(){
    return IconButton(
              color: Colors.white,
              icon: Icon(
                _claveVisible 
                ? Icons.visibility
                : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _claveVisible = !_claveVisible;
                });
              }
    );
  }

  void _setTextos(){
    _label = widget.label;
    _hint = widget.hint ?? widget.label;
  }

  void _setInitialValue() {
    print('El valor de initial value en textfield ${widget.initialValue}');
    if(!isTextEmpty(widget.initialValue)){
      print('Entra en el initial value del if');
      controller = TextEditingController(text: widget.initialValue);
      widget.onChange(widget.initialValue);
    }
  }
}

enum AppStyleTextField{
  white,
  black,
  blue
}





 */