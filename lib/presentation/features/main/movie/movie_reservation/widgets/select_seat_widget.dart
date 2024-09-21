import 'package:flutter/material.dart';

class SelectSeatWidget extends StatefulWidget {
  const SelectSeatWidget({super.key});

  @override
  _SelectSeatWidgetState createState() => _SelectSeatWidgetState();
}

class _SelectSeatWidgetState extends State<SelectSeatWidget> {
  final int rows = 8;
  final int columns = 8;

  List<List<bool>>? selectedSeats;

  @override
  void initState() {
    super.initState();
    // Initialize all seats as not selected
    selectedSeats = List.generate(
        rows, (index) => List.generate(columns, (index) => false));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(rows, (rowIndex) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(columns, (colIndex) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedSeats?[rowIndex][colIndex] =
                        !selectedSeats![rowIndex][colIndex];
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(4.0),
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: selectedSeats![rowIndex][colIndex]
                        ? Colors.orange
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Center(
                    child: Text(getSeatLabel(rowIndex, colIndex),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }

  String getSeatLabel(int row, int col) {
    return '${String.fromCharCode(65 + row)}${col + 1}';
  }
}
