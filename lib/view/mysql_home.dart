import 'package:flutter/material.dart';

class MySQLHome extends StatefulWidget {
  const MySQLHome({super.key});

  @override
  State<MySQLHome> createState() => _MySQLHomeState();
}

class _MySQLHomeState extends State<MySQLHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '한국의 맛집 탐방',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
      ),
    );
  }
} // End
