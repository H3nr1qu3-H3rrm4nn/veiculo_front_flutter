import 'package:cadastro_veiculo_flutter/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Veículos',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
