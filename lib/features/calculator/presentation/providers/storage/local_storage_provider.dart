import 'package:crab/features/calculator/infrastructure/repositories/local_storage_repository_impl.dart';
import 'package:crab/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Proveedor para el repositorio, ya no es FutureProvider
final localStorageRepositoryProvider = Provider<LocalStorageRepositoryImpl>((
  ref,
) {
  final objectBoxDatasource = ref.watch(objectBoxDatasourceProvider);
  return LocalStorageRepositoryImpl(datasource: objectBoxDatasource);
});
