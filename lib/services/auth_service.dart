import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mgpx_app/models/auth_user.dart';

class AuthService {
  static const _loginUrl = 'https://393b-45-183-119-154.ngrok-free.app/mgpx/api/auth.php';

  Future<AuthResult> login({
    required String email,
    required String senha,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_loginUrl),
        body: {
          'email': email,
          'senha': senha,
        },
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return const AuthResult.failure('Falha ao acessar o servidor.');
      }

      final bodyJson = _parseResponseBody(response.body);
      if (bodyJson == null) {
        return const AuthResult.failure('Resposta invalida do servidor.');
      }

      final success = bodyJson['success'] == true;
      final message =
          bodyJson['message']?.toString() ?? 'Nao foi possivel fazer login.';

      if (!success) {
        return AuthResult.failure(message);
      }

      final data = bodyJson['data'];
      if (data is! Map<String, dynamic>) {
        return const AuthResult.failure('Dados de usuario invalidos.');
      }

      final user = AuthUser.fromJson(data);
      if (user.token.isEmpty) {
        return const AuthResult.failure('Token nao retornado pelo servidor.');
      }

      return AuthResult.success(user, message);
    } catch (_) {
      return const AuthResult.failure(
        'Nao foi possivel conectar ao servidor de login.',
      );
    }
  }

  Map<String, dynamic>? _parseResponseBody(String body) {
    if (body.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      if (decoded is String) {
        final nested = jsonDecode(decoded);
        if (nested is Map<String, dynamic>) {
          return nested;
        }
      }
    } catch (_) {
      return null;
    }

    return null;
  }
}

class AuthResult {
  const AuthResult._({
    required this.success,
    required this.message,
    this.user,
  });

  final bool success;
  final String message;
  final AuthUser? user;

  factory AuthResult.success(AuthUser user, String message) {
    return AuthResult._(
      success: true,
      message: message,
      user: user,
    );
  }

  const factory AuthResult.failure(String message) = _AuthFailure;
}

class _AuthFailure extends AuthResult {
  const _AuthFailure(String message)
      : super._(
          success: false,
          message: message,
        );
}
