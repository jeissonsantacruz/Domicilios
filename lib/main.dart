//Flutter dependencies

import 'dart:convert';
import 'dart:io';

import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:suweb_domicilios/aplicacion/paginas/Home2.dart';
import 'package:suweb_domicilios/aplicacion/paginas/Picking_page.dart';

import 'aplicacion/paginas/HomeDomicilios_page.dart';
import 'aplicacion/paginas/detalleDomiciliario.dart';
import 'aplicacion/paginas/iniciarSesion_page.dart';
import 'arquitectura/preferenciasUsuario.dart';
import 'arquitectura/proveedorUsuario.dart';
import 'arquitectura/pushNotificaciones.dart';
import 'arquitectura/serviciosGestioncci.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  final pushProvider = PushNotificationProvider();
  final archivoGlobal = File(
      "/storage/emulated/0/Android/data/com.sulogistica.suweb_login.sulogistica/files/db.txt");
  final servicios = ServiciosGestionCci();
  final prefs = new PreferenciasUsuario();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(builder: (context) => ProvUsuario()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: ruta(),
          navigatorKey: navigatorKey,
          routes: {
            'homeUsuario': (context) => HomeUsuario(),
            'SesionRequerida': (context) => SesionRequerida(),
            'domiciliarioPedido': (context) => DetalleTarea(null),
            'shopperPedido': (context) => ShopperProductos(idPedido: prefs.oidPedido),
            'PaginaTabs': (context) => PaginaTabs(),
          },
        ));
  }

  // guarda o actualiza los datos almacenados en la app de login
  Future guardarDatos() async {
    final prefs = new PreferenciasUsuario();
    var estadoPermiso = await Permission.storage.request();
    if (estadoPermiso.isGranted) {
      leerDatos().then((String value) {
        var list = jsonDecode(value);
        prefs.codigo = list[0];
        prefs.empresa = list[1];
        prefs.oficina = list[2];
        prefs.seccion = list[3];
        prefs.oidSeccion= list[4];
        prefs.oidOficinaTercero = list[5];
        
        prefs.logeado = true;
      });
    }
    
  }

  @override
  void initState() {
     guardarDatos();
    // servicios.registrarToken();
    abrirAplicacion();

    super.initState();
    // se inicia las notificaciones push
    pushProvider.initNotifications();
    pushProvider.messages.listen((data) {
      print('Esta es la accion' + data);
    });
  }

  /*
    Esta funcion retorna una ruta(pagina) para la cual sera redirigido el usuario
  */
  Future<String> leerDatos() async {
    try {
      final file = archivoGlobal;
      String body = await file.readAsString();
      return body;
    } catch (e) {
      return e.toString();
    }
  }

  /*
    Esta funcion abre la aplicación de sulogistica (Login)
  */
  ruta<String>() {
    final userPreferences = new PreferenciasUsuario();
    var route;
    // Routes Switch
    if (userPreferences.logeado == true) {
      

     
        route = 'homeUsuario';

        
      
      return route;

      //Check in the server if has an order in progress

    } else {
      return 'SesionRequerida';
    }
  }

  abrirAplicacion() async {
    final userPreferences = new PreferenciasUsuario();
    if (userPreferences.logeado != true) {
      await LaunchApp.openApp(
              androidPackageName: 'com.sulogistica.suweb_login.sulogistica',
              openStore: false)
          .whenComplete(() => userPreferences.logeado = true);
    }
  }
}
