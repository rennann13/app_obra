class AuthUser {
  const AuthUser({
    required this.id,
    required this.nome,
    required this.tipoUser,
    required this.token,
  });

  final int id;
  final String nome;
  final String tipoUser;
  final String token;

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nome: json['nome']?.toString() ?? '',
      tipoUser: json['tipo_user']?.toString() ?? '',
      token: json['token']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'tipo_user': tipoUser,
      'token': token,
    };
  }
}
