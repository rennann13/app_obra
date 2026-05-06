import 'package:flutter/material.dart';
import 'package:mgpx_app/pages/home_screen.dart';
import 'package:mgpx_app/pages/login_screen.dart';
import 'package:mgpx_app/services/auth_storage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MgpxApp());
}

class MgpxApp extends StatelessWidget {
  const MgpxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MGPX App',
      home: const _SessionGate(),
      routes: {
        LoginScreen.routeName: (_) => const LoginScreen(),
        HomeScreen.routeName: (_) => const HomeScreen(),
      },
    );
  }
}

class _SessionGate extends StatefulWidget {
  const _SessionGate();

  @override
  State<_SessionGate> createState() => _SessionGateState();
}

class _SessionGateState extends State<_SessionGate> {
  final _authStorage = AuthStorage();
  late final Future<bool> _hasSession = _authStorage.hasValidSession();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasSession,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final hasSession = snapshot.data ?? false;
        return hasSession ? const HomeScreen() : const LoginScreen();
      },
    );
  }
}
