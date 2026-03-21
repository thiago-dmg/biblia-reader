import 'package:flutter/material.dart';

class SupportHomeScreen extends StatelessWidget {
  const SupportHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Suporte')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ListTile(
            leading: const Icon(Icons.help_outline_rounded),
            title: const Text('Perguntas frequentes'),
            subtitle: const Text('Respostas rápidas'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.mail_outline_rounded),
            title: const Text('Contato'),
            subtitle: const Text('Fale com a equipe'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.confirmation_number_outlined),
            title: const Text('Meus chamados'),
            subtitle: const Text('Abrir e acompanhar tickets'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
