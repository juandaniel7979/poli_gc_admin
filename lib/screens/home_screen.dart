import 'package:flutter/material.dart';
import 'package:poli_gc_admin/search/search_delegate.dart';
import 'package:poli_gc_admin/themes/app_theme.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            icon: const Icon( Icons.search_outlined),
            onPressed: () => showSearch(context: context, delegate: PoliSearchDelegate()) 
            ),
        ],
      ),
      body: const Text('HomeScreen'),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: AppTheme.secondary,
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Icon(Icons.add),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const[
          BottomNavigationBarItem(
            label: 'SOLICITUDES',
            icon: Icon(Icons.person_add)),
          BottomNavigationBarItem(
            label: 'SOLICITUDES',
            icon: Icon(Icons.person_add)),
        ],
      ),
    );
  }
}