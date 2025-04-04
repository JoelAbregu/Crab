import 'package:crab/features/calculator/domain/entities/ticket.dart';

abstract class LocalStorageDatasource {
  Future<void> saveTicket(Ticket ticket);
  Future<List<Ticket>> getTickets();
  Future<List<Ticket>> getTicketsByDate(DateTime date);
  Future<void> deleteTicket(Ticket ticket);
}