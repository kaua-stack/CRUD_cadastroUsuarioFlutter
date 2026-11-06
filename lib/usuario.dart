
class Usuario {
  int? id; // Identificado do usuário no BD
  String nome; // Nome do usuário
  String email; // E-mail do usuário

  Usuario({
    this.id, // Opcional, pois SQLite pode gerar o ID automáticamente
    required this.nome, // Nome obrigatório
    required this.email, // E-mail Obrigatório
  });
}