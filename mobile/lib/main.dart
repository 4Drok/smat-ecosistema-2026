import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_page.dart';
import 'services/auth_service.dart';

void main() => runApp(const SMATApp());

class SMATApp extends StatelessWidget {
  const SMATApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SMAT Mobile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // El 'home' ahora es dinámico gracias al FutureBuilder
      home: FutureBuilder<String?>(
        future: AuthService().getToken(), // Llama a SharedPreferences
        builder: (context, snapshot) {
          // 1. Mientras la App está leyendo la memoria interna (cargando)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // 2. Si el Future terminó y devolvió un Token válido
          if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
            return const HomePage(); // Usuario ya logueado
          }

          // 3. Si no hay token o ocurrió un error, mostrar Login
          return const LoginScreen();
        },
      ),
    );
  }
}