// To parse this JSON data, do
//
//     final opcMvto = opcMvtoFromJson(jsonString);

import 'dart:convert';

OpcMvto opcMvtoFromJson(String str) => OpcMvto.fromJson(json.decode(str));

String opcMvtoToJson(OpcMvto data) => json.encode(data.toJson());

class OpcMvto {
    OpcMvto({
        this.opcion,
        this.pideFoto,
        this.pideObserva,
    });

    String opcion;
    bool pideFoto;
    bool pideObserva;

    factory OpcMvto.fromJson(Map<String, dynamic> json) => OpcMvto(
        opcion: json["opcion"],
        pideFoto: json["pideFoto"],
        pideObserva: json["pideObserva"],
    );

    Map<String, dynamic> toJson() => {
        "opcion": opcion,
        "pideFoto": pideFoto,
        "pideObserva": pideObserva,
    };
}
