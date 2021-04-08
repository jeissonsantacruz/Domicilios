// To parse this JSON data, do
//
//     final domicilio = domicilioFromJson(jsonString);

import 'dart:convert';

Domicilio domicilioFromJson(String str) => Domicilio.fromJson(json.decode(str));

String domicilioToJson(Domicilio data) => json.encode(data.toJson());

class Domicilio {
    Domicilio({
        this.pedido,
        this.ciudad,
        this.tercero,
        this.oficina,
        this.beneficiario,
        this.fecha,
        this.solicitante,
        this.estado,
        this.gestion,
        this.nota,
        this.destinatario,
        this.direccion,
        this.telefono,
        this.formapago,
    });

    String pedido;
    String ciudad;
    String tercero;
    dynamic oficina;
    dynamic beneficiario;
    DateTime fecha;
    String solicitante;
    String estado;
    String gestion;
    String nota;
    String destinatario;
    String direccion;
    String telefono;
    String formapago;

    factory Domicilio.fromJson(Map<String, dynamic> json) => Domicilio(
        pedido: json["PEDIDO"],
        ciudad: json["CIUDAD"],
        tercero: json["TERCERO"],
        oficina: json["OFICINA"],
        beneficiario: json["BENEFICIARIO"],
        fecha: DateTime.parse(json["FECHA"]),
        solicitante: json["SOLICITANTE"],
        estado: json["ESTADO"],
        gestion: json["GESTION"],
        nota: json["nota"],
        destinatario: json["DESTINATARIO"],
        direccion: json["direccion"],
        telefono: json["telefono"],
        formapago: json["formapago"],
    );

    Map<String, dynamic> toJson() => {
        "PEDIDO": pedido,
        "CIUDAD": ciudad,
        "TERCERO": tercero,
        "OFICINA": oficina,
        "BENEFICIARIO": beneficiario,
        "FECHA": "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "SOLICITANTE": solicitante,
        "ESTADO": estado,
        "GESTION": gestion,
        "nota": nota,
        "DESTINATARIO": destinatario,
        "direccion": direccion,
        "telefono": telefono,
        "formapago": formapago,
    };
}
