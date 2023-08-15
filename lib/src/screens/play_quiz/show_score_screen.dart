import 'package:flutter/material.dart';

class ShowScoreScreen extends StatelessWidget {
  const ShowScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Show Score'),
      ),
      body: Column(
        children: [
          ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Text('${index + 1}'),
                title: const Text('Trần Nguyên Thế'),
                trailing: const Text('1000'),
              );
            },
          ),
        ],
      ),
    );
  }
}
