import 'package:flutter/material.dart';
import '../../../../data/models/album.dart';
import '../../../../data/services/collection_service.dart';
import '../../../../data/services/api_service.dart';

class AddAlbumScreen extends StatefulWidget {
  const AddAlbumScreen({super.key});

  @override
  State<AddAlbumScreen> createState() => _AddAlbumScreenState();
}

class _AddAlbumScreenState extends State<AddAlbumScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  final _releaseDateController = TextEditingController();
  final _versionController = TextEditingController();
  String _albumType = 'Album';
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _artistController.dispose();
    _releaseDateController.dispose();
    _versionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _releaseDateController.text = '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
      });
    }
  }

  Future<void> _saveAlbum() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Aquí deberías llamar a un método para añadir el álbum a la colección
      // Por ahora, simulamos la operación
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Álbum añadido a tu colección')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al añadir álbum: $e')),
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
        title: const Text('Añadir Álbum'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveAlbum,
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
              // Imagen del álbum
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
                        Icons.album,
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
              
              // Título del álbum
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título del álbum',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce el título del álbum';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Artista/Grupo
              TextFormField(
                controller: _artistController,
                decoration: const InputDecoration(
                  labelText: 'Artista/Grupo',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce el artista o grupo';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Tipo de álbum
              DropdownButtonFormField<String>(
                value: _albumType,
                decoration: const InputDecoration(
                  labelText: 'Tipo de álbum',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Album', child: Text('Álbum')),
                  DropdownMenuItem(value: 'EP', child: Text('EP')),
                  DropdownMenuItem(value: 'Single', child: Text('Single')),
                  DropdownMenuItem(value: 'Compilation', child: Text('Recopilatorio')),
                  DropdownMenuItem(value: 'Soundtrack', child: Text('Banda Sonora')),
                ],
                onChanged: (value) {
                  setState(() {
                    _albumType = value!;
                  });
                },
              ),
              
              const SizedBox(height: 16),
              
              // Fecha de lanzamiento
              TextFormField(
                controller: _releaseDateController,
                decoration: InputDecoration(
                  labelText: 'Fecha de lanzamiento',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _selectDate,
                  ),
                ),
                readOnly: true,
                onTap: _selectDate,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecciona una fecha';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Versión
              TextFormField(
                controller: _versionController,
                decoration: const InputDecoration(
                  labelText: 'Versión (opcional)',
                  border: OutlineInputBorder(),
                  hintText: 'Ej: Versión estándar, Versión limitada, etc.',
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
              
              const SizedBox(height: 24),
              
              // Botón de guardar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveAlbum,
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