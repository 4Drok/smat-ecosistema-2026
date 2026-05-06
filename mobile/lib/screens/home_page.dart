import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../models/estacion.dart';
import 'login_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Estacion>> futureEstaciones;

  @override
  void initState() {
    super.initState();
    // Cargamos las estaciones al iniciar
    futureEstaciones = ApiService().fetchEstaciones();
  }

  void _refresh() {
    setState(() {
      futureEstaciones = ApiService().fetchEstaciones();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMAT - Monitoreo Movil'),
        elevation: 2,
        actions: [
          // BOTÓN DE LOGOUT (Requerido en el Reto 6.3)
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: () async {
              await AuthService().logout(); // Borra el token de la memoria
              if (!mounted) return;
              
              // Regresa al Login y limpia el historial de navegación
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (Route<dynamic> route) => false, // Esto borra TODAS las rutas anteriores
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Estacion>>(
        future: futureEstaciones,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('❌ Error de conexión', style: TextStyle(fontSize: 18)),
                  ElevatedButton(
                    onPressed: _refresh,
                    child: const Text('Reintentar'),
                  )
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay estaciones disponibles'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final est = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.satellite_alt),
                    ),
                    title: Text(est.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(est.ubicacion),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Aquí podrías navegar al detalle de la estación en el futuro
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refresh,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}