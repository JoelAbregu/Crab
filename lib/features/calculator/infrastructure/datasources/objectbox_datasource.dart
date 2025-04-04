import 'package:crab/features/calculator/domain/datasources/local_storage_datasource.dart';
import 'package:crab/features/calculator/domain/entities/ticket.dart';
import 'package:crab/features/shared/shared.dart';
import 'package:crab/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';

class ObjectBoxDatasource extends LocalStorageDatasource {
  late final Store store;
  late final Box<Ticket> ticketBox;

  ObjectBoxDatasource._create(this.store) {
    ticketBox = store.box<Ticket>();
  }

  /// Método para inicializar la base de datos
  static Future<ObjectBoxDatasource> create() async {
    final dir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: dir.path);
    return ObjectBoxDatasource._create(store);
  }

  @override
  Future<List<Ticket>> getTickets() async {
    return ticketBox.getAll().reversed.toList();
  }

  @override
  Future<List<Ticket>> getTicketsByDate(DateTime date) async {
    final normalizedDate = Shared.normalizeDate(date);
    return ticketBox
        .query(Ticket_.date.equals(normalizedDate.millisecondsSinceEpoch))
        .build()
        .find();
  }

  @override
  Future<void> saveTicket(Ticket ticket) async {
    final normalizedDate = Shared.normalizeDate(ticket.date);

    // Buscar si ya existe un ticket en la misma fecha
    final existingTicket =
        ticketBox
            .query(Ticket_.date.equals(normalizedDate.millisecondsSinceEpoch))
            .build()
            .findFirst();

    if (existingTicket != null) {
      // Si ya existe, actualiza los valores necesarios
      existingTicket.price = ticket.price;
      existingTicket.operation = ticket.operation;
      ticketBox.put(existingTicket);
    } else {
      // Si no existe, guarda el nuevo ticket con la fecha normalizada
      ticket.date = normalizedDate;
      ticketBox.put(ticket);
    }
  }
  
  @override
  Future<void> deleteTicket(Ticket ticket) async{
    ticketBox.remove(ticket.id);
  }
}
