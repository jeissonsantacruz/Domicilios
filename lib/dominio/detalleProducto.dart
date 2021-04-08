// To parse this JSON data, do
//
//     final producto = productoFromJson(jsonString);

import 'dart:convert';

Producto productoFromJson(String str) => Producto.fromJson(json.decode(str));

String productoToJson(Producto data) => json.encode(data.toJson());

class Producto {
    Producto({
        this.oidRegistro,
        this.oidArticulo,
        this.descripcion,
        this.nota,
        this.cantidad,
        this.undmedida,
        this.pdtentrega,
        this.valorUnd,
    });

    String oidRegistro;
    String oidArticulo;
    String descripcion;
    String nota;
    String cantidad;
    String undmedida;
    String pdtentrega;
    int valorUnd;

    factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        oidRegistro: json["oidRegistro"],
        oidArticulo: json["oidArticulo"],
        descripcion: json["descripcion"],
        nota: json["nota"],
        cantidad: json["cantidad"],
        undmedida: json["undmedida"],
        pdtentrega: json["pdtentrega"],
        valorUnd: json["valorUnd"],
    );

    Map<String, dynamic> toJson() => {
        "oidRegistro": oidRegistro,
        "oidArticulo": oidArticulo,
        "descripcion": descripcion,
        "nota": nota,
        "cantidad": cantidad,
        "undmedida": undmedida,
        "pdtentrega": pdtentrega,
        "valorUnd": valorUnd,
    };
}
