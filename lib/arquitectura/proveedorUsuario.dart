import 'package:flutter/material.dart';

class ProvUsuario with ChangeNotifier {
  
  // Properties
  bool _conexion = false;
  String _estadoOrden = '';
  
  
  //Getters & SETTERS
  get conexion {
    return _conexion;
  }
  set conexion( bool nombre ) {
    this._conexion = nombre;
    notifyListeners();
  }
  
  get estadoOrden{

    return _estadoOrden;
  }
  set estadoOrden(String valor){
    this._estadoOrden= valor;
    notifyListeners();


  }


}
