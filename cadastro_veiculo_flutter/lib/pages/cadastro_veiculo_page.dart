import 'package:cadastro_veiculo_flutter/model/veiculo.dart';
import 'package:flutter/material.dart';
import '../services/veiculo_service.dart';

class CadastroVeiculoPage extends StatefulWidget {
  const CadastroVeiculoPage({super.key});

  @override
  State<CadastroVeiculoPage> createState() => _CadastroVeiculoPageState();
}

class _CadastroVeiculoPageState extends State<CadastroVeiculoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nome = TextEditingController();
  final TextEditingController _modelo = TextEditingController();
  final TextEditingController _ano = TextEditingController();
  final TextEditingController _cor = TextEditingController();
  final TextEditingController _placa = TextEditingController();
  bool _unicoDono = false;

  List<Veiculo> _veiculos = [];
  bool _showForm = false;
  Veiculo? _veiculoEmEdicao;

  @override
  void initState() {
    super.initState();
    _limparFormulario();
    _carregarVeiculos();
  }

  void _salvarVeiculo() async {
    if (_formKey.currentState!.validate()) {
      final veiculo = Veiculo(
        nome: _nome.text,
        modelo: _modelo.text,
        ano: int.tryParse(_ano.text) ?? 0,
        cor: _cor.text,
        placa: _placa.text,
        unicoDono: _unicoDono,
      );

      final sucesso = _veiculoEmEdicao != null
          ? await VeiculoService.atualizarVeiculo(
              _veiculoEmEdicao!.id!, veiculo)
          : await VeiculoService.salvarVeiculo(veiculo);

      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(_veiculoEmEdicao != null
                  ? "Veículo atualizado com sucesso"
                  : "Veículo cadastrado com sucesso")),
        );
        _limparFormulario();
        _carregarVeiculos();
        setState(() => _showForm = false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao cadastrar veículo")),
        );
      }
    }
  }

  void _editarVeiculo(Veiculo veiculo) {
    setState(() {
      _nome.text = veiculo.nome;
      _modelo.text = veiculo.modelo;
      _ano.text = veiculo.ano.toString();
      _cor.text = veiculo.cor;
      _placa.text = veiculo.placa;
      _unicoDono = veiculo.unicoDono;
      _showForm = true;
      _veiculoEmEdicao = veiculo;
    });
  }

  void _confirmarExclusao(Veiculo veiculo) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja excluir o veículo ${veiculo.nome}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final sucesso = await VeiculoService.excluirVeiculo(veiculo.id!);
              if (sucesso) {
                _carregarVeiculos();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Veículo excluído com sucesso')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Erro ao excluir veículo')),
                );
              }
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _carregarVeiculos() async {
    final lista = await VeiculoService.listarVeiculos();
    setState(() {
      _veiculos = lista;
    });
  }

  void _limparFormulario() {
    _formKey.currentState?.reset();
    _nome.clear();
    _modelo.clear();
    _ano.clear();
    _cor.clear();
    _placa.clear();
    _unicoDono = false;
    _veiculoEmEdicao = null;
  }

  Widget _buildListaVeiculos() {
    if (_veiculos.isEmpty) {
      return const Text('Nenhum veículo cadastrado.');
    }

    return Column(
      children: _veiculos.map((veiculo) {
        return Card(
          child: ListTile(
            title: Text('${veiculo.nome} - ${veiculo.modelo}'),
            subtitle: Text(
                'Ano: ${veiculo.ano}, Cor: ${veiculo.cor}, Placa: ${veiculo.placa}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orange),
                  onPressed: () => _editarVeiculo(veiculo),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmarExclusao(veiculo),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFormulario() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nome,
            decoration: const InputDecoration(labelText: 'Nome'),
            validator: (v) => v!.isEmpty ? 'Informe o nome' : null,
          ),
          TextFormField(
            controller: _modelo,
            decoration: const InputDecoration(labelText: 'Modelo'),
            validator: (v) => v!.isEmpty ? 'Informe o modelo' : null,
          ),
          TextFormField(
            controller: _ano,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Ano'),
          ),
          TextFormField(
            controller: _cor,
            decoration: const InputDecoration(labelText: 'Cor'),
          ),
          TextFormField(
            controller: _placa,
            decoration: const InputDecoration(labelText: 'Placa'),
          ),
          SwitchListTile(
            title: const Text('Único Dono?'),
            value: _unicoDono,
            onChanged: (val) => setState(() => _unicoDono = val),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _salvarVeiculo,
            child: const Text('Salvar'),
          ),
          const Divider(thickness: 2),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Veículos')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: Icon(_showForm ? Icons.close : Icons.add),
              label: Text(_showForm ? 'Cancelar' : 'Novo Veículo'),
              onPressed: () => setState(() => _showForm = !_showForm),
            ),
            const SizedBox(height: 10),
            if (_showForm) _buildFormulario(),
            const SizedBox(height: 10),
            _buildListaVeiculos(),
          ],
        ),
      ),
    );
  }
}
