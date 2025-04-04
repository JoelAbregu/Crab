import 'package:flutter/material.dart';
import 'package:crab/config/router/app_router.dart';
import 'package:crab/config/theme/app_theme.dart';
import 'package:crab/features/calculator/infrastructure/datasources/objectbox_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Proveedor para la base de datos ObjectBox
final objectBoxDatasourceProvider = Provider<ObjectBoxDatasource>((ref) {
  throw UnimplementedError(); // Se sobreescribirá en `main`
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa ObjectBox antes de ejecutar la aplicación
  final objectBoxDatasource = await ObjectBoxDatasource.create();

  runApp(
    ProviderScope(
      overrides: [
        objectBoxDatasourceProvider.overrideWithValue(objectBoxDatasource),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      theme: AppTheme().getTheme(),
      title: 'Crab',
      debugShowCheckedModeBanner: false,
    );
  }
}
