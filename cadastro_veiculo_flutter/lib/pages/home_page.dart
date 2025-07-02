import 'package:flutter/material.dart';
import 'cadastro_veiculo_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: const Text('Menu Principal'))),
      body: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CadastroVeiculoPage()),
              );
            },
            icon: const Icon(Icons.directions_car),
            label: const Text('Veículos'),
          ),
        ],
      ),
    );
  }
}
