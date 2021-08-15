
import 'dart:convert';

import 'package:formvalidation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider {

  final _prefs = new PreferenciasUsuario();

  Future<Map<String, dynamic>> login( String username, String password) async {
    final authData = {
      'username'    : username,
      'password' : password
    };
    print(authData);

    Map<String, String> headers = {"Content-type": "application/json"};
    final resp = await http.post(
//      'http://192.168.0.100:9080/api/login.json',
        'https://www.tesairauc.com/api/login.json',
      body: json.encode( authData ),
      headers: headers
    );

    Map<String, dynamic> decodedResp = json.decode( resp.body );

    if ( decodedResp.containsKey('data') ) {
      _prefs.token = decodedResp['data']['token'];
      _prefs.infoUser = decodedResp['data']['nombre'] + ' ' + decodedResp['data']['apellido'] + ' - ' + decodedResp['data']['especialidad'];
      return { 'ok': true, 'data': decodedResp['data'] };
    } else {
      return { 'ok': false, 'message': decodedResp['message']};
    }

  }

}