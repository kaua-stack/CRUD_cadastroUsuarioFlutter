import 'package:cadastro_cliente/banco_local.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MeuAplicativo());
}

// Classe principal do APP.
class MeuAplicativo extends StatelessWidget {
  const MeuAplicativo({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaInicial(),
    );
  }
}

// Tela de Cadastro e consulta
class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  final banco = BancoLocal();

  final id = TextEditingController();
  final nome = TextEditingController();
  final email = TextEditingController();

  String resultado = '';

  // Cadastra um usuário no SQLite
  Future<void> cadastrarUsuario() async {
    // Valida se os campos foram preenchidos
    if (nome.text.isEmpty || email.text.isEmpty) {
      setState(() {
        resultado = 'Preencha todos os Campos!!!';
      });
      return;
    }

    try {
      // Envia os dados para o BD
      await banco.cadastrar(nome.text, email.text);

      nome.clear();
      email.clear();

      setState(() {
        resultado = 'Usuário cadastrado com SUCESSO!!!';
      });
    } catch (e) {
      setState(() {
        resultado = 'ERRO ao cadastrar usuário!';
      });
    }
  }


  Future<void>listarUsuarios() async {
    try {
      final usuarios = await banco.listar();

      if (usuarios.isEmpty) {
        setState(() {
          resultado = 'Nenhum usuário cadastrado.';
        });
      } else {
        String lista = '';
        for (var usuario in usuarios) {
          lista += ' Nome: ${usuario['nome']} \n E-mail: ${usuario['email']}, \n\n';
        }
        setState(() {
          resultado = lista;
        });
      }
    } catch (e) {
      setState(() {
        resultado = 'ERRO ao consultar usuários!';
      });
    }
  }


  Future<void> alterarUsuario(int id, String nome, String email) async {
    try {
      final rowsAffected = await banco.alterar(id, nome, email);
      
      if (rowsAffected > 0) {
        setState(() {
          resultado = 'Usuário alterado com sucesso!';
        });
      } else {
        setState(() {
          resultado = 'Nenhum usuário encontrado para alterar.';
        });
      }
    } catch (e) {
      setState(() {
        resultado = 'ERRO ao alterar usuário!';
      });
    }
  }

  Future<void> deletar(int id) async {
    try {
      final rowsAffected = await banco.deletar(id);
      
      if (rowsAffected > 0) {
        setState(() {
          resultado = 'Usuário deletado com sucesso!';
        });
      } else {
        setState(() {
          resultado = 'Nenhum usuário encontrado para deletar.';
        });
      }
    } catch (e) {
      setState(() {
        resultado = 'ERRO ao deletar usuário!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de usuários'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Campo para digitar o nome.
            TextField(
              controller: nome,
              decoration: const InputDecoration(
                labelText: 'Nome',
              ),
            ),

            // Campo para digitar o e-mail.
            TextField(
              controller: email,
              decoration: const InputDecoration(
                labelText: 'E-mail',
              ),
            ),

            TextField(
              controller: id,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'ID',
              ),
            ),

            const SizedBox(height: 20),

            // Botão cadastro
            ElevatedButton(
              onPressed: cadastrarUsuario,
              child: const Text('Cadastrar'),
            ),

            // Botão Consultar
            ElevatedButton(
              onPressed: listarUsuarios,
              child: const Text('Consultar usuários'),
            ),

            //botao para alterar usuario
            ElevatedButton(
              onPressed: () => alterarUsuario(int.tryParse(id.text) ?? 0, nome.text, email.text),
              child: const Text('Alterar usuário'),
            ),


            ElevatedButton(
              onPressed: () => deletar(int.tryParse(id.text) ?? 0), 
              child: const Text('Deletar usuário'),
            ),

            const SizedBox(height: 20),

            // Espaço reservado para exibir os resultados
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  resultado,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}