import 'package:flutter/material.dart';
import 'package:poli_gc_admin/themes/app_theme.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Home Screen'),
      ),
      body: Text('HomeScreen'),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: AppTheme.secondary,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Icon(Icons.add),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
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