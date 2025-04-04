import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:crab/features/calculator/presentation/providers/storage/local_storage_provider.dart';
import 'package:crab/features/shared/shared.dart';
import 'package:crab/features/calculator/domain/entities/ticket.dart';
import '../providers/calculator_provider.dart';
import '../widgets/widgets.dart';

class CalculatorView extends ConsumerStatefulWidget {
  const CalculatorView({super.key});

  @override
  ConsumerState<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends ConsumerState<CalculatorView> {
  final controllerWeight = TextEditingController();
  final controllerPrice = TextEditingController();

  @override
  void dispose() {
    controllerWeight.dispose();
    controllerPrice.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.titleLarge!.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );

    final calculator = ref.watch(calculatorProvider);

    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //! Datos del y refresh
                Row(
                  children: [
                    Chip(
                      label: Text(
                        "Día: ${calculator.totalDay?.toStringAsFixed(2)}",
                        style: textTheme,
                      ),
                    ),
                    Spacer(),
                    IconButton.filledTonal(
                      onPressed: () {
                        ref.watch(calculatorProvider.notifier).reset();
                        controllerWeight.clear();
                        controllerPrice.clear();
                      },
                      icon: Icon(Icons.refresh_outlined),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                //! Peso, precio y resultado
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: controllerWeight,
                        obscureText: false,
                        onChanged: (value) {
                          final weight = double.tryParse(value) ?? 0;
                          ref
                              .read(calculatorProvider.notifier)
                              .multiplication(weight, calculator.price ?? 0);
                        },
                        label: "Peso",
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: CustomTextFormField(
                        controller: controllerPrice,
                        obscureText: false,
                        onChanged: (value) {
                          final price = double.tryParse(value) ?? 0;
                          ref
                              .read(calculatorProvider.notifier)
                              .multiplication(calculator.weight ?? 0, price);
                        },
                        label: "Precio",
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color.fromARGB(255, 92, 28, 0),
                        ),
                        child: Center(
                          child: Text(
                            calculator.result!.toStringAsFixed(2),
                            style: textTheme,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 15),

                //! Productos
                ListExpanded(),

                SizedBox(height: 15),

                //! Boton
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Material(
                    color: const Color.fromARGB(255, 0, 20, 136),
                    child: InkWell(
                      onTap: () {
                        if (calculator.result != null &&
                            calculator.result != 0) {
                          ref
                              .read(calculatorProvider.notifier)
                              .addTicket(
                                Ticket(
                                  operation:
                                      "${ListExpanded.selectProduct} ${calculator.weight} Kg x ${calculator.price}",
                                  price: calculator.result!,
                                  color:
                                      ListExpanded.selectProduct == "Pulpa"
                                          ? 0x43FFFFFF
                                          : 0xff404040,
                                ),
                              );
                          ref
                              .read(calculatorProvider.notifier)
                              .calculateTotalDay(calculator.result!);
                        }
                      },
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Center(
                          child: Text("Agregar a lista", style: textTheme),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                ListTicket(),
              ],
            ),
          ),
        ),

        //! Boton Guardar
        Positioned(
          bottom: 15,
          right: 20,
          child: FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 0, 20, 136),
            onPressed: () async {
              if (calculator.totalDay != null && calculator.totalDay != 0) {
                final newTicket = Ticket(
                  operation:
                      ref.read(calculatorProvider.notifier).getOperation(),
                  price: calculator.totalDay!,
                  date: DateTime.now(),
                );
                await ref
                    .read(localStorageRepositoryProvider)
                    .saveTicket(newTicket);

                if (!context.mounted) return;
                Shared.showCustomSnackbar(context, "Ticket guardado");
              }
            },
            child: Icon(Icons.save),
          ),
        ),
      ],
    );
  }
}

class ListTicket extends ConsumerWidget {
  const ListTicket({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tickets = ref.watch(calculatorProvider).listTickets ?? [];
    final textTheme = Theme.of(context).textTheme;

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: tickets.length,
      itemBuilder: (BuildContext context, int index) {
        final ticket = tickets[index];
        return FadeInDown(
          child: Card(
            color: Color(ticket.color),
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              title: Text(
                "S/${ticket.price.toStringAsFixed(2)}",
                  style: textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 18,
                  ),
              ),
              subtitle: Text(
                ticket.operation,
                style: textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () {
                  ref.read(calculatorProvider.notifier).removeTicket(ticket);
                  Shared.showCustomSnackbar(context, "Ticket eliminado");
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
