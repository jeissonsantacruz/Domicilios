/* Flutter dependencies */
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:suweb_domicilios/aplicacion/paginas/Picking_page.dart';
import 'package:suweb_domicilios/aplicacion/paginas/pedidosDomiciliario.dart';
import 'package:suweb_domicilios/arquitectura/preferenciasUsuario.dart';
import 'package:suweb_domicilios/arquitectura/serviciosGestioncci.dart';
import 'package:suweb_domicilios/dominio/diligenciasModelo_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:suweb_domicilios/aplicacion/widgets/botonTomarOrden.dart'
    as boton;

//contiene la vista del Home para un usuario logeado
class TomarOrden extends StatefulWidget {
  final Domicilio modelo;
  TomarOrden(this.modelo);
  @override
  _LoginPageState createState() => _LoginPageState(modelo);
}

class _LoginPageState extends State<TomarOrden> {
  final Domicilio modelo;
  _LoginPageState(this.modelo);

  TextEditingController observacionesControlador = new TextEditingController();

  List<File> imagenFile = [];
  List<File> imagenText = [];
  List detalleObsList;

  String mensaje;
  String value;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text("Tomar domicilio",
              style: TextStyle(
                  color: Color(0xFF036435b),
                  fontSize: size.width * 0.06,
                  fontWeight: FontWeight.bold)),
          elevation: 0,
          backgroundColor: Colors.white30,
        ),
        body: Padding(
          padding: EdgeInsets.only(
              left: size.width * 0.04,
              right: size.width * 0.02,
              top: size.width * 0.07,
              bottom: size.width * 0.02),
          child: Stack(children: <Widget>[
            ListView(children: <Widget>[
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Detalle:',
                        style: TextStyle(
                            color: Color(
                              0xFF036435b,
                            ),
                            fontSize: size.width * 0.045,
                            fontWeight: FontWeight.bold)),
                    Card(
                      elevation: 5,
                      color: Colors.white60,
                      child: Padding(
                        padding: EdgeInsets.all(size.width * 0.00),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Destinatario:' +
                                  ' ' +
                                  modelo.destinatario.toString(),
                              style: TextStyle(
                                fontSize: size.width * 0.04,
                                color: Color(
                                  0xFF036435b,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.width * 0.01,
                            ),
                            Text(
                              'Estado:' + ' ' + modelo.estado.toString(),
                              style: TextStyle(
                                fontSize: size.width * 0.04,
                                color: Color(
                                  0xFF036435b,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.width * 0.05,
                            ),
                            Text(
                                'Dirección:' +
                                    ' ' +
                                    modelo.direccion.toString(),
                                style: TextStyle(
                                  fontSize: size.width * 0.04,
                                  color: Color(
                                    0xFF036435b,
                                  ),
                                )),
                            SizedBox(
                              height: size.width * 0.05,
                            ),
                            Text('Nota:' + ' ' + (modelo.nota).toString(),
                                style: TextStyle(
                                  fontSize: size.width * 0.04,
                                  color: Color(
                                    0xFF036435b,
                                  ),
                                )),
                            Row(
                              children: [
                                RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.green)),
                                  onPressed: () => launch(
                                      "tel://${modelo.telefono.toString()}"),
                                  color: Colors.white,
                                  textColor: Colors.white,
                                  child: Icon(
                                    Icons.call,
                                    color: Colors.green,
                                  ),
                                ),
                                Text('   ' + modelo.telefono,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: size.width * 0.05,
                                      color: Color(
                                        0xFF036435b,
                                      ),
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: boton.AnimatedButton(
                  onTap: () {
                    _rutaUsuario(context);
                  },
                  animationDuration: const Duration(milliseconds: 1300),
                  initialText: "Tomar orden",
                  finalText: "Orden tomada!",
                  iconData: FontAwesomeIcons.checkCircle,
                  iconSize: 32.0,
                  buttonStyle: boton.ButtonStyle(
                    primaryColor: Colors.greenAccent[700],
                    secondaryColor: Colors.greenAccent[700],
                    elevation: 20.0,
                    initialTextStyle: TextStyle(
                      fontSize: 22.0,
                      color: Colors.white,
                    ),
                    finalTextStyle: TextStyle(
                      fontSize: 22.0,
                      color: Colors.white,
                    ),
                    borderRadius: 10.0,
                  ),
                ),
              )
            ]),
          ]),
        ));
  }

  _rutaUsuario(context) async {
    final prefs = PreferenciasUsuario();
    final servicios = ServiciosGestionCci();

    var res = servicios.tomarPedido(modelo.pedido);
    prefs.oidPedido = modelo.pedido;
    res.then((value) async {
      if (value) {
        // switch (prefs.tipoUsuario) {
        //   case "shopper":
        //     prefs.pedidoPendiente = true;
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) => ShopperProductos(
        //                   idPedido: modelo.pedido,
        //                 )));

        //     break;
        //   default:
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PedidosTomados()));
        
      } else {
        Fluttertoast.showToast(
            msg: "El conductor no tiene asignado un vehiculo",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.redAccent[700],
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }
}
