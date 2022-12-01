// To parse this JSON data, do
//
//     final category = categoryFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class Usuarios {
    Usuarios({
        this.tpendientes,
        this.taprobados,
        this.trechazados,
        required this.usuarios,
    });

    int? tpendientes;
    int? taprobados;
    int? trechazados;
    final List<Usuario> usuarios;

    factory Usuarios.fromJson(String str) => Usuarios.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Usuarios.fromMap(Map<String, dynamic> json) => Usuarios(
        tpendientes: json["Tpendientes"],
        taprobados: json["Taprobados"],
        trechazados: json["Trechazados"],
        usuarios: List<Usuario>.from(json["usuarios"].map((x) => Usuario.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "Tpendientes": tpendientes,
        "Taprobados": taprobados,
        "Trechazados": trechazados,
        "usuarios": List<dynamic>.from(usuarios.map((x) => x.toMap())),
    };
}

class Usuario {
    Usuario({
        required this.nit,
        required this.nombre,
        this.nombre2,
        required this.apellido,
        this.apellido2,
        this.imagen,
        required this.correo,
        required this.rol,
        required this.estado,
        this.uid,
    });

    final String nit;
    final String nombre;
    String? nombre2;
    final String apellido;
    String? apellido2;
    String? imagen;
    final String correo;
    final String rol;
    String estado;
    final String? uid;

    get nombreCompleto => '$nombre ${nombre2 == null ? '' : nombre2} $apellido ${apellido2==null ? '' : apellido2}';


    factory Usuario.fromJson(String str) => Usuario.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Usuario.fromMap(Map<String, dynamic> json) => Usuario(
        nit: json["nit"],
        nombre: json["nombre"],
        nombre2: json["nombre_2"] == null ? null : json["nombre_2"],
        apellido: json["apellido"],
        apellido2: json["apellido_2"]  == null ? null : json["apellido_2"],
        correo: json["correo"],
        imagen: json["imagen"]  == null ? null : json["imagen"],
        rol: json["rol"],
        estado: json["estado"],
        uid: json["uid"],
    );

    Map<String, dynamic> toMap() => {
        "nit": nit,
        "nombre": nombre,
        "nombre_2": nombre2 == null ? null : nombre2,
        "apellido": apellido,
        "apellido_2": apellido2 == null ? null : nombre2,
        "correo": correo,
        "rol": rol,
        "estado": estado,
        "uid": uid,
    };
}

