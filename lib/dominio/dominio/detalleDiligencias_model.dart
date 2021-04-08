// To parse this JSON data, do
//
//     final detalleDiligencia = detalleDiligenciaFromJson(jsonString);

import 'dart:convert';

DetalleDiligencia detalleDiligenciaFromJson(String str) => DetalleDiligencia.fromJson(json.decode(str));

String detalleDiligenciaToJson(DetalleDiligencia data) => json.encode(data.toJson());

class DetalleDiligencia {
    DetalleDiligencia({
        this.datosForm,
        this.infoDiligencia,
        this.infoRemite,
        this.infoDestino,
    });

    DatosForm datosForm;
    InfoDiligencia infoDiligencia;
    InfoRemite infoRemite;
    InfoDestino infoDestino;

    factory DetalleDiligencia.fromJson(Map<String, dynamic> json) => DetalleDiligencia(
        datosForm: DatosForm.fromJson(json["datosForm"]),
        infoDiligencia: InfoDiligencia.fromJson(json["infoDiligencia"]),
        infoRemite: InfoRemite.fromJson(json["infoRemite"]),
        infoDestino: InfoDestino.fromJson(json["infoDestino"]),
    );

    Map<String, dynamic> toJson() => {
        "datosForm": datosForm.toJson(),
        "infoDiligencia": infoDiligencia.toJson(),
        "infoRemite": infoRemite.toJson(),
        "infoDestino": infoDestino.toJson(),
    };
}

class DatosForm {
    DatosForm({
        this.optTipo,
        this.txtRadicado,
        this.optRemite,
        this.cmbOficRemite,
        this.cmbSeccRemite,
        this.txtTercero,
        this.txtContacto,
        this.txtTelefono,
        this.txtDireccion,
        this.cmbCiudad,
        this.optDestino,
        this.txtTercero2,
        this.txtContacto2,
        this.txtTelefono2,
        this.txtDireccion2,
        this.cmbCiudad2,
        this.cmbDiligencia,
        this.txtObservacion,
    });

    String optTipo;
    String txtRadicado;
    String optRemite;
    String cmbOficRemite;
    String cmbSeccRemite;
    String txtTercero;
    dynamic txtContacto;
    dynamic txtTelefono;
    String txtDireccion;
    String cmbCiudad;
    String optDestino;
    String txtTercero2;
    dynamic txtContacto2;
    String txtTelefono2;
    String txtDireccion2;
    String cmbCiudad2;
    String cmbDiligencia;
    String txtObservacion;

    factory DatosForm.fromJson(Map<String, dynamic> json) => DatosForm(
        optTipo: json["optTipo"],
        txtRadicado: json["txtRadicado"],
        optRemite: json["optRemite"],
        cmbOficRemite: json["cmbOficRemite"],
        cmbSeccRemite: json["cmbSeccRemite"],
        txtTercero: json["txtTercero"],
        txtContacto: json["txtContacto"],
        txtTelefono: json["txtTelefono"],
        txtDireccion: json["txtDireccion"],
        cmbCiudad: json["cmbCiudad"],
        optDestino: json["optDestino"],
        txtTercero2: json["txtTercero2"],
        txtContacto2: json["txtContacto2"],
        txtTelefono2: json["txtTelefono2"],
        txtDireccion2: json["txtDireccion2"],
        cmbCiudad2: json["cmbCiudad2"],
        cmbDiligencia: json["cmbDiligencia"],
        txtObservacion: json["txtObservacion"],
    );

    Map<String, dynamic> toJson() => {
        "optTipo": optTipo,
        "txtRadicado": txtRadicado,
        "optRemite": optRemite,
        "cmbOficRemite": cmbOficRemite,
        "cmbSeccRemite": cmbSeccRemite,
        "txtTercero": txtTercero,
        "txtContacto": txtContacto,
        "txtTelefono": txtTelefono,
        "txtDireccion": txtDireccion,
        "cmbCiudad": cmbCiudad,
        "optDestino": optDestino,
        "txtTercero2": txtTercero2,
        "txtContacto2": txtContacto2,
        "txtTelefono2": txtTelefono2,
        "txtDireccion2": txtDireccion2,
        "cmbCiudad2": cmbCiudad2,
        "cmbDiligencia": cmbDiligencia,
        "txtObservacion": txtObservacion,
    };
}

class InfoDestino {
    InfoDestino({
        this.tipo,
        this.destino,
        this.contacto,
        this.telefono,
        this.direccion,
        this.ciudad,
    });

    String tipo;
    String destino;
    dynamic contacto;
    String telefono;
    String direccion;
    String ciudad;

    factory InfoDestino.fromJson(Map<String, dynamic> json) => InfoDestino(
        tipo: json["tipo"],
        destino: json["destino"],
        contacto: json["contacto"],
        telefono: json["telefono"],
        direccion: json["direccion"],
        ciudad: json["ciudad"],
    );

    Map<String, dynamic> toJson() => {
        "tipo": tipo,
        "destino": destino,
        "contacto": contacto,
        "telefono": telefono,
        "direccion": direccion,
        "ciudad": ciudad,
    };
}

class InfoDiligencia {
    InfoDiligencia({
        this.tipo,
        this.radicado,
        this.diligencia,
        this.observacion,
    });

    String tipo;
    String radicado;
    String diligencia;
    String observacion;

    factory InfoDiligencia.fromJson(Map<String, dynamic> json) => InfoDiligencia(
        tipo: json["tipo"],
        radicado: json["radicado"],
        diligencia: json["diligencia"],
        observacion: json["observacion"],
    );

    Map<String, dynamic> toJson() => {
        "tipo": tipo,
        "radicado": radicado,
        "diligencia": diligencia,
        "observacion": observacion,
    };
}

class InfoRemite {
    InfoRemite({
        this.tipo,
        this.ofcRemite,
        this.seccRemite,
        this.remitente,
        this.contacto,
        this.telefono,
        this.direccion,
        this.ciudad,
    });

    String tipo;
    String ofcRemite;
    String seccRemite;
    String remitente;
    dynamic contacto;
    dynamic telefono;
    String direccion;
    String ciudad;

    factory InfoRemite.fromJson(Map<String, dynamic> json) => InfoRemite(
        tipo: json["tipo"],
        ofcRemite: json["ofcRemite"],
        seccRemite: json["seccRemite"],
        remitente: json["remitente"],
        contacto: json["contacto"],
        telefono: json["telefono"],
        direccion: json["direccion"],
        ciudad: json["ciudad"],
    );

    Map<String, dynamic> toJson() => {
        "tipo": tipo,
        "ofcRemite": ofcRemite,
        "seccRemite": seccRemite,
        "remitente": remitente,
        "contacto": contacto,
        "telefono": telefono,
        "direccion": direccion,
        "ciudad": ciudad,
    };
}
