import 'package:flutter/material.dart';
import 'package:poli_gc_admin/models/usuario.dart';
import 'package:poli_gc_admin/services/admin_services.dart';
import 'package:poli_gc_admin/services/search_service.dart';
import 'package:provider/provider.dart';

class PoliSearchDelegate extends SearchDelegate{

  @override
  // TODO: implement searchFieldLabel
  // String? get searchFieldLabel => super.searchFieldLabel;
  String? get searchFieldLabel => 'Buscar usuario';


  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
        )
    ];

  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null), 
      icon: Icon(Icons.arrow_back_ios)
      );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Text('buildActions'); 
  }

  Widget _emptyContainer() {
    return Container(
            child: const Center(
              child: Icon(Icons.movie_creation_outlined, color: Colors.black38, size: 100,),
            ),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if( query.isEmpty) {
      return _emptyContainer();
    }

    final searchService = Provider.of<SearchService>(context);
    searchService.getSuggestionByQuery( query );
    // return FutureBuilder(
    //   future: searchService.searchMovies(query),
    //   builder: ( _, AsyncSnapshot<List<Usuario>> snapshot ) {
    //     if( !snapshot.hasData ) return _emptyContainer();   
    //     final usuarios = snapshot.data!;
    //     return ListView.builder(
    //       itemCount: usuarios.length,
    //       itemBuilder: ( _, int index) => _UserItem(usuarios[index]),
    //     );
    //   },
    // );
    return StreamBuilder(
      stream: searchService.suggestionStream,
      builder: ( _, AsyncSnapshot<List<Usuario>> snapshot ) {
        if( !snapshot.hasData ) return _emptyContainer();
        
        final usuarios = snapshot.data!;
        return ListView.builder(
          itemCount: usuarios.length,
          itemBuilder: ( _, int index) => _UserItem(usuarios[index]),
        );
      },
    );
  }

}

class _UserItem extends StatelessWidget {
  final Usuario usuario;
  const _UserItem(this.usuario);

  @override
  Widget build(BuildContext context) {
    
    final adminService = Provider.of<AdminService>(context);
    // usuario.heroId = 'search-${ usuario.id }';

    return Container(
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
                        Text(usuario.nombreCompleto, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.start,),
                        Text(usuario.uid!, style: const TextStyle(fontSize: 12), textAlign: TextAlign.start,),
                        Text(usuario.estado, style: const TextStyle(fontSize: 12), textAlign: TextAlign.start,),
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
                          child: IconButton(onPressed: (){
                              adminService.manageState(usuario.uid!, "APROBADO", usuario.rol);

                          }, icon: Icon(Icons.check, size: 36, color: Colors.green[600],)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: IconButton(onPressed: (){
                            adminService.manageState(usuario.uid!, "APROBADO", usuario.rol);

                          }, icon: const Icon(Icons.delete, size: 36, color: Colors.red,)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
  }
}