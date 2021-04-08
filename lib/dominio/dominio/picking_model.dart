// To parse this JSON data, do
//
//     final pickingProducto = pickingProductoFromJson(jsonString);

import 'dart:convert';

PickingProducto pickingProductoFromJson(String str) => PickingProducto.fromJson(json.decode(str));

String pickingProductoToJson(PickingProducto data) => json.encode(data.toJson());

class PickingProducto {
    PickingProducto({
        this.oidRegistro,
        this.nota,
        this.cant,
        this.oidPedido,
        this.estado,
        this.estadoActualizado,
        this.txtEstado
    });

    String oidRegistro;
    String nota;
    String cant;
    String oidPedido;
    String estado;
    int estadoActualizado;
    String txtEstado;

    factory PickingProducto.fromJson(Map<String, dynamic> json) => PickingProducto(
        oidRegistro: json["oidRegistro"],
        nota: json["nota"],
        cant: json["cant"],
        oidPedido: json["oidPedido"],
        estado: json["estado"],
        estadoActualizado: json["estadoActualizado"],
        txtEstado: json["txtEstado"]
    );

    Map<String, dynamic> toJson() => {
        "oidRegistro": oidRegistro,
        "nota": nota,
        "cant": cant,
        "oidPedido": oidPedido,
        "estado": estado,
        "estadoActualizado": estadoActualizado,
        "txtEstado":txtEstado
    };
}
