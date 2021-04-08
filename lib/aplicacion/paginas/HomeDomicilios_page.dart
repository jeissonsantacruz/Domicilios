/* Flutter dependencies */
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:suweb_domicilios/aplicacion/paginas/pedidosDomiciliario.dart';
import 'package:suweb_domicilios/aplicacion/widgets/modalFinalizarTarea_widget.dart';
import 'package:suweb_domicilios/arquitectura/proveedorUsuario.dart';
import 'package:suweb_domicilios/dominio/diligenciasModelo_model.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:suweb_domicilios/arquitectura/preferenciasUsuario.dart';
import 'package:suweb_domicilios/arquitectura/serviciosGestioncci.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:suweb_domicilios/ambientes.dart' as global;
import 'package:suweb_domicilios/dominio/estadosModelos.dart';
import '../widgets/menuDrawer_widget.dart';

//contiene la vista del Home para un usuario logeado, muestra un drawer y la lista de tareas.
class HomeUsuario extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<HomeUsuario> {
  // Controladores del formulario
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final servicios = ServiciosGestionCci();
  final Connectivity _conectividad = Connectivity();
  final preferenciasUsuario = PreferenciasUsuario();
  final userName = ProvUsuario();
  String estado;
  bool loading = false;
  StreamSubscription<ConnectivityResult> _subscripcionConectividad;
  bool _connectionStatus = false;

  @override
  void initState() {
    super.initState();

    _iniciarConectividad();

    _subscripcionConectividad =
        _conectividad.onConnectivityChanged.listen(actualizarEstadoConexion);
  }

  @override
  void dispose() {
    _subscripcionConectividad.cancel();
    super.dispose();
  }

  // Inicia el estado de la conectivida del celular
  Future<void> _iniciarConectividad() async {
    ConnectivityResult result;
    try {
      result = await _conectividad.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }

    return actualizarEstadoConexion(result);
  }

  final spinkit = SpinKitFadingCircle(
    size: 60,
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
            color: index.isEven ? Color(0xFFC11C36) : Color(0xFF)),
      );
    },
  );

  Future<List<File>> cargarImagenesMvto(List<dynamic> pathsImagenes) async {
    List<File> _imagenesMvto = [];
    pathsImagenes.forEach((element) => (_imagenesMvto.add(File(element))));

    return _imagenesMvto;
  }

  // busca en el storage local si hay  tareas disponibles y retorna una lista de objetos diligencia
  List<Domicilio> cargarTareasLocal() {
    List<Domicilio> _diligencias = [];

    if (preferenciasUsuario.listaDiligencias != '') {
      var jsonList = json.decode(preferenciasUsuario.listaDiligencias) as List;
      _diligencias = jsonList.map((i) => Domicilio.fromJson(i)).toList();
      return _diligencias;
    } else {
      return _diligencias;
    }
  }

  // actualiza el estado de la  conexion y crea una alerta informando el estado de la  conexion
  Future<void> actualizarEstadoConexion(ConnectivityResult result) async {
    final preferenciasUsuario = new PreferenciasUsuario();
    switch (result) {
      case ConnectivityResult.wifi:
        setState(() => _connectionStatus = true);
        userName.conexion = true;

        break;
      case ConnectivityResult.mobile:
        setState(() => _connectionStatus = true);
        userName.conexion = true;

        break;
      case ConnectivityResult.none:
        setState(() => _connectionStatus = false);
        userName.conexion = false;
        if (preferenciasUsuario.listaDiligencias != '') {
          _crearAlerta(context,
              "Podrá seguir trabajando en modo offline y sus movimientos se cargarán cuando vuelva a conectarse.");
        } else {
          _crearAlerta(context,
              'No se han detectado datos en el dispositivo, por favor conectarse a internet');
        }
        break;
      default:
        setState(() => _connectionStatus = false);
        break;
    }
  }

  // Funcion que crea una alerta tipo warning con un mensaje
  _crearAlerta(context, msg) {
    final size = MediaQuery.of(context).size;
    Alert(
      context: context,
      type: AlertType.warning,
      title: "¡Sin conexión a internet! ",
      desc: msg,
      buttons: [
        DialogButton(
          child: Text(
            "Cerrar",
            style: TextStyle(color: Colors.white, fontSize: size.height * 0.04),
          ),
          onPressed: () => Navigator.pop(context),
          color: Colors.greenAccent[700],
        ),
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return RefreshIndicator(
      onRefresh: () async {
        refresh();
      },
      child: Scaffold(
          key: _scaffoldKey,
          drawer: MenuWidget(),
          body: RefreshIndicator(
            onRefresh: _refreshCards,
            child: Stack(children: <Widget>[
              Container(
                alignment: Alignment.bottomRight,
                height: size.height * 0.25,
                width: size.width * 1,
                decoration: BoxDecoration(
                    color: Color(0xFF4F5C70),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(global.url + 'images/FONDO.png'),
                    )),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, size.height * 0.1, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(' Pedidos',
                              style: TextStyle(
                                  fontSize: size.width * 0.08,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                          Container(
                              height: size.height * 0.06,
                              width: size.width * 0.35,
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: _connectionStatus
                                    ? Colors.greenAccent[700]
                                    : Colors.redAccent[700],
                                boxShadow: [
                                  BoxShadow(
                                    color: _connectionStatus
                                        ? Colors.greenAccent[700]
                                        : Colors.redAccent[700],
                                    offset: Offset(3.0, 3.0), //(x,y)
                                    blurRadius: 2.0,
                                  ),
                                ],
                              ),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CircleAvatar(
                                      child: _connectionStatus
                                          ? Icon(FontAwesomeIcons.smile,
                                              color: Colors.greenAccent)
                                          : Icon(FontAwesomeIcons.sadTear,
                                              color: Colors.redAccent),
                                      backgroundColor: Colors.white,
                                    ),
                                    Text(
                                        _connectionStatus
                                            ? 'En línea'
                                            : ' Offline',
                                        style: TextStyle(
                                            fontSize: size.height * 0.02,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  ])),
                        ],
                      ),
                      InkWell(
                        onTap: () => _scaffoldKey.currentState.openDrawer(),
                        child: Container(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image(
                                image: NetworkImage(
                                  global.url + 'images/USUARIO_ICONO.png',
                                ),
                                width: size.width * 0.25,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: size.width * 0.6,
                    left: size.width * 0.05,
                    right: size.width * 0.05),
                child: Column(
                  children: [
                    // Container(
                    //   padding: EdgeInsets.fromLTRB(
                    //       size.width * 0.04, 0, size.width * 0.04, 0),
                    //   decoration: BoxDecoration(
                    //       border: Border.all(color: Colors.grey),
                    //       borderRadius: BorderRadius.circular(10)),
                    //   child: FutureBuilder(
                    //       future:
                    //           servicios.estadosSeccion(), // llamado al servicio
                    //       builder: (BuildContext context,
                    //           AsyncSnapshot<List<Estado>> snapshot) {
                    //         if (snapshot.hasData) {
                    //           final lista = snapshot.data;
                    //           return DropdownButton(
                    //               value: estado,
                    //               isExpanded: true,
                    //               icon: Padding(
                    //                 padding: const EdgeInsets.only(left: 15.0),
                    //                 child: Icon(Icons.arrow_drop_down),
                    //               ),
                    //               iconSize: 25,
                    //               underline: SizedBox(),
                    //               onChanged: (newValue) {
                    //                 setState(() {
                    //                   estado = newValue;
                    //                 });
                    //               },
                    //               hint: Padding(
                    //                 padding: const EdgeInsets.all(8.0),
                    //                 child: Text('Elige un estado'),
                    //               ),
                    //               items: lista.map((data) {
                    //                 return DropdownMenuItem(
                    //                   value: data.value.toString(),
                    //                   child: Padding(
                    //                     padding:
                    //                         const EdgeInsets.only(left: 10.0),
                    //                     child: Text(
                    //                       data.estado,
                    //                       style: TextStyle(
                    //                           fontSize: 18,
                    //                           color: Colors.black,
                    //                           fontWeight: FontWeight.w400),
                    //                     ),
                    //                   ),
                    //                 );
                    //               }).toList());
                    //         } else {
                    //           return Center(child: CircularProgressIndicator());
                    //         }
                    //       }),
                    // ),
                    ListTile(
                      leading: Icon(FontAwesomeIcons.motorcycle),
                      title: Text('Por tomar',
                          style: TextStyle(
                              fontSize: size.width * 0.07,
                              fontWeight: FontWeight.w700,
                              color: Colors.redAccent[200])),
                    ),
                    loading
                        ? spinkit
                        : Expanded(
                            child: FutureBuilder(
                                future: servicios.listarPendientes(
                                    false), // llamado al servicio
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<Domicilio>> snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data.isNotEmpty) {
                                    final diligenciauctos = snapshot.data;

                                    return Container(
                                      child: ListView.builder(
                                          itemCount: diligenciauctos.length,
                                          itemBuilder: (context, i) =>
                                              _Card(diligenciauctos[i], true)),
                                    );
                                  } else {
                                    return Center(
                                      child: ListTile(
                                          title: Text(
                                            '¡Ups! aún no hay pedidos en tú zona.',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          leading: Icon(
                                            FontAwesomeIcons.sadTear,
                                            color: Colors.redAccent[700],
                                          )),
                                    );
                                  }
                                }),
                          ),
                  ],
                ),
              ),
            ]),
          ),
          floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PedidosTomados()));
              },
              child: Icon(FontAwesomeIcons.listAlt))),
    );
  }

  refresh() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeUsuario()),
        ModalRoute.withName("homeUsuario"));
  }

  // funcion que refresca la listade tareas
  Future<void> _refreshCards() async {
    Navigator.of(context)
        .push(new MaterialPageRoute(builder: (BuildContext context) {
      return new HomeUsuario();
    }));
  }
}

// crea un card customizable que muestra la lista de tareas.
class _Card extends StatelessWidget {
  final Domicilio diligencia;
  final bool gestionar;
  _Card(this.diligencia, this.gestionar);

  @override
  Widget build(BuildContext context) {
    // Data server Url
    final size = MediaQuery.of(context).size;
    final preferenciasUsuario = PreferenciasUsuario();

    return GestureDetector(
        onTap: () {
          if (gestionar) {
            List<String> listaDatos = [
              diligencia.destinatario,
              diligencia.estado,
              diligencia.direccion,
              diligencia.telefono,
              diligencia.nota
            ];
            preferenciasUsuario.datosDetallePed = listaDatos;
            _onButtonPressed(context);
          }
        },
        child: Container(
          height: size.width * 0.25,
          child: Card(
              color: diligencia.prioridad.toString() == '1'
                  ? Colors.orangeAccent[400]
                  : Colors.white,
              elevation: 2,
              child: ListTile(
                leading: diligencia.tipoPedido == "SUPERMERCADO"
                    ? Image.asset(
                        'assets/images/SUPERMERCADO_ICONO.png',
                      )
                    : Image.asset(
                        'assets/images/DROGUERIA_ICONO.png',
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

  void _onButtonPressed(BuildContext context) {
    final size = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: size.height * 0.8,
            child: Container(
              child: TomarOrden(diligencia),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(60),
                  topRight: const Radius.circular(60),
                ),
              ),
            ),
          );
        });
  }
}
