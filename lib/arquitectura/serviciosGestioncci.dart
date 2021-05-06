import 'dart:io';

import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:suweb_domicilios/ambientes.dart' as global;
import 'package:suweb_domicilios/arquitectura/preferenciasUsuario.dart';
import 'package:suweb_domicilios/dominio/detalleProducto.dart';
import 'package:suweb_domicilios/dominio/domicilioModelo.dart';
import 'package:suweb_domicilios/dominio/dominio/picking_model.dart';
import 'package:suweb_domicilios/dominio/estadosModelos.dart';

final String urlBase = global.url;

// Clase que contiene los servicios o llamdos post a funcionesGestioncci.php
class ServiciosGestionCci {
  final String url = urlBase + 'controladores/funcionesGestioncci.php';
  final preferenciasUsuario = new PreferenciasUsuario();
  // List _diligencias = new List();
  final prefs = PreferenciasUsuario();
  //=============================================================================== POST BUSCAR USuARIO
  final String urlbuscarUsuario = global.url + 'funcionesLogin.php';
  Future<Map<dynamic, dynamic>> buscarUsuario() async {
    var data = {"funcionphp": 'buscarUsuario', "idUsuario": prefs.codigo};
    var dio = Dio();
    final encodedData = FormData.fromMap(data);
    // make POST request
    Response response = await dio.post(urlbuscarUsuario, data: encodedData);

    final decodeData = jsonDecode(response.data);

    prefs.oidCasa = decodeData['oidEmpresa'];
    prefs.oidUsuario = decodeData['oidUsuario'];

    return decodeData;
  }

  Future<int> tomarDatos(
      String idEmpresa, String idCasa, String idUsuario) async {
    var data = {
      "funcionphp": 'tomarDatos',
      "idCasa": idCasa,
      "idEmpresa": idEmpresa,
      "idUsuario": idUsuario,
      "origen": "0"
    };
    var dio = Dio();
    final encodedData = FormData.fromMap(data);
    // make POST request
    Response response = await dio.post(urlbuscarUsuario, data: encodedData);

    final decodeData = jsonDecode(response.data);

    prefs.baseTercero = decodeData['baseTercero'];

    return 1;
  }

  var urlEstadosSeccion = urlBase + 'controladores/funcionesSecciones.php';
  Future<int> estadosSeccion() async {
    var data = {
      "funcionphp": 'tomarEstados',
      "dispositivo": 'movil',
      "oidSeccion": prefs.oidSeccion,
    };
    var dio = Dio();
    final encodedData = FormData.fromMap(data);
    // make POST request
    Response response = await dio.post(urlEstadosSeccion, data: encodedData);

    final decodeData = jsonDecode(response.data);
    int _estado;
    List<Estado> listaTemp = [];
    if (decodeData["lstActuales"] != []) {
      var listaEstados = decodeData["lstActuales"] as List;
      for (var lista in listaEstados) {
        // if(lista[3]=='2'){
        //   prefs.tipoUsuario = 'shopper';
        //   _estado = 2;
        //   // break;
        // }
        if(lista[3] == '5'){
          _estado = 5;
          break;
        }
        Estado estado = Estado(estado: lista[2], value: lista[3]);
        listaTemp.add(estado);
      }
    }

    return _estado;
  }

  final String urltoken =
      global.url + 'controladores/funcionesNotificacionesPush.php';
  Future<bool> registrarToken() async {
    var data = {
      "funcionphp": 'registrarToken',
      "usuario": prefs.codigo,
      "dispositivo": 'movil',
      "token": prefs.tokenPhone,
      "oidApp": 2
    };
    var dio = Dio();
    final encodedData = FormData.fromMap(data);
    // make POST request
    Response response = await dio.post(urltoken, data: encodedData);
  
    return true;
  }

  final urlDomicilios =
      urlBase + 'controladores/funcionesSolicitudInventario.php';
  // funcion que lista las tareas pendientes

  Future<List<Domicilio>> listarPendientes(bool filtrar) async {
    final prefs = new PreferenciasUsuario();
    List<Domicilio> _diligencias = [];
    await buscarUsuario().then((decodeData) {

    });
    int _tomarRequer = await  estadosSeccion();
    final base = prefs.oficina.split(' -');
    var datosForm = {
      "cmbBase": prefs.oidCasa + ',' + base[0],
      "tipoSeccion": "DOMICILIO",
      "oidOficina": prefs.oidOficinaTercero,
      "cmbClienteFiltro": prefs.oidCasa,
      "conDetalle": "tercero",
      "idProceso": "DOMICILIOS",
      "optEstado": "PENDIENTE",
      "optTipo": "DOMICILIO",
      "tomarRequerido": _tomarRequer == null ?2:_tomarRequer,
      "paraGestion": true,
       "oiddomiciliario":-1
    };
    var datosForm2 = {
      "cmbBase": prefs.oidCasa + ',' + base[0],
      "tipoSeccion": "DOMICILIO",
      "oidOficina": prefs.oidOficinaTercero,
      "conDetalle": "tercero",
      "optEstado": "PENDIENTE",
      "optTipo": "DOMICILIO",
      "oiddomiciliario":int.parse(prefs.oidUsuario),
  
    };
    var data = {
      "funcionphp": "hacerListado",
      "datosForm": filtrar? json.encode(datosForm2):json.encode(datosForm),
      "dispositivo": "movil",
    };
    var dio = Dio();
    final encodedData = FormData.fromMap(data);
    // make POST request
    Response response = await dio
        .post(
          urlDomicilios,
          data: encodedData,
        )
        .catchError((error) async {});

    if (response.data != '' && response.data != []) {
      final decodeData = jsonDecode(response.data);
      var list = decodeData['registros'] as List;
      if (list != null) {
        if (list.isNotEmpty) {
          _diligencias = list.map((i) => Domicilio.fromJson(i)).toList();
          String productosEncode = json.encode(_diligencias);
          prefs.listaDiligencias = productosEncode;
        }
      }
    }

    return _diligencias;
  }

  final String urlEstado =
      urlBase + 'controladores/funcionesDomicilioSeguimiento.php';
  // funcion que lista los historiales de los movimientos de los mensajeros.
  Future<bool> cambiarEstado(
      String idPedido, int estado, String observacion, double latitud , double  longitud) async {
   
     var data = {
      "funcionphp": "actualizarEstado",
      "idUsuario": prefs.oidUsuario,
      "idPedido": idPedido,
      "estado": estado,
      "nota": observacion,
      "dispositivo": "movil",
      "latitud":latitud,
      "longitud" : longitud
    };
    var dio = Dio();
    final encodedData = FormData.fromMap(data);
    // make POST request
    Response response = await dio.post(urlEstado, data: encodedData);
    final decodeData = jsonDecode(response.data);
    if (decodeData["respuesta"] == true) {
      
      return true;
    }
    return false;
  }

  final String urlTomarP =
      urlBase + 'controladores/funcionesDomicilioSeguimiento.php';
  Future<bool> tomarPedido(String idPedido) async {
    var data = {
      "funcionphp": "asignarMensajero",
      "idMensajero": prefs.oidUsuario,
      "idPedido": idPedido,
      "dispositivo": "movil"
    };

    var dio = Dio();
    final encodedData = FormData.fromMap(data);
    // make POST request
    Response response = await dio.post(urlTomarP, data: encodedData);
    final decodeData = jsonDecode(response.data);

    if (decodeData["respuesta"] == true) {
      return true;
    }
    return false;
  }

  final String urlPicking =
      urlBase + 'controladores/funcionesGestionDomicilios.php';

  Future<bool> grabarPicking(List<PickingProducto> items) async {
    var data = {
      "funcionphp": "grabarEstadoItem",
      "oidusuario": prefs.oidUsuario,
      "aDatos": json.encode(items),
      "dispositivo": "movil"
    };

    var dio = Dio();
    final encodedData = FormData.fromMap(data);
    // make POST request
    print(encodedData);
    print(data);
    Response response = await dio.post(urlPicking, data: encodedData);

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

// funcion que guarda ekl registro en la base de datos.
  final urlAnexos = urlBase + "scripts/subirAnexosAndroid.php";
  Future<dynamic> subirAnexo(String ruta, String nombreFoto, String numFoto,
      foto, String oidMovimiento) async {
    var data = {
      "funcionphp": "registrarAnexo",
      "modulo": "GESTION_SLCTDINV",
      "file": foto,
      "oidReg": oidMovimiento,
      "fileName": ruta + nombreFoto + numFoto,
      "nombreAdj": nombreFoto + numFoto,
    };
    var dio = Dio();
    final encodedData = FormData.fromMap(data);
    // make POST request
    Response response = await dio.post(urlAnexos, data: encodedData);
    final decodeData = jsonDecode(response.data);

    return decodeData;
  }

  // funcion que envía la foto de evidencia al servidor
  // se guarda en la ruta : informacion/cci/GESTION_SLCTDINV/oidDii+OidMovimiento+fecha.jpg
  Future<Map<dynamic, dynamic>> subirFotoAnexo(File imagen, String ruta) async {
    var dio = Dio();

    String fileName = imagen.path.split('/').last;

    FormData formData = FormData.fromMap({
      "uploaded_file":
          await MultipartFile.fromFile(imagen.path, filename: fileName),
      "modulo": ruta,
    });
    var response = await dio.post(urlAnexos, data: formData);
    final decodeData = jsonDecode(response.data);

    return (decodeData);
  }

  Future<File> compressFile(File file) async {
    final filePath = file.absolute.path;

    // Create output file path
    // eg:- "Volume/VM/abcd_out.jpeg"
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, outPath,
        minHeight: 1000, minWidth: 1000, quality: 50, rotate: 90);

    return result;
  }

  final String urlProductos =
      urlBase + 'controladores/funcionesSolicitudInventario.php';
  // funcion que lista los historiales de los movimientos de los mensajeros.
  List<Producto> _productos = new List();
  Future<List<Producto>> obtenerProductos(String idPedido) async {
    var data = {
      "funcionphp": "tomarRegistro",
      "tomarDetalle": "S",
      "oidRegistro": idPedido,
      "dispositivo": "movil"
    };
    var dio = Dio();
    final encodedData = FormData.fromMap(data);
    // make POST request
    Response response = await dio.post(urlProductos, data: encodedData);

    if (response.data != '' && response.data != []) {
      final decodeData = jsonDecode(response.data);
      var list = decodeData['aLista'] as List;
      if (list.isNotEmpty) {
        _productos = list.map((i) => Producto.fromJson(i)).toList();

        String productosEncode = json.encode(_productos);
        prefs.listaProductos = productosEncode;

        return _productos;
      }
    }
    return _productos;
  }

  final urlIncidencias =
      urlBase + 'controladores/funcionesGestionDomicilios.php';
  Future<dynamic> grabarIncidencia(String oidPedido, String estado,
      String oidIncidencia, String comentario) async {
    var datos = {
      "txtEstado": estado,
      "oidPedido": oidPedido,
      "estado": 5,
      "notaGral": comentario,
      "vrfactura": "0",
      "oidIncidencia": oidIncidencia,
    };
    var data = {
      "funcionphp": "grabarEstado",
      "aDatos": json.encode(datos),
      "dispositivo": "movil",
      "oidusuario": prefs.oidUsuario
    };
    var dio = Dio();
    final encodedData = FormData.fromMap(data);
    // make POST request
    Response response = await dio.post(urlIncidencias, data: encodedData);
     final decodeData = jsonDecode(response.data);

    return true;
  }
}
