import 'package:sqflite/sqflite.dart'; // Biblioteca do SQLite
import 'package:path/path.dart'; // Manipula caminho

class BancoLocal {

  Database? banco; // Guardando a conexão com o BD

  Future<Database> abrirBanco() async {

    // Reutiliza a conexão se o banco já estiver aberto.
    if (banco != null && banco!.isOpen) {
      return banco!;
    }

    String pasta = await getDatabasesPath(); // Pasta do banco de dados
    String arquivo = join(pasta, 'cadastro.db'); // Nome e local do arquivo
      banco = await openDatabase(
      arquivo, // Caminho completo do BD
      version: 1, // Versão Inicial do BD

      onCreate: (db, version) async {
          await db.execute('''CREATE TABLE usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE
          )
         ''');
        },
      );
      
    return banco!; //Retorna a conexão aberta
  }

  // Cadastro de um novo usuário
  Future<void> cadastrar(String nome, String email) async {

    final db = await abrirBanco();

    await db.insert('usuarios', {'nome': nome, 'email': email});
  }

  // Consulta todos os usuários cadastrados
  //Future<List<Map<String, Object?>>> listar() async {
  Future<List> listar() async {
    final db = await abrirBanco();
    return await db.query('usuarios');
  }

Future<int> alterar(int id, String nome, String email) async {
    final db = await abrirBanco();
    return await db.update(
      'usuarios',
      {'nome': nome, 'email': email},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deletar(int id) async {
    final db = await abrirBanco();
    return await db.delete(
      'usuarios',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
