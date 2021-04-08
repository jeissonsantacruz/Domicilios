/* Flutter dependencies */
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:suweb_domicilios/aplicacion/paginas/HomeDomicilios_page.dart';
import 'package:suweb_domicilios/arquitectura/preferenciasUsuario.dart';
import 'package:suweb_domicilios/arquitectura/serviciosGestioncci.dart';
import 'package:suweb_domicilios/dominio/diligenciasModelo_model.dart';

import 'detalleDomiciliario.dart';

/*contiene la vista del historial de movimientos de un usario*/
class PedidosTomados extends StatefulWidget {
  @override
  _HistorialState createState() => _HistorialState();
}

class _HistorialState extends State<PedidosTomados> {
  final servicios = ServiciosGestionCci();
  final prefs = PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async {
        refresh();
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text('Pedidos Tomados',
                style: TextStyle(
                    fontSize: size.width * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0A2140))),
            backgroundColor: Colors.white12,
            elevation: 0,
            leading: new IconButton(
                icon: new Icon(
                  FontAwesomeIcons.chevronLeft,
                  color: Color(0xFFC11C36),
                  size: size.width * 0.1,
                ),
                onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeUsuario()),
                    ModalRoute.withName("homeUsuario")))),
        body: Padding(
          padding: EdgeInsets.all(size.width * 0.05),
          child: Stack(children: <Widget>[
            SizedBox(
              height: size.height * 0.1,
            ),
            FutureBuilder(
                future: servicios.listarPendientes(true), // llamado al servicio
                builder: (BuildContext context,
                    AsyncSnapshot<List<Domicilio>> snapshot) {
                  if (snapshot.hasData) {
                    final diligenciauctos = snapshot.data;
                    return Container(
                      child: ListView.builder(
                        itemCount: diligenciauctos.length,
                        itemBuilder: (context, i) => _Card(diligenciauctos[i]),
                      ),
                    );
                  } else {
                    return Center(
                      child: ListTile(
                          title: Text(
                            'Ups! aún no tienes pedidos tomados!',
                            style: TextStyle(fontSize: 20),
                          ),
                          leading: Icon(
                            FontAwesomeIcons.sadTear,
                            color: Colors.redAccent[700],
                          )),
                    );
                  }
                }),
            SizedBox(
              height: size.height * 0.1,
            ),
          ]),
        ),
      ),
    );
  }

  refresh() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PedidosTomados()));
    Navigator.of(context).pop();
  }
}

class _Card extends StatelessWidget {
  final Domicilio diligencia;
  _Card(this.diligencia);

  @override
  Widget build(BuildContext context) {
    // Data server Url
    final size = MediaQuery.of(context).size;
    final preferenciasUsuario = PreferenciasUsuario();

    return GestureDetector(
        onTap: () {
          List<String> listaDatos = [
            diligencia.destinatario,
            diligencia.estado,
            diligencia.direccion,
            diligencia.telefono,
            diligencia.nota
          ];
          preferenciasUsuario.datosDetallePed = listaDatos;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetalleTarea(diligencia)));
        },
        child: Container(
          height: size.width * 0.25,
          child: Card(
              elevation: 2,
              child: ListTile(
                leading: (diligencia.estado == "TRANSPORTE" ||
                        diligencia.estado == "TRANPORTE")
                    ? Icon(
                        FontAwesomeIcons.motorcycle,
                        color: Colors.orangeAccent[700],
                      )
                    : Image.asset(
                        'assets/images/SUPERMERCADO_ICONO.png',
                      ),
                title: RichText(
                    text: TextSpan(
                        style: new TextStyle(
                          fontSize: size.width * 0.045,
                          color: Color(0xFF36435B),
                        ),
                        children: <TextSpan>[
                      TextSpan(
                        text: 'Número radicado: ',
                        style: new TextStyle(
                            fontSize: size.width * 0.045,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF36435B)),
                      ),
                      TextSpan(text: diligencia.pedido)
                    ])),
                subtitle: Text('\u{1F4CD}${diligencia.direccion.toString()}'),
                trailing: Icon(
                  Icons.chevron_right,
                  color: Color(0xFF0A2140),
                ),
              )),
        ));
  }
}
