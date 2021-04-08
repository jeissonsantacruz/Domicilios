// To parse this JSON data, do
//
//     final mvtosMensajero = mvtosMensajeroFromJson(jsonString);

import 'dart:convert';

MvtosMensajero mvtosMensajeroFromJson(String str) => MvtosMensajero.fromJson(json.decode(str));

String mvtosMensajeroToJson(MvtosMensajero data) => json.encode(data.toJson());

class MvtosMensajero {
    MvtosMensajero({
        this.radicado,
        this.diligencia,
        this.direccion,
        this.movimiento,
        this.pathImagen
    });

    String radicado;
    String diligencia;
    String direccion;
    String movimiento;
    List<dynamic> pathImagen;

    factory MvtosMensajero.fromJson(Map<String, dynamic> json) => MvtosMensajero(
        radicado   : json["radicado"],
        diligencia : json["diligencia"],
        direccion  : json["direccion"],
        movimiento : json["movimiento"],
        pathImagen : json["pathImagen"]
    );

    Map<String, dynamic> toJson() => {
        "radicado": radicado,
        "diligencia": diligencia,
        "direccion": direccion,
        "movimiento": movimiento,
        "pathImagen": pathImagen
    };
}
