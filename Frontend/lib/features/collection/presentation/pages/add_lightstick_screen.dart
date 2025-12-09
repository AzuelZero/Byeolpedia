import 'package:flutter/material.dart';
import '../../../../data/models/lightstick.dart';
import '../../../../data/services/lightstick_service.dart';
import '../../../../data/services/api_service.dart';

class AddLightstickScreen extends StatefulWidget {
  const AddLightstickScreen({super.key});

  @override
  State<AddLightstickScreen> createState() => _AddLightstickScreenState();
}

class _AddLightstickScreenState extends State<AddLightstickScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _groupController = TextEditingController();
  final _versionController = TextEditingController();
  final _colorController = TextEditingController();
  final _batteryController = TextEditingController();
  final _featuresController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _groupController.dispose();
    _versionController.dispose();
    _colorController.dispose();
    _batteryController.dispose();
    _featuresController.dispose();
    super.dispose();
  }

  Future<void> _saveLightstick() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Aquí deberías llamar a un método para añadir el lightstick a la colección
      // Por ahora, simulamos la operación
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lightstick añadido a tu colección')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al añadir lightstick: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Lightstick'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveLightstick,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Guardar'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen del lightstick
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.highlight,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Añadir imagen',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Nombre del lightstick
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del lightstick',
                  border: OutlineInputBorder(),
                  hintText: 'Ej: Lightstick Ver. 2, Mini Lightstick, etc.',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce el nombre del lightstick';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Grupo
              TextFormField(
                controller: _groupController,
                decoration: const InputDecoration(
                  labelText: 'Grupo',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce el nombre del grupo';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Versión
              TextFormField(
                controller: _versionController,
                decoration: const InputDecoration(
                  labelText: 'Versión',
                  border: OutlineInputBorder(),
                  hintText: 'Ej: Ver. 1, Ver. 2, Anniversary, etc.',
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Color principal
              TextFormField(
                controller: _colorController,
                decoration: const InputDecoration(
                  labelText: 'Color principal',
                  border: OutlineInputBorder(),
                  hintText: 'Ej: Rosa, Azul, Arcoíris, etc.',
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Tipo de batería
              TextFormField(
                controller: _batteryController,
                decoration: const InputDecoration(
                  labelText: 'Tipo de batería',
                  border: OutlineInputBorder(),
                  hintText: 'Ej: AAA, USB recargable, etc.',
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Características especiales
              TextFormField(
                controller: _featuresController,
                decoration: const InputDecoration(
                  labelText: 'Características especiales',
                  border: OutlineInputBorder(),
                  hintText: 'Ej: Bluetooth, Control remoto, Sincronización con música, etc.',
                ),
                maxLines: 3,
              ),
              
              const SizedBox(height: 24),
              
              // Opciones adicionales
              const Text(
                'Opciones adicionales',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 8),
              
              CheckboxListTile(
                title: const Text('Añadir a mi lista de deseos también'),
                subtitle: const Text('Marcar como deseado además de poseído'),
                value: false, // Aquí iría el estado real
                onChanged: (value) {
                  // Implementar lógica
                },
              ),
              
              CheckboxListTile(
                title: const Text('Funciona correctamente'),
                subtitle: const Text('Confirmar que el lightstick está en buen estado'),
                value: true, // Aquí iría el estado real
                onChanged: (value) {
                  // Implementar lógica
                },
              ),
              
              const SizedBox(height: 24),
              
              // Botón de guardar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveLightstick,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Añadir a mi colección'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}