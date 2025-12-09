import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Sección de Apariencia
          _buildSectionHeader('Apariencia'),
          Card(
            child: Column(
              children: [
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return SwitchListTile(
                      title: const Text('Modo oscuro'),
                      subtitle: const Text('Cambiar entre tema claro y oscuro'),
                      value: themeProvider.isDarkMode,
                      onChanged: (value) {
                        themeProvider.toggleTheme();
                      },
                      secondary: const Icon(Icons.dark_mode),
                    );
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Sección de Notificaciones
          _buildSectionHeader('Notificaciones'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Notificaciones push'),
                  subtitle: const Text('Recibir notificaciones de la aplicación'),
                  value: true, // Aquí iría el estado real de las notificaciones
                  onChanged: (value) {
                    // Implementar lógica para activar/desactivar notificaciones
                  },
                  secondary: const Icon(Icons.notifications),
                ),
                SwitchListTile(
                  title: const Text('Notificaciones por email'),
                  subtitle: const Text('Recibir actualizaciones por correo electrónico'),
                  value: false, // Aquí iría el estado real
                  onChanged: (value) {
                    // Implementar lógica para activar/desactivar notificaciones por email
                  },
                  secondary: const Icon(Icons.email),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Sección de Privacidad
          _buildSectionHeader('Privacidad'),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Perfil privado'),
                  subtitle: const Text('Hacer tu perfil visible solo para ti'),
                  trailing: Switch(
                    value: false, // Aquí iría el estado real
                    onChanged: (value) {
                      // Implementar lógica para cambiar privacidad del perfil
                    },
                  ),
                  leading: const Icon(Icons.lock),
                ),
                ListTile(
                  title: const Text('Eliminar cuenta'),
                  subtitle: const Text('Eliminar permanentemente tu cuenta'),
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  onTap: () {
                    _showDeleteAccountDialog();
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Sección de Información
          _buildSectionHeader('Información'),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Acerca de'),
                  subtitle: const Text('Versión 1.0.0'),
                  leading: const Icon(Icons.info),
                  onTap: () {
                    _showAboutDialog();
                  },
                ),
                ListTile(
                  title: const Text('Términos y condiciones'),
                  leading: const Icon(Icons.description),
                  onTap: () {
                    // Navegar a términos y condiciones
                  },
                ),
                ListTile(
                  title: const Text('Política de privacidad'),
                  leading: const Icon(Icons.privacy_tip),
                  onTap: () {
                    // Navegar a política de privacidad
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar cuenta'),
          content: const Text(
            '¿Estás seguro de que quieres eliminar tu cuenta? Esta acción no se puede deshacer.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Implementar lógica para eliminar cuenta
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Funcionalidad no implementada aún')),
                );
              },
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Byeolpedia',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.music_note, size: 48),
      children: [
        const Text('Tu tracker de colección de K-Pop'),
      ],
    );
  }
}