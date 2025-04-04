import 'package:crab/features/calculator/domain/entities/ticket.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//! 1. Proveer la lógica de la calculadora
final calculatorProvider =
    StateNotifierProvider<CalculatorStateNotifier, CalculatorState>(
      (ref) => CalculatorStateNotifier(),
    );

//! 2. Manejar la lógica de la calculadora
class CalculatorStateNotifier extends StateNotifier<CalculatorState> {
  CalculatorStateNotifier() : super(CalculatorState());

  void multiplication(double weight, double price) {
    state = state.copyWith(
      weight: weight,
      price: price,
      result: weight * price,
    );
  }

  void reset() {
    state = state.copyWith(
      weight: 0,
      result: 0,
      price: 0,
      totalDay: 0,
      listTickets: const [],
    );
  }

  void addTicket(Ticket ticket) {
    state = state.copyWith(listTickets: [ticket, ...state.listTickets!]);
  }

  void removeTicket(Ticket ticket) {
    state = state.copyWith(
      listTickets: state.listTickets!.where((t) => t != ticket).toList(),
    );
    state = state.copyWith(totalDay: state.totalDay! - ticket.price);
  }

  void calculateTotalDay(double result) {
    double totalDay = state.totalDay! + result;
    state = state.copyWith(totalDay: totalDay);
  }

  String getOperation() {
    return state.listTickets!.map((t) => "✅ ${t.operation}").join("\n");
  }
}

//! 3. Estado inicial de la calculadora
class CalculatorState {
  final double? weight;
  final double? price;
  final double? result;
  final double? totalDay;
  final List<Ticket>? listTickets;

  CalculatorState({
    this.weight = 0,
    this.price = 0,
    this.result = 0,
    this.totalDay = 0,
    this.listTickets = const [],
  });

  CalculatorState copyWith({
    double? weight,
    double? price,
    String? operation,
    double? result,
    double? totalDay,
    List<Ticket>? listTickets,
  }) => CalculatorState(
    weight: weight ?? this.weight,
    price: price ?? this.price,
    result: result ?? this.result,
    totalDay: totalDay ?? this.totalDay,
    listTickets: listTickets ?? this.listTickets,
  );
}
