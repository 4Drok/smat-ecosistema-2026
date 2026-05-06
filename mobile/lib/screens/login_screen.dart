import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores para capturar el texto de los campos
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  
  bool _isLoading = false; // Estado para el indicador de carga

  // Función principal de Login (Lab 6.2)
  void _handleLogin() async {
    setState(() => _isLoading = true);

    String username = _userController.text.trim();
    String password = _passController.text.trim();

    // Lógica del Reto: AuthService.login valida y guarda el token en SharedPreferences
    bool success = await AuthService().login(username, password);

    setState(() => _isLoading = false);

    if (success) {
      // Si el login es exitoso, navegamos al HomePage (Lista de Estaciones)
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      // Si falla, mostramos error (Lab 6.2)
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Usuario o contraseña incorrectos'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.security, size: 80, color: Colors.blue),
                const SizedBox(height: 20),
                const Text(
                  'SMAT - Autenticación',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                // Campo de Usuario
                TextField(
                  controller: _userController,
                  decoration: const InputDecoration(
                    labelText: 'Usuario',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 20),
                // Campo de Contraseña
                TextField(
                  controller: _passController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 30),
                // Botón de Ingreso
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: _isLoading 
                      ? const CircularProgressIndicator() 
                      : const Text('INGRESAR', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}