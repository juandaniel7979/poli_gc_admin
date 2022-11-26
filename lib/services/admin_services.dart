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

  AdminService(){
    roles.forEach((item) {
      usersByRol[item] = List<Usuario>.empty(growable: true);
    });
    getUsuariosByRol(rol: _selectedRol);
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







  getUsuariosByRol({ String estado = "pendiente", required String rol})async {
    final Map<String,dynamic> filterData = {
      'estado': estado,
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


Future ApproveUser( String id, String estado ) async {
    final Map<String,dynamic> userData = {
        '_id': id,
        'estado': estado
    };
    print(estado);
    final url = Uri.parse( '$_baseUrl/api/categoria');
    try {
    final token = await storage.read(key: 'token') ?? '';
    if(token ==''){ print('No hay token en el request: '); return null;}
    print(token);
    final resp = await http.post(url,
    body: json.encode(userData),
    headers: {
      "Content-Type": "application/json", 
      'x-token': token
    }
    ).timeout(const Duration(seconds: 30));
    print(resp.body);  
    // usuarios.remove(value)    
    final Map<String, dynamic> decodedResp = json.decode( resp.body);

    // if( decodedResp.containsKey('id_profesor')) {
    //   return null;
    // }else{
    //   print(decodedResp['errors'][0]);
    //   return 'error';
    // }
      
    } catch (e) {
      // print(e);
      // isSaving = false;
    }
  }


  Future<String> readToken() async {

    return await storage.read(key: 'token') ?? '';
  
  }


}

