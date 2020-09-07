// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat_flutter/models/usuario.dart';

UsuariosResponse usuariosResponseFromJson(String str) =>
    UsuariosResponse.fromJson(json.decode(str));

String usuariosResponseToJson(UsuariosResponse data) =>
    json.encode(data.toJson());

class UsuariosResponse {
  UsuariosResponse({
    this.ok,
    this.msg,
    this.usuarios,
    this.pagina,
    this.cantidad,
    this.registros,
    this.continua,
  });

  bool ok;
  String msg;
  List<Usuario> usuarios;
  int pagina;
  int cantidad;
  int registros;
  bool continua;

  factory UsuariosResponse.fromJson(Map<String, dynamic> json) =>
      UsuariosResponse(
        ok: json["ok"],
        msg: json["msg"],
        usuarios: List<Usuario>.from(
            json["usuarios"].map((x) => Usuario.fromJson(x))),
        pagina: json["pagina"],
        cantidad: json["cantidad"],
        registros: json["registros"],
        continua: json["continua"],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": msg,
        "usuarios": List<dynamic>.from(usuarios.map((x) => x.toJson())),
        "pagina": pagina,
        "cantidad": cantidad,
        "registros": registros,
        "continua": continua,
      };
}
