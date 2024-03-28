import 'package:datafire/src/view/users/alta_users(admin).dart';
import 'package:flutter/material.dart';


class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
      ),
      body: const UsersView(),
    );
  }
}
