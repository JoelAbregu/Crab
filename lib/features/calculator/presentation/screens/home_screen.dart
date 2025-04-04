import 'package:crab/features/calculator/presentation/views/calculator_view.dart';
import 'package:crab/features/calculator/presentation/views/history_view.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const name = "home-screen";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '🦀',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.calculate_outlined), text: 'Calculadora'),
              Tab(icon: Icon(Icons.history_outlined), text: 'Historial'),
            ],
          ),
        ),
        body: TabBarView(children: [CalculatorView(), HistoryView()]),
      ),
    );
  }
}
