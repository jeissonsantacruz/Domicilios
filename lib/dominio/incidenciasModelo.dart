// To parse this JSON data, do
//
//     final incidencias = incidenciasFromJson(jsonString);

import 'dart:convert';

Incidencias incidenciasFromJson(String str) => Incidencias.fromJson(json.decode(str));

String incidenciasToJson(Incidencias data) => json.encode(data.toJson());

class Incidencias {
    Incidencias({
        this.value,
        this.label,
    });

    String value;
    String label;

    factory Incidencias.fromJson(Map<String, dynamic> json) => Incidencias(
        value: json["value"],
        label: json["label"],
    );

    Map<String, dynamic> toJson() => {
        "value": value,
        "label": label,
    };
}
