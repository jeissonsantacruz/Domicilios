
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:suweb_domicilios/arquitectura/preferenciasUsuario.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:suweb_domicilios/ambientes.dart' as global;


//MENU DRAWER CLASS
class MenuWidget extends StatelessWidget {
  final TextEditingController feedController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final prefs = new PreferenciasUsuario();
    final size  = MediaQuery.of(context).size;
    return Drawer(
        child: Container(
            color: Color(0xFF4F5C70),
            child: ListView(padding: EdgeInsets.zero, children: <Widget>[
              DrawerHeader(
                child: Container(
                    margin:
                         EdgeInsets.all(size.width*0.033),
                    child:
                        Image(image:  NetworkImage(global.url + 'images/logo_GS_texto_blanco.png',
                    ),width: size.width*0.25,
                    
                      )),
              ),

              // content the perfil data and  go to page info user
              Container(
                child: Column(
                  children: [
                    ListTile(
                        leading: Icon(
                          FontAwesomeIcons.user,
                          color: Colors.white,
                        ),
                        title: Text('Mi ubicación',
                            style: TextStyle(fontSize: size.width*0.033,color: Colors.white)),
                        onTap: () {}),
                    SizedBox(
                      height: size.width*0.033,
                    ),
                    ListTile(
                        leading: Icon(
                          FontAwesomeIcons.locationArrow,
                          color: Colors.white,
                        ),
                        title: Text('Ciudad:',
                            style: TextStyle(fontSize: size.width*0.033,color: Colors.white)),
                        trailing: Text(prefs.empresa==null?'':prefs.empresa,
                            style: TextStyle(fontSize: size.width*0.033,color: Colors.white)),
                        onTap: () {}),
                    ListTile(
                        leading: Icon(
                          FontAwesomeIcons.city,
                          color: Colors.white,
                        ),
                        title: Text('Oficina:',
                            style: TextStyle(fontSize: size.width*0.033,color: Colors.white)),
                        trailing: Text(prefs.oficina==null?'':prefs.oficina,
                            style: TextStyle(fontSize: size.width*0.033,color: Colors.white)),
                        onTap: () {}),
                    ListTile(
                        leading: Icon(
                          FontAwesomeIcons.briefcase,
                          color: Colors.white,
                        ),
                        title: Text('Sección:',
                            style: TextStyle(fontSize: size.width*0.033,color: Colors.white)),
                        trailing: Text(prefs.seccion==null?'':prefs.seccion,
                            style: TextStyle(fontSize: size.width*0.033,color: Colors.white)),
                        onTap: () {})
                  ],
                ),
              ),
              //  redirect to whatsapp  with  a message that content the name.

              SizedBox(
                height: size.width*0.033,
              ),
              Container(
                  child: ListTile(
                      leading: Icon(
                        FontAwesomeIcons.signOutAlt,
                        color: Colors.red,
                      ),
                      title: Text('Cerrar sesión',
                          style: TextStyle(fontSize: size.width*0.033,color: Colors.white)),
                      onTap: () {
                        Alert(
                          context: context,
                          title: "Sesión",
                          desc: "¿Desea cerrar sesión?",
                          buttons: [
                            DialogButton(
                                child: Text(
                                  "No",
                                  style: TextStyle(fontSize: size.width*0.033,
                                      color: Colors.white),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                color: Colors.greenAccent[700]),
                            DialogButton(
                                child: Text(
                                  "Si",
                                  style: TextStyle(fontSize: size.width*0.033,
                                      color: Colors.white),
                                ),
                                onPressed: () {

                                  prefs.logeado = false;
                                  abrirAplicacion();
                                },
                                color: Colors.redAccent[700]),
                          ],
                        ).show();
                      }))
            ])));
  }
  abrirAplicacion() async {
    final userPreferences = new PreferenciasUsuario();
    if (userPreferences.logeado != true) {
      await LaunchApp.openApp(
        androidPackageName: 'com.sulogistica.suweb_login.sulogistica',
        openStore: false
      ).whenComplete(() => userPreferences.logeado = true);
    }
  }
}
