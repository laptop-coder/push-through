import 'package:flutter/material.dart';

class DataScreen extends StatelessWidget {
  const DataScreen({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Download data!'));
  }
}
