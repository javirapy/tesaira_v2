import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 250,
      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(21, 249, 89, 1.0)),),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final spinner = SpinKitWave(
        color: Colors.green,
        size: 50.0,
    );

    return Scaffold(
      body: ModalProgressHUD(
            inAsyncCall: true,
            opacity: 0.5,
            progressIndicator: spinner,
            child: Center(),
      ),
    );
  }
}