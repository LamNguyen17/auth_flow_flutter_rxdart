import 'package:flutter/material.dart';

class OverviewWidget extends StatelessWidget {
  final String? overview;

  const OverviewWidget({super.key, this.overview});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Overview',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600)),
          Text('$overview'),
        ],
      ),
    );
  }
}