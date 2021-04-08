// Flutter dependencies
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'preferenciasUsuario.dart';
// Plugins


class PushNotificationProvider {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  final _messagesStreamController = StreamController<String>.broadcast();
  final prefs = new PreferenciasUsuario();
  Stream<String> get messages => _messagesStreamController.stream;

  initNotifications() {
    //getting permission to the user ios/android for send push notifications
    _firebaseMessaging.requestNotificationPermissions();
    //gettinh token from the phone token -> return future
    _firebaseMessaging.getToken().then((token) {
      print('=========FCM TOKEN ==========');
      print(token);
      //save token in the prefs (local db in device)
      prefs.tokenPhone = token.toString();
      print(prefs.tokenPhone);
    });

    //Configuring the different cases to recieve push notifications
    _firebaseMessaging.configure(onMessage: (info) async {
      //when the app is open
      print('======= ON MESSAGE ======');
      print(info);
    
      //default no data
      String argument = 'no-data';
      if (Platform.isAndroid) {
        argument = info['data']['accion'] ?? 'no-data';
      } else if(Platform.isIOS) {
        argument = info['accion'] ?? 'no-data-ios';
      }

      _messagesStreamController.sink.add(argument);
    }, onLaunch: (info) async {
      //when the app is running in the background (still alive)
      print('======= ON Launch ======');
      print(info);
    }, onResume: (info) async {
      //when the app is dead in the foreground
      print('======= ON Resume ======');
      print(info);

      String noti = info['data']['number'];
      print(noti);
    });
  }

  dispose() {
    _messagesStreamController?.close();
  }
}