// To parse this JSON data, do
//
//     final mensajesResponse = mensajesResponseFromJson(jsonString);

import 'dart:convert';

MensajesResponse mensajesResponseFromJson(String str) =>
    MensajesResponse.fromJson(json.decode(str));

String mensajesResponseToJson(MensajesResponse data) =>
    json.encode(data.toJson());

class MensajesResponse {
  MensajesResponse({
    this.ok,
    this.msg,
    this.mensajes,
    this.pagina,
    this.cantidad,
    this.registros,
    this.continua,
  });

  bool ok;
  String msg;
  List<Mensaje> mensajes;
  int pagina;
  int cantidad;
  int registros;
  bool continua;

  factory MensajesResponse.fromJson(Map<String, dynamic> json) =>
      MensajesResponse(
        ok: json["ok"],
        msg: json["msg"],
        mensajes: List<Mensaje>.from(
            json["mensajes"].map((x) => Mensaje.fromJson(x))),
        pagina: json["pagina"],
        cantidad: json["cantidad"],
        registros: json["registros"],
        continua: json["continua"],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": msg,
        "mensajes": List<dynamic>.from(mensajes.map((x) => x.toJson())),
        "pagina": pagina,
        "cantidad": cantidad,
        "registros": registros,
        "continua": continua,
      };
}

class Mensaje {
  Mensaje({
    this.from,
    this.to,
    this.mensaje,
    this.createdAt,
    this.updatedAt,
  });

  String from;
  String to;
  String mensaje;
  DateTime createdAt;
  DateTime updatedAt;

  factory Mensaje.fromJson(Map<String, dynamic> json) => Mensaje(
        from: json["from"],
        to: json["to"],
        mensaje: json["mensaje"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "from": from,
        "to": to,
        "mensaje": mensaje,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
