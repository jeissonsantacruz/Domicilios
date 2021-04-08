import 'package:shared_preferences/shared_preferences.dart';

/*
  Recordar instalar el paquete de:
    shared_preferences:
  Inicializar en el main
    final prefs = new PreferenciasUsuario();
    await prefs.initPrefs();
    
*/

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia =
      new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // Geters y Seters para la informacion del login

  get codigo {
    return _prefs.getString('codigo' ?? '');
  }

  set codigo(String value) {
    _prefs.setString('codigo', value);
  }
  get empresa {
    return _prefs.getString('empresa' ?? '');
  }
  set empresa(String value) {
    _prefs.setString('empresa', value);
  }
  get oficina {
    return _prefs.getString('oficina' ?? '');
  }

  set oficina(String value) {
    _prefs.setString('oficina', value);
  }
  get seccion {
    return _prefs.getString('seccion' ?? '');
  }

  set seccion(String value) {
    _prefs.setString('seccion', value);
  }
  get logeado {
    return _prefs.getBool('logeado' ?? false);
  }

  set logeado(bool value) {
    _prefs.setBool('logeado', value);
  }
  get oidCasa {
    return _prefs.getString('oidCasa' ?? '');
  }

  set oidCasa(String value) {
    _prefs.setString('oidCasa', value);
  }
  get oidUsuario {
    return _prefs.getString('oidUsuario' ?? '');
  }

  set oidUsuario(String value) {
    _prefs.setString('oidUsuario', value);
  }
  get baseTercero {
    return _prefs.getString('baseTercero' ?? '');
  }

  set baseTercero(String value) {
    _prefs.setString('baseTercero', value);
  }
  get oidSeccion {
    return _prefs.getString('oidSeccion' ?? '');
  }

  set oidSeccion(String value) {
    _prefs.setString('oidSeccion', value);
  }
  get oidOficinaTercero {
      return _prefs.getString('oidOficinaTercero' ?? '');
    }

  set oidOficinaTercero(String value) {
    _prefs.setString('oidOficinaTercero', value);
  }



  // Get y Set del Token del telefono ( notificacioens push)

  get tokenPhone {
    return _prefs.getString('tokenPhone' ?? '');
  }
  
  set tokenPhone(String value) {
    _prefs.setString('tokenPhone', value);
  }

  // Geters y Seters para la data de los domicilios


  // set mvtosPendientesData(List<String> value) {
  //   _prefs.setStringList('mvtosPendientesData', value);
  // }

  // get mvtosPendientesData {
  //   return _prefs.getStringList('mvtosPendientesData') ?? [];
  // }
  // set listaMvtosPendientes(List<String> value) {
  //   _prefs.setStringList('listaMvtosPendientes', value);
  // }

  // get listaMvtosPendientes {
  //   return _prefs.getStringList('listaMvtosPendientes') ?? [];
  // }
  
  //  set listaDiligencias(String value) {
  //   _prefs.setString('listaDiligencias', value);
  // }

  // get listaDiligencias {
  //   return _prefs.getString('listaDiligencias') ?? '';
  // }
  
  // Getters y Setters para  estado del pedido


  get pedidoPendiente {
    return _prefs.getBool('pedidoPendiente') ??false;
  }

  set pedidoPendiente(bool value) {
    _prefs.setBool('pedidoPendiente', value);
  }
  get tipoUsuario {
      return _prefs.getString('tipoUsuario' ?? '');
    }

  set tipoUsuario(String value) {
    _prefs.setString('tipoUsuario', value);
  }
  get estado {
    return _prefs.getInt('estado' ?? 2  ) ;
  }
    set estado(int value) {
    _prefs.setInt('estado', value);
  }
  set listaEstados ( List<String> value){
    _prefs.setStringList('listaEstados', value);
  }

  get listaEstados {
   return   _prefs.getStringList('listaEStados')?? ['Tomar Orden','Solicitado','Picking','En Caja','Pagado','Transporte','Entregado','Realizado'];
  }
    set listaProductos(String value) {
    _prefs.setString('listaProductos', value);
  }

  get listaProductos {
    return _prefs.getString('listaProductos') ?? '';
  }
    set cantidadProducto(String value) {
    _prefs.setString('cantidadProducto', value);
  }

  get cantidadProducto {
    return _prefs.getString('cantidadProducto') ?? '';
  }

  set listaDiligencias(String value) {
    _prefs.setString('listaDiligencias', value);
  }

  get listaDiligencias {
    return _prefs.getString('listaDiligencias') ?? '';
  }
  set listaMvtosPendientes(List<String> value) {
    _prefs.setStringList('listaMvtosPendientes', value);
  }

  get listaMvtosPendientes {
    return _prefs.getStringList('listaMvtosPendientes') ?? [];
  }
  set ordenFinal(String value) {
    _prefs.setString('ordenFinal', value);
  }
  get ordenFinal {
      return _prefs.getString('ordenFinal' ?? '');
    }
    // preferencias de detalle 
   set datosDetallePed(List<String> value) {
    _prefs.setStringList('datosDetallePed', value);
  }

  get datosDetallePed {
    return _prefs.getStringList('datosDetallePed') ?? [];
  }
   set oidPedido(String value) {
    _prefs.setString('oidPedido', value);
  }
  get oidPedido {
      return _prefs.getString('oidPedido') ?? '';
    }

  
}
