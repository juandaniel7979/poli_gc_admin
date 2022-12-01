import 'package:flutter/material.dart';
import 'package:poli_gc_admin/screens/check_auth_screen.dart';
import 'package:poli_gc_admin/screens/home_screen.dart';
import 'package:poli_gc_admin/screens/login_screen.dart';
import 'package:poli_gc_admin/screens/message_screen.dart';
import 'package:poli_gc_admin/services/admin_services.dart';
import 'package:poli_gc_admin/services/auth_services.dart';
import 'package:poli_gc_admin/services/push_notifications_service.dart';
import 'package:poli_gc_admin/services/search_service.dart';
import 'package:poli_gc_admin/share_preferences/preferences.dart';
import 'package:provider/provider.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();
  await PushNotificationService.initializeApp();
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider( create: ( _ ) => AuthService()),
          ChangeNotifierProvider( create: ( _ ) => AdminService()),
          ChangeNotifierProvider( create: ( _ ) => SearchService()),
      ],
      child: const MyApp(),
      ));

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();
  
  @override
  void initState() {
    super.initState();
    PushNotificationService.messagesStream.listen((message) {
      print('My app: ${message}');

      navigatorKey.currentState?.pushNamed('message', arguments: message);
      
      final snackBar = SnackBar(content: Text(message));
      messengerKey.currentState?.showSnackBar(snackBar);

    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'message',
      navigatorKey: navigatorKey, //Navegar
      scaffoldMessengerKey: messengerKey, //Mostrar snapbar
      routes: {
        'home': ( _ ) => const HomeScreen(),
        'checkout': ( _ ) => const CheckAuthScreen(),
        'login': ( _ ) => const LoginScreen(),
        'message': ( _ ) => const MessageScreen(),
      },
    );
  }
}