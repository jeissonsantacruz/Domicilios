/* Flutter dependencies */
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


//contiene la vista del SesionRequerida para un usuario logeado
class SesionRequerida extends StatefulWidget {
 

  @override
  SesionRequeridaState createState() => SesionRequeridaState();
}


class SesionRequeridaState extends State<SesionRequerida> {

  // Controladores del formulario
  String text = '';
 

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
          color: Colors.white70,
          padding: EdgeInsets.only(
              left: size.height * 0.02,
              right: size.height * 0.02,
              top: size.height * 0.1),
          child: SingleChildScrollView(
              child: Column(children: <Widget>[
            _loginImagen(context),
            _formulario(context),
          ]))),
    );
  }

  // Widget que dibuja logo sulogistica
  Widget _loginImagen(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.05,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/suweb.png'),
          ),
        ));
  }

  // widget  que pinta los formularios
  Widget _formulario(BuildContext context) {  
    final size = MediaQuery.of(context).size;
   
    return ListView(
        shrinkWrap: true,
        padding:
            EdgeInsets.only(bottom: size.height * 0.5, left: size.width * 0.05),
        children: <Widget>[
          MyCustomTitle(
            icono: FontAwesomeIcons.mobileAlt,
            titulo: 'Login requerido!',
          ),
         
        ]);
  }

  
}

// Clase que personaliza la Tareta de los campos del formulario


class MyCustomTitle extends StatelessWidget {
  final IconData icono;
  final String titulo;

  MyCustomTitle({this.icono, this.titulo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40),
      child: ListTile(
        leading: Icon(
          icono,
          color: Color(0xFF0A2140),
        ),
        title: Text(
          titulo,
          style: TextStyle(
              fontSize: 20,
              color: Color(0xFF0A2140),
              fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
