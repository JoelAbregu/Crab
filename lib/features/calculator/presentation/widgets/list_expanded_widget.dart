import 'package:flutter/material.dart';

enum TypeProduct { pulpa, una }

class ListExpanded extends StatefulWidget {
  static String selectProduct = "Pulpa";

  const ListExpanded({super.key});

  @override
  State<ListExpanded> createState() => _ListExpandedState();
}

class _ListExpandedState extends State<ListExpanded> {
  TypeProduct selectedTypeProduct = TypeProduct.pulpa;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: ExpansionTile(
        collapsedBackgroundColor:
            selectedTypeProduct == TypeProduct.pulpa
                ? const Color.fromARGB(67, 255, 255, 255)
                : Colors.black12,
        title: Text("Selecciona un producto"),
        subtitle: Text(ListExpanded.selectProduct),
        children: [
          RadioListTile<TypeProduct>(
            title: const Text("Pulpa"),
            value: TypeProduct.pulpa,
            groupValue: selectedTypeProduct,
            onChanged: (value) {
              setState(() {
                selectedTypeProduct = value!;
                ListExpanded.selectProduct = "Pulpa";
              });
            },
          ),
          RadioListTile<TypeProduct>(
            title: const Text("Uña"),
            value: TypeProduct.una,
            groupValue: selectedTypeProduct,
            onChanged: (value) {
              setState(() {
                selectedTypeProduct = value!;
                ListExpanded.selectProduct = "Uña";
              });
            },
          ),
        ],
      ),
    );
  }
}
