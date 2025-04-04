import 'package:objectbox/objectbox.dart';

// Definir la entidad Ticket para ObjectBox
@Entity()
class Ticket {
  @Id()
  int id = 0; // ObjectBox usa `id` como clave primaria
  String operation;
  double price;
  DateTime date;
  int color;

  Ticket({
    required this.operation,
    required this.price,
    DateTime? date,
    this.color = 0xff000000,
  }) : date = date ?? DateTime.now();
}
