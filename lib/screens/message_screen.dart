import 'package:flutter/material.dart';
import 'package:poli_gc_admin/models/usuario.dart';
import 'package:poli_gc_admin/search/search_delegate.dart';
import 'package:poli_gc_admin/services/admin_services.dart';
import 'package:poli_gc_admin/share_preferences/preferences.dart';
import 'package:poli_gc_admin/themes/app_theme.dart';
import 'package:poli_gc_admin/widgets/side_menu.dart';
import 'package:provider/provider.dart';

class MessageScreen extends StatelessWidget {

  static const routerName = 'admin-users';
  const MessageScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final adminService = Provider.of<AdminService>(context);

    final args = ModalRoute.of(context)?.settings.arguments ?? 'no data';
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: [

            IconButton(onPressed: () =>showSearch(context: context, delegate: PoliSearchDelegate()) 
            , icon: const Icon(Icons.search)),
          ],
          backgroundColor: AppTheme.primary,
          title: Padding(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.008),
            child: Text('SOLICITUDES USUARIOS'),
          ),
        ),
        drawer: const SideMenu(),
        body: Container(
          child: Stack(
            children: [
              // Container(
              //   width: double.infinity,
              //   height: 300,
              //   color: Colors.red
              //   ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: TabBar(
                    indicatorColor: AppTheme.secondary,
                    unselectedLabelColor: Colors.black,
                    indicator: BoxDecoration(
                      color: AppTheme.primary
                    ),
                    isScrollable: false,
                    onTap: (value){
                      print(value);
                        switch (value) {
                          case 0:
                            adminService.selectedRol = "PROFESOR";
                            print(adminService.selectedRol);
                            break;
                          case 1:
                            adminService.selectedRol = "ESTUDIANTE";
                            print(adminService.selectedRol);
                            break;
                          default:
                            adminService.selectedRol = "PROFESOR";
                            print(adminService.selectedRol);
                            break;
                        }
                      // adminService.selectedRol = value;
                    },
                    tabs: [
                    Tab(
                      child: Text('PROFESORES'),
                    ),
                    Tab(
                      child: Text('ESTUDIANTES'),
                    ),
                  ]),
                ),
              ),
                Container(
                  margin: EdgeInsets.only(top: 40),
                  child: TabBarView(
                      children: [
                        _ListUsuarios(usuarios: adminService.getProfesores,),
                        _ListUsuarios(usuarios: adminService.getEstudiantes,),
                        // _ListEstudiantes(usuarios: adminService.getUsersPorRol,),
                      ]
                    ),
                )
            ],
          ),
        )
      ),
    );
  }
}

class _ListUsuarios extends StatelessWidget {
  const _ListUsuarios({
    Key? key, required this.usuarios,
  }) : super(key: key);
  final List<Usuario> usuarios;
  @override
  Widget build(BuildContext context) {

  final adminService = Provider.of<AdminService>(context);

    // final usuarios = Provider.of<AdminService>(context).getUsersPorRol;

    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Container(
        decoration: BoxDecoration(
                  color: Preferences.isDarkMode ?  Colors.black45 :Colors.white,
                  borderRadius:  BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
        width: double.infinity,
        height: 300,
        // color: Colors.indigo,
        child: SingleChildScrollView(
          child: Wrap(
            children: [
              ...List.generate(usuarios.length,
              (index) => Container(
                margin: EdgeInsets.all(8),
                height: 100,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      child: CircleAvatar(
                        radius: 25.0,
                        backgroundColor: Colors.cyan,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image(
                            height: 90,
                            image: AssetImage('assets/no-image.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 26, left: 10),
                      width: 180,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(usuarios[index].nombreCompleto, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.start,),
                          Text(usuarios[index].uid!, style: TextStyle(fontSize: 12), textAlign: TextAlign.start,),
                          Text(usuarios[index].estado, style: TextStyle(fontSize: 12), textAlign: TextAlign.start,),
                        ],
                      )
                      ),
                    ]),
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: IconButton(onPressed: ()async{
                                await adminService.manageState(usuarios[index].uid!, "APROBADO", usuarios[index].rol);
                            }, icon: Icon(Icons.check, size: 36, color: Colors.green[600],)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: IconButton(onPressed: (){
                              adminService.manageState(usuarios[index].uid!, "RECHAZADO", usuarios[index].rol);
        
                            }, icon: const Icon(Icons.delete, size: 36, color: Colors.red,)),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
              ),
            ],
          ),
        ),
        ),
    );
  }
}


class _NavegationModel with ChangeNotifier {
  int _paginaActual = 0;

  PageController _pageController = PageController(initialPage: 0);
// eae7a8c6d2f840d1a2595dafe0a195df

  int get paginaActual => this._paginaActual;

  set paginaActual( int valor ) {
    this._paginaActual = valor;
    _pageController.animateToPage(valor, duration: Duration( milliseconds: 250), curve: Curves.easeOut);
    notifyListeners();
  }

  PageController get pageController => _pageController;
}