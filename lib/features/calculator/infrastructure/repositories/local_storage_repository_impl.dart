import 'package:crab/features/calculator/domain/datasources/local_storage_datasource.dart';
import 'package:crab/features/calculator/domain/entities/ticket.dart';
import 'package:crab/features/calculator/domain/repositories/local_storage_repository.dart';

class LocalStorageRepositoryImpl extends LocalStorageRepository {
  final LocalStorageDatasource datasource;
  LocalStorageRepositoryImpl({required this.datasource});

  @override
  Future<List<Ticket>> getTickets() {
    return datasource.getTickets();
  }

  @override
  Future<List<Ticket>> getTicketsByDate(DateTime date) {
    return datasource.getTicketsByDate(date);
  }

  @override
  Future<void> saveTicket(Ticket ticket) {
    return datasource.saveTicket(ticket);
  }
  
  @override
  Future<void> deleteTicket(Ticket ticket) {
    return datasource.deleteTicket(ticket);
  }
}
