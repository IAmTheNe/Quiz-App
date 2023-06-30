import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whizz/src/features/auth/data/bloc/login/login_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<LoginCubit>().signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}