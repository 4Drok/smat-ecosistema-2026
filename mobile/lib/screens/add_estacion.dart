import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddEstacionScreen extends StatefulWidget {
  const AddEstacionScreen({super.key});

  @override
  State<AddEstacionScreen> createState() => _AddEstacionScreenState();
}

class _AddEstacionScreenState extends State<AddEstacionScreen> {
  // Clave para validar el formulario
  final _formKey = GlobalKey<FormState>();
  
  // Controladores para los campos de texto
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _ubicacionController = TextEditingController();
  
  bool _isSaving = false;

  void _guardarEstacion() async {
    // 1. Validar si los campos están vacíos
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);

      // 2. Llamar al ApiService (que ya usa el Token JWT en el POST)
      bool success = await ApiService().crearEstacion(
        _nombreController.text,
        _ubicacionController.text,
      );

      setState(() => _isSaving = false);

      if (success) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Estación guardada con éxito')),
        );
        Navigator.pop(context, true); // Regresa al Home y avisa que hubo cambios
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Error al guardar. Verifique su sesión.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Estación SMAT'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Registre una nueva estación de monitoreo',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la Estación',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
                validator: (value) => 
                    value!.isEmpty ? 'Por favor ingrese un nombre' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _ubicacionController,
                decoration: const InputDecoration(
                  labelText: 'Ubicación (Lat, Long o Ciudad)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) => 
                    value!.isEmpty ? 'Por favor ingrese la ubicación' : null,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _guardarEstacion,
                  icon: _isSaving 
                      ? const SizedBox.shrink() 
                      : const Icon(Icons.save),
                  label: _isSaving 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('GUARDAR ESTACIÓN'),
                ),
              ),
            ],
          ),
        ),
      ),
    ); 
  }
}