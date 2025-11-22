// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:byeolpedia_frontend/main.dart';
import 'package:byeolpedia_frontend/data/services/auth_service.dart';

void main() {
  testWidgets('Byeolpedia app smoke test', (WidgetTester tester) async {
    // Create a mock auth service
    final authService = AuthService();
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider<AuthService>(
        create: (context) => authService,
        child: const ByeolpediaApp(),
      ),
    );

    // Verify that the login screen is shown (user is not authenticated)
    expect(find.text('Byeolpedia'), findsOneWidget);
    expect(find.text('Tu tracker de K-Pop'), findsOneWidget);
    expect(find.text('Iniciar Sesión'), findsOneWidget);
    expect(find.text('¿No tienes cuenta?'), findsOneWidget);
  });
}
