/* Flutter dependencies */
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as Imagen;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:suweb_domicilios/aplicacion/paginas/HomeDomicilios_page.dart';
import 'package:suweb_domicilios/arquitectura/preferenciasUsuario.dart';
import 'package:suweb_domicilios/arquitectura/serviciosGestioncci.dart';
import 'package:suweb_domicilios/dominio/domicilioModelo.dart';
import 'package:suweb_domicilios/dominio/estadosModelos.dart';
import 'package:suweb_domicilios/dominio/incidenciasModelo.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:suweb_domicilios/ambientes.dart' as global;

//contiene la vista del Home para un usuario logeado
class DetalleTarea extends StatefulWidget {
  final Domicilio modelo;
  DetalleTarea(this.modelo);
  @override
  _LoginPageState createState() => _LoginPageState(modelo);
}

class _LoginPageState extends State<DetalleTarea> {
  final Domicilio modelo;
  _LoginPageState(this.modelo);
  
  final prefs = PreferenciasUsuario();
  TextEditingController observacionesControlador = new TextEditingController();
  TextEditingController cancelarOrdController = new TextEditingController();

  List<File> imagenFile = [];
  List<File> imagenText = [];
  List detalleObsList;
  final servicios = ServiciosGestionCci();
  String mensaje;
  String value;
  String incidencia;
  String _estado;
  Position _posicionActual;

  @override
  void initState() {
    super.initState();
  }

  final String urlIncidencias =
      urlBase + 'controladores/funcionesCcidetallegestion.php';
  List<Incidencias> _incidencias = [Incidencias(label: 'Elegir', value: '0')];
  Future<List<Incidencias>> listarIncidencias() async {
    var data = {
      "funcionphp": "listarIncidencias",
      "proceso": "DOMICILIOS",
      "dispositivo": "movil"
    };
    var dio = Dio();
    final encodedData = FormData.fromMap(data);
    // make POST request
    Response response = await dio.post(urlIncidencias, data: encodedData);

    if (response.data != '' && response.data != []) {
      final decodeData = jsonDecode(response.data);
      var list = decodeData['incidenciasLista'] as List;
      if (list.isNotEmpty) {
        _incidencias = list.map((i) => Incidencias.fromJson(i)).toList();

        return _incidencias;
      }
    }
    return _incidencias;
  }

  var urlEstadosSeccion = urlBase + 'controladores/funcionesSecciones.php';
  Future<List<Estado>> estadosSeccion() async {
    var data = {
      "funcionphp": 'tomarEstados',
      "dispositivo": 'movil',
      "oidSeccion": '4380',
      "estadoRequerido": modelo.estado
    };
    var dio = Dio();
    final encodedData = FormData.fromMap(data);
    // make POST request
    Response response = await dio.post(urlEstadosSeccion, data: encodedData);

    final decodeData = jsonDecode(response.data);
    
    List<Estado> listaTemp = [];
    if (decodeData["lstActuales"] != []) {
      var listaEstados = decodeData["lstActuales"] as List;
      for (var lista in listaEstados) {

        Estado estado = Estado(estado: lista[2], value: lista[3]);
        listaTemp.add(estado);
      }
    }

    return listaTemp;
  }
   Future<Position> _obtenerPosicion() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position);
    setState(() {
      _posicionActual = position;
    });
    return _posicionActual;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Text(" Gestión domicilio",
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
              top: size.width * 0.07),
          child: Stack(children: <Widget>[
            ListView(children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(global.url + 'images/FONDO.png'),
                )),
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
                        padding: EdgeInsets.all(size.width * 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Destinatario:' +
                                          ' ' +
                                          prefs.datosDetallePed[0] ==
                                      ''
                                  ? modelo.destinatario
                                  : prefs.datosDetallePed[0],
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
                              'Estado:' + ' ' + prefs.datosDetallePed[1] == ''
                                  ? modelo.estado.toString()
                                  : prefs.datosDetallePed[1],
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
                                'Dirección:' + ' ' + prefs.datosDetallePed[2] ==
                                        ''
                                    ? modelo.direccion.toString()
                                    : prefs.datosDetallePed[2],
                                style: TextStyle(
                                  fontSize: size.width * 0.04,
                                  color: Color(
                                    0xFF036435b,
                                  ),
                                )),
                            SizedBox(
                              height: size.width * 0.05,
                            ),
                            Text('Nota:' + modelo.nota.toString(),
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
                                      "tel://${prefs.datosDetallePed[3] == '' ? modelo.telefono : prefs.datosDetallePed[3]}"),
                                  color: Colors.white,
                                  textColor: Colors.white,
                                  child: Icon(
                                    Icons.call,
                                    color: Colors.green,
                                  ),
                                ),
                                Text(
                                    '   ' + prefs.datosDetallePed[3] == ''
                                        ? modelo.telefono
                                        : prefs.datosDetallePed[3],
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
                    Text('Observaciones:',
                        style: TextStyle(
                            color: Color(
                              0xFF036435b,
                            ),
                            fontSize: size.width * 0.045,
                            fontWeight: FontWeight.bold)),
                    TextFormField(
                      controller: observacionesControlador,
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    modelo.estado == 'TRANSPORTE' ||
                            modelo.estado == "TRANPORTE"
                        ? Text('Reportar incidencia:',
                            style: TextStyle(
                                color: Color(
                                  0xFF036435b,
                                ),
                                fontSize: size.width * 0.045,
                                fontWeight: FontWeight.bold))
                        : Container(),
                    modelo.estado == 'TRANSPORTE' ||
                            modelo.estado == "TRANPORTE"
                        ? FutureBuilder(
                            future: listarIncidencias(), // llamado al servicio
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Incidencias>> snapshot) {
                              if (snapshot.hasData) {
                                final lista = snapshot.data;
                                return DropdownButton(
                                    value: incidencia,
                                    isExpanded: true,
                                    icon: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: Icon(Icons.arrow_drop_down),
                                    ),
                                    iconSize: 25,
                                    underline: SizedBox(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        print(newValue);
                                        incidencia = newValue;
                                      });
                                      print(incidencia);
                                    },
                                    hint: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Seleccionar incidencia'),
                                    ),
                                    items: lista.map((data) {
                                      return DropdownMenuItem(
                                        value: data.value.toString(),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            data.label,
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList());
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            })
                        : Container(),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(' Enviar reporte',
                          style: TextStyle(
                              color: Color(
                                0xFF036435b,
                              ),
                              fontSize: size.width * 0.045,
                              fontWeight: FontWeight.bold)),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.green)),
                        onPressed: () {
                          _enviarReporte();
                        },
                        color: Colors.green,
                        child: Icon(
                          FontAwesomeIcons.whatsapp,
                          color: Colors.white,
                          size: size.width * 0.1,
                        ),
                      ),
                    ],
                  ),
                  Column(children: [
                    Text('Adjuntar imagen',
                        style: TextStyle(
                            color: Color(
                              0xFF036435b,
                            ),
                            fontSize: size.width * 0.045,
                            fontWeight: FontWeight.bold)),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Color(0xFF036435b))),
                      onPressed: () {
                        _mostrarDialogoCamara();
                      },
                      color: Color(0xFF036435b),
                      textColor: Colors.white,
                      child: Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                        size: size.width * 0.1,
                      ),
                    ),
                  ])
                ],
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              _mostarImagenes(),
              Column(
                children: [
                  Padding(
                    padding:  EdgeInsets.only(left:size.width*0.1,right: size.width*0.1),
                    child: FutureBuilder(
                              future: estadosSeccion(), // llamado al servicio
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<Estado>> snapshot) {
                                if (snapshot.hasData) {
                                  final lista = snapshot.data;
                                  return DropdownButton(
                                      value:  _estado,
                                      isExpanded: true,
                                      icon: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15.0),
                                        child: Icon(Icons.arrow_drop_down),
                                      ),
                                      iconSize: 25,
                                      underline: SizedBox(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          print(newValue);
                                          _estado = newValue;
                                        });
                                        print(_estado);
                                      },
                                      hint: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('Seleccionar estado'),
                                      ),
                                      items: lista.map((data) {
                                        return DropdownMenuItem(
                                          value: data.value.toString(),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10.0),
                                            child: Text(
                                              data.estado.toString(),
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList());
                                } else {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                              }),
                  ),
                  Container(
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.only(
                          bottom: size.height * 0.04,
                          left: size.width * 0.05,
                          right: size.width * 0.05,
                          top: size.width * 0.04),
                      child: RaisedButton(
                          elevation: 5.0,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0),
                          ),
                          padding: EdgeInsets.all(0.0),
                          child: Ink(
                            decoration: BoxDecoration(
                                color: Color(0xFF036435b),
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(
                                  size.width * 0.1,
                                  size.height * 0.005,
                                  size.width * 0.1,
                                  size.height * 0.005),
                              child: ListTile(
                                  leading: Icon(
                                    FontAwesomeIcons.check,
                                    color: Colors.white,
                                  ),
                                  title: Text('Gestionar Domicilio',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600))),
                            ),
                          ),
                          onPressed: () {
                            onButtonPressed();
                          })),
                ],
              ),
            ]),
          ]),
        ));
  }

  onButtonPressed() async {
    if(_estado != null){
    int numeroFoto = 0;
        await _obtenerPosicion(); // obtiene la posicion del usuario
    String nombreFoto =
        "_" + "DOMICILIOS" + "_" + modelo.pedido.toString() + "_";
   
    prefs.pedidoPendiente = true;
    if (imagenText.isNotEmpty) {
      imagenText.forEach((element) async {
        await servicios
            .subirAnexo("GESTION_SLCTDINV", nombreFoto, numeroFoto.toString(),
                element, modelo.pedido.toString())
            .whenComplete(() => servicios.subirFotoAnexo(
                element, "GESTION_SLCTDINV-" + nombreFoto));

        numeroFoto++;
      });
      imagenFile = [];
    }
    print(incidencia);
    if (incidencia == null) {
      var res = servicios.cambiarEstado(modelo.pedido.toString(), int.parse(_estado),
          observacionesControlador.text,_posicionActual.latitude,_posicionActual.longitude);
      res.then((respuesta) async {
        if (respuesta) {
          Fluttertoast.showToast(
              msg: "Se realizó la gestión",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.greenAccent[700],
              textColor: Colors.white,
              fontSize: 16.0);

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeUsuario()),
              ModalRoute.withName("homeUsuario"));
        } else {
          Fluttertoast.showToast(
              msg:
                  "El pedido se encuentra en un estado posterior, no se puede gestionar.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.redAccent[700],
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
    } else {
      var res = servicios.grabarIncidencia(modelo.pedido, modelo.estado,
          incidencia, observacionesControlador.text);
      res.then((respuesta) async {
        Fluttertoast.showToast(
            msg: "Se realizó la gestión",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.greenAccent[700],
            textColor: Colors.white,
            fontSize: 16.0);

        Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeUsuario()),
              ModalRoute.withName("homeUsuario"));
      });
    }}
    else{
         Fluttertoast.showToast(
              msg: "Debes seleccionar un estado para la gestión.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.redAccent[700],
              textColor: Colors.white,
              fontSize: 16.0);

    }
  }

  /* funciones de la camara  */
  void _abrirGaleria(BuildContext context) async {
    // ignore: deprecated_member_use
    var pictureFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    var pictureCompress = await servicios.compressFile(pictureFile);
    var pictureModi = await crearImagenTexto(pictureCompress);
    this.setState(() {
      imagenFile.add(pictureFile);
      imagenText.add(pictureModi);
    });
    Navigator.of(context).pop();
  }

  void _abrirCamara(BuildContext context) async {
    // ignore: deprecated_member_use
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    var pictureCompress = await servicios.compressFile(picture);
    var pictureModi = await crearImagenTexto(pictureCompress);
    this.setState(() {
      imagenFile.add(picture);
      imagenText.add(pictureModi);
    });
    Navigator.of(context).pop();
  }

  void borrarImagen(image) {
    setState(() {
      imagenFile.remove(image);
    });
  }

  // función que le agrega la fecha como texto a la imagen seleccionada
  Future<File> crearImagenTexto(File pictureFile) async {
    final servicios = ServiciosGestionCci();
    var fileCode = pictureFile.readAsBytesSync();
    var image = Imagen.decodeImage(fileCode);
    final f = new DateFormat('yyyy-MM-dd hh:mm');
    var now = DateTime.now();
    var data = f.format(now);
    var picture = Imagen.drawString(image, Imagen.arial_48, 100, 0, data);
    var resultado = Imagen.encodeJpg(picture);

    var file = await File(
            "/storage/emulated/0/Android/data/com.su_logistica.suweb_domicilios/files/Pictures/${data}archivoModificado.jpg")
        .writeAsBytes(resultado);

    return servicios.compressFile(file);
  }

  // funcion que muestra el dialogo para abrir camara o galeria.
  _mostrarDialogoCamara() {
    final size = MediaQuery.of(context).size;
    Alert(
      context: context,
      title: "Imagen",
      desc: "¿De donde quiere adjuntar su foto?",
      buttons: [
        DialogButton(
          child: Text(
            "Cámara",
            style: TextStyle(color: Colors.white, fontSize: size.width * 0.05),
          ),
          onPressed: () => {_abrirCamara(context)},
          color: Color(
            0xFF036435b,
          ),
        ),
        DialogButton(
          child: Text(
            "Galería",
            style: TextStyle(color: Colors.white, fontSize: size.width * 0.05),
          ),
          onPressed: () => _abrirGaleria(context),
          color: Color(
            0xFF036435b,
          ),
        )
      ],
    ).show();
  }

  /* widget que dibuja una lista de imagenes con scroll horizontal
  : llama a la Clase "CardImages" la cual customiza le diseño*/
  Widget _mostarImagenes() {
    final size = MediaQuery.of(context).size;
    if (imagenFile.isNotEmpty) {
      return Row(children: <Widget>[
        Expanded(
            child: SizedBox(
                height: size.height * 0.2,
                child: new ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imagenFile.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return CardImages(imagenFile[index],
                        () => borrarImagen(imagenFile[index]));
                  },
                )))
      ]);
    } else {
      return Container();
    }
  }

  /*Funcion para enviar reporte por Whatsapp */
  _enviarReporte() async {
    mensaje =
        '*TRI-FIT* \n *Notificación del estado de su pedido* \n *observaciones*: ${observacionesControlador.text} \n *Numero de pedido* ${modelo.pedido}';
    var whatsappUrl = "https://wa.me/57${modelo.telefono}/?text=$mensaje";
    await canLaunch(whatsappUrl)
        ? launch(whatsappUrl)
        : print("No se encontro el link o whatsapp no instalado");
  }
}

/* Clase que customiza el diseño de la imagen :
le agrega la fecha y el boton de eliminar iamgen */
class CardImages extends StatelessWidget {
  final formatoFecha = new DateFormat('yyyy-MM-dd hh:mm');
  final File image;
  final Function borrarImagen;
  CardImages(this.image, this.borrarImagen);
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now(); // funcion que obtiene la fecha reciente
    var data = formatoFecha.format(now);
    final size = MediaQuery.of(context).size;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: <Widget>[
          Image.file(
            image,
          ),
          Positioned(
              right: size.width * 0.01,
              top: size.width * 0.01,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      color: Colors.black,
                      child: Text(
                        data,
                        style: TextStyle(
                            fontSize: size.width * 0.02, color: Colors.white),
                      )),
                  InkWell(
                      child: Icon(
                        Icons.remove_circle,
                        size: size.width * 0.04,
                        color: Color(0xFFC11C36),
                      ),
                      onTap: () {
                        Alert(
                          context: context,
                          type: AlertType.warning,
                          title: "Eliminar imagen",
                          desc: "¿Desea eliminar la imagen?",
                          buttons: [
                            DialogButton(
                                child: Text(
                                  "Si",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.width * 0.04),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  borrarImagen();
                                },
                                color: Colors.redAccent[700]),
                          ],
                        ).show();
                      }),
                ],
              )),
        ],
      ),
    );
  }
}
