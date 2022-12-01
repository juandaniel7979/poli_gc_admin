import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'package:poli_gc_admin/models/usuario.dart';

class AdminService extends ChangeNotifier{


  final String _baseUrl = '192.168.56.1:3001';

  bool _isLoading = true;

  List<Usuario> usuarios = [];
  String _selectedRol = 'PROFESOR';
  List<String> roles = ['PROFESOR', 'ESTUDIANTE'];
  Map<String,List<Usuario>> usersByRol = {};
  // List<Usuario> profesores = [];
  // List<Usuario> estudiantes = [];

  AdminService(){
    roles.forEach((item) {
      usersByRol[item] = List<Usuario>.empty(growable: true);
    });
    getUsuariosByRol(rol: _selectedRol);
    getUsuariosByRol(rol: "ESTUDIANTE");
  }

  bool get isLoading => _isLoading;


  String get selectedRol => _selectedRol;

    set selectedRol( String valor ) {
      _selectedRol = valor;
      _isLoading = true;
      getUsuariosByRol( rol: valor );
      notifyListeners();
    }

  final storage = const FlutterSecureStorage();
  
  List<Usuario> get getUsersPorRol => usersByRol[selectedRol]!;

  List<Usuario> get getProfesores=> usersByRol["PROFESOR"]!;
  List<Usuario> get getEstudiantes=> usersByRol["ESTUDIANTE"]!;






  getUsuariosByRol({ String estado = "pendiente", required String rol})async {
    final Map<String,dynamic> filterData = {
      'rol': rol
    };

    if( usersByRol[rol]!.isNotEmpty  ) {
      _isLoading = false;
      notifyListeners();
      return getUsersPorRol;
    }

    final url = Uri.parse('http://$_baseUrl/api/usuarios/admin/$rol?limite=10&desde=0&estado=$estado');
    // print(url);
    // final token  = await readToken();
    // print(token);
    final resp = await http.get(url);
    print(resp.body);
    print(resp.statusCode);
    final usersResponse = Usuarios.fromJson( resp.body );

    usersByRol[rol]!.addAll(usersResponse.usuarios);
    _isLoading = false;
    // usuarios = [];
    // usuarios.addAll( usersResponse.usuarios );
    notifyListeners();
      return null;
  }


Future manageState( String id, String estado, String rol ) async {
    final token = await storage.read(key: 'token') ?? '';
    final Map<String,dynamic> userData = {
        'estado': estado
    };
    final url = Uri.parse( 'http://$_baseUrl/api/usuarios/admin/$id');
    print(url);
    try {
      if(token ==''){ print('No hay token en el request: '); return null;}
      print(token);
      final resp = await http.put(url,
      body: json.encode(userData),
      headers: {
        "Content-Type": "application/json", 
        'x-token': token
      }
      );
      print(resp.body);  
      // usuarios.remove(value)    
      final Map<String, dynamic> decodedResp = json.decode( resp.body);

      if(resp.statusCode ==200){
        final index = usersByRol[rol]!.indexWhere((element) => element.uid == id);
        usersByRol[rol]![index].estado = estado;
      }

    } catch (e) {
      // print(e);
      // isSaving = false;
    }
  }


  Future<String> readToken() async {

    return await storage.read(key: 'token') ?? '';
  
  }


}

