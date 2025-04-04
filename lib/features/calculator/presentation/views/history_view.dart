import 'package:crab/features/calculator/presentation/providers/storage/local_storage_provider.dart';
import 'package:crab/features/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crab/features/calculator/domain/entities/ticket.dart';

class HistoryView extends ConsumerStatefulWidget {
  const HistoryView({super.key});

  @override
  ConsumerState<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends ConsumerState<HistoryView> {
  List<Ticket> tickets = [];

  @override
  Widget build(BuildContext context) {
    final localStorageRepository = ref.watch(localStorageRepositoryProvider);
    final colors = Theme.of(context).colorScheme;

    return FutureBuilder<List<Ticket>>(
      future: localStorageRepository.getTickets(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sentiment_neutral_outlined,
                  color: colors.primary,
                  size: 50,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Ohhh no!!",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "No tienes tickets registrados",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          );
        }

        tickets = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: tickets.length,
          itemBuilder: (context, index) {
            final ticket = tickets[index];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Chip(
                  label: Text("${ticket.date.day}/${ticket.date.month}/${ticket.date.year}"),
                ),
                Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Icon(Icons.receipt_long, color: colors.primary),
                    title: Text(
                      "S/ ${ticket.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(ticket.operation),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await ref
                            .read(localStorageRepositoryProvider)
                            .deleteTicket(ticket);
                        if (!context.mounted) return;
                
                        setState(() {
                          tickets.removeAt(index);
                        });
                
                        Shared.showCustomSnackbar(context, "Ticket eliminado");
                      },
                    ),
                  ),
                ),
                Divider()
              ],
            );
          },
        );
      },
    );
  }
}
