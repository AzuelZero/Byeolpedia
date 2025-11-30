import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/app.dart';
import 'shared/providers/theme_provider.dart';
import 'data/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final themeProvider = ThemeProvider();
  await themeProvider.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: const ByeolpediaApp(),
    ),
  );
}