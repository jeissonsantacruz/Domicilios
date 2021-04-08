// To parse this JSON data, do
//
//     final estado = estadoFromJson(jsonString);

import 'dart:convert';

Estado estadoFromJson(String str) => Estado.fromJson(json.decode(str));

String estadoToJson(Estado data) => json.encode(data.toJson());

class Estado {
    Estado({
        this.value,
        this.estado,
    });

    String value;
    String estado;

    factory Estado.fromJson(Map<String, dynamic> json) => Estado(
        value: json["value"],
        estado: json["estado"],
    );

    Map<String, dynamic> toJson() => {
        "value": value,
        "estado": estado,
    };
}
