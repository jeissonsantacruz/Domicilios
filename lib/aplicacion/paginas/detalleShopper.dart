import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suweb_domicilios/aplicacion/paginas/HomeDomicilios_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:suweb_domicilios/arquitectura/preferenciasUsuario.dart';
import 'package:suweb_domicilios/arquitectura/proveedorUsuario.dart';
import 'package:suweb_domicilios/arquitectura/serviciosGestioncci.dart';
import 'package:suweb_domicilios/dominio/dominio/picking_model.dart';

// this class contains the  checkin and  aditional services of  services pages
class Checkin extends StatefulWidget {
  final String idPedido;
  final List<PickingProducto>
      listaProductos; //  this class receive  the model of services

  Checkin({this.idPedido, this.listaProductos});
  @override
  _CheckinState createState()  => _CheckinState();
  
}

class _CheckinState extends State<Checkin> {
  final servicios = ServiciosGestionCci();
 
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final prefs = PreferenciasUsuario();
  TextEditingController observacionesControlador = new TextEditingController();
  List<File> imagenFile = [];

  @override
  Widget build(BuildContext context) {
    // Data server Url
    final provUsuario = Provider.of<ProvUsuario>(context);
    final size = MediaQuery.of(context).size;

    provUsuario.estadoOrden = prefs.listaEstados[prefs.estado];
    return Scaffold(
      backgroundColor:Color(0xFFf8f5f5) ,
      appBar: AppBar(
          title: Center(
            child: Text("Gestión orden",
                style: TextStyle(
                    color: Color(0xFF036435b),
                    fontSize: size.width * 0.08,
                    fontWeight: FontWeight.bold)),
          ),
          elevation: 0,
          backgroundColor: Color(0xFFf8f5f5),
          leading: new IconButton(
              icon: new Icon(
                FontAwesomeIcons.times,
                color: Color(0xFF036435b),
               
              ),
              onPressed: () {
                Navigator.of(context).pop();
              })),
        key: _scaffoldKey,
        body: Padding(
          padding: EdgeInsets.only(
              bottom: size.height * 0.05, left: size.width * 0.02),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Observaciones:',
                    style: TextStyle(
                        color: Color(
                          0xFF036435b,
                        ),
                        fontSize: size.width * 0.045,
                        fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: observacionesControlador,
                  maxLines: 1,
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
                            // _enviarReporte();
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
                _mostarImagenes(),
                Align(
                  alignment: Alignment.bottomCenter,
                    child: Container(
                     
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
                                    _iconoEstado(),
                                    color: Colors.white,
                                  ),
                                  title: Text(provUsuario.estadoOrden,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600))),
                            ),
                          ),
                          onPressed: () {
                            _onButtonPressed();
                          })),
                ),
              ]),
        ));
  }

  IconData _iconoEstado() {
    IconData icono;
    switch (prefs.estado) {
      case 2:
        icono = FontAwesomeIcons.shoppingBag;
        break;
      case 3:
        icono = FontAwesomeIcons.cashRegister;

        break;
      case 4:
        icono = FontAwesomeIcons.creditCard;

        break;
      case 5:
        icono = FontAwesomeIcons.motorcycle;

        break;
      case 6:
        icono = FontAwesomeIcons.clipboardCheck;

        break;
      case 7:
        icono = FontAwesomeIcons.checkCircle;

        break;
        return icono;
    }
    return icono;
  }

  void _abrirGaleria(BuildContext context) async {
    // ignore: deprecated_member_use
    var pictureFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imagenFile.add(pictureFile);
    });
    Navigator.of(context).pop();
  }

  void _abrirCamara(BuildContext context) async {
    // ignore: deprecated_member_use
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);

    this.setState(() {
      imagenFile.add(picture);
    });
    Navigator.of(context).pop();
  }

  void borrarImagen(image) {
    setState(() {
      imagenFile.remove(image);
    });
  }

  // función que le agrega la fecha como texto a la imagen seleccionada

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
      return Text("Sin selecionar imagen");
    }
  }

  //this widget paint  call the aditional services provider and create a iterable list

  _onButtonPressed() async {
    final provUsuario = Provider.of<ProvUsuario>(context);
    int numeroFoto = 0;
    String nombreFoto = "_" + "DOMICILIOS" + "_" + widget.idPedido.toString() + "_";

    try {
      if (imagenFile.isNotEmpty) {
        imagenFile.forEach((element) async {
          servicios
              .subirAnexo("GESTION_SLCTDINV", nombreFoto, numeroFoto.toString(),
                  element, widget.idPedido.toString())
              .whenComplete(() => servicios.subirFotoAnexo(
                  element, "solicitudinv" + nombreFoto));

          numeroFoto++;
        });
        imagenFile = [];
      }
      if (prefs.estado  == 2) {
       await  servicios.grabarPicking(widget.listaProductos);
      }
      var res = servicios.cambiarEstado(
          widget.idPedido.toString(), prefs.estado, observacionesControlador.text);
      res.then((respuesta) async {
        if (respuesta) {
          prefs.estado += 1;
          provUsuario.estadoOrden = prefs.listaEstados[prefs.estado];
          if (prefs.estado > 4) {
            prefs.ordenFinal = '';
            prefs.pedidoPendiente = false;
            prefs.estado = 1;
            prefs.listaProductos='';

            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomeUsuario()));
          }
        }
      });
    } on Exception catch (e) {
      print(e);
    }
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
