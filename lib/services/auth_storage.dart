import 'dart:convert';

import 'package:mgpx_app/models/auth_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const _sessionKey = 'auth_session';

  Future<void> saveSession(AuthUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, jsonEncode(user.toJson()));
  }

  Future<AuthUser?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final rawSession = prefs.getString(_sessionKey);
    if (rawSession == null || rawSession.isEmpty) {
      return null;
    }

    try {
      final json = jsonDecode(rawSession) as Map<String, dynamic>;
      final user = AuthUser.fromJson(json);
      if (user.token.isEmpty) {
        return null;
      }
      return user;
    } catch (_) {
      return null;
    }
  }

  Future<bool> hasValidSession() async {
    final session = await getSession();
    return session != null && session.token.isNotEmpty;
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }
}
