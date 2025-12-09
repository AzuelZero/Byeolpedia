import 'package:flutter/material.dart';
import '../../../../data/models/photocard.dart';
import '../../../../data/services/collection_service.dart';
import '../../../../data/services/api_service.dart';

class AddPhotocardScreen extends StatefulWidget {
  const AddPhotocardScreen({super.key});

  @override
  State<AddPhotocardScreen> createState() => _AddPhotocardScreenState();
}

class _AddPhotocardScreenState extends State<AddPhotocardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _memberController = TextEditingController();
  final _groupController = TextEditingController();
  final _albumController = TextEditingController();
  final _serialNumberController = TextEditingController();
  final _versionController = TextEditingController();
  String _condition = 'Mint';
  String _collectionType = 'Photocard';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _memberController.dispose();
    _groupController.dispose();
    _albumController.dispose();
    _serialNumberController.dispose();
    _versionController.dispose();
    super.dispose();
  }

  Future<void> _savePhotocard() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Aquí deberías llamar a un método para añadir la photocard a la colección
      // Por ahora, simulamos la operación
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photocard añadida a tu colección')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al añadir photocard: $e')),
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
        title: const Text('Añadir Photocard'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _savePhotocard,
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
              // Imagen de la photocard
              Center(
                child: Container(
                  width: 200,
                  height: 280,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo,
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
              
              // Nombre de la photocard
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la photocard',
                  border: OutlineInputBorder(),
                  hintText: 'Ej: Concept Ver. 1, Selfie Ver. 2, etc.',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce el nombre de la photocard';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Miembro del grupo
              TextFormField(
                controller: _memberController,
                decoration: const InputDecoration(
                  labelText: 'Miembro',
                  border: OutlineInputBorder(),
                  hintText: 'Nombre del miembro del grupo',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce el nombre del miembro';
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
              
              // Álbum (opcional)
              TextFormField(
                controller: _albumController,
                decoration: const InputDecoration(
                  labelText: 'Álbum (opcional)',
                  border: OutlineInputBorder(),
                  hintText: 'Álbum al que pertenece la photocard',
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Tipo de colección
              DropdownButtonFormField<String>(
                value: _collectionType,
                decoration: const InputDecoration(
                  labelText: 'Tipo de colección',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Photocard', child: Text('Photocard')),
                  DropdownMenuItem(value: 'Polaroid', child: Text('Polaroid')),
                  DropdownMenuItem(value: 'ID Card', child: Text('ID Card')),
                  DropdownMenuItem(value: 'Trading Card', child: Text('Trading Card')),
                  DropdownMenuItem(value: 'Mini Poster', child: Text('Mini Poster')),
                ],
                onChanged: (value) {
                  setState(() {
                    _collectionType = value!;
                  });
                },
              ),
              
              const SizedBox(height: 16),
              
              // Estado de la photocard
              DropdownButtonFormField<String>(
                value: _condition,
                decoration: const InputDecoration(
                  labelText: 'Estado',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Mint', child: Text('Mint (Perfecto)')),
                  DropdownMenuItem(value: 'Near Mint', child: Text('Near Mint (Casi perfecto)')),
                  DropdownMenuItem(value: 'Good', child: Text('Good (Bueno)')),
                  DropdownMenuItem(value: 'Fair', child: Text('Fair (Regular)')),
                  DropdownMenuItem(value: 'Poor', child: Text('Poor (Malo)')),
                ],
                onChanged: (value) {
                  setState(() {
                    _condition = value!;
                  });
                },
              ),
              
              const SizedBox(height: 16),
              
              // Número de serie (opcional)
              TextFormField(
                controller: _serialNumberController,
                decoration: const InputDecoration(
                  labelText: 'Número de serie (opcional)',
                  border: OutlineInputBorder(),
                  hintText: 'Si es una edición limitada',
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Versión (opcional)
              TextFormField(
                controller: _versionController,
                decoration: const InputDecoration(
                  labelText: 'Versión (opcional)',
                  border: OutlineInputBorder(),
                  hintText: 'Ej: Versión A, Versión B, etc.',
                ),
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
                title: const Text('Disponible para intercambio'),
                subtitle: const Text('Marcar como disponible para intercambiar con otros usuarios'),
                value: false, // Aquí iría el estado real
                onChanged: (value) {
                  // Implementar lógica
                },
              ),
              
              const SizedBox(height: 24),
              
              // Botón de guardar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _savePhotocard,
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