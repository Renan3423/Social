import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'sistema_completo_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {
    debugPrint('Firebase não configurado: usando modo demo local');
  }

  runApp(const AppDemoShell());
}

class AppDemoShell extends StatelessWidget {
  const AppDemoShell({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeSocialDemo(),
    );
  }
}

class HomeSocialDemo extends StatelessWidget {
  const HomeSocialDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Social App Demo'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              'Painel principal',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildButton(
              context,
              'Ranking das Asas',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RankingCorridaDasAsas()),
              ),
            ),
            _buildButton(
              context,
              'Painel do Dono',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PainelDonoApp()),
              ),
            ),
            _buildButton(
              context,
              'Solicitar Selo Laranja',
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CadastroSeloLaranja(idUsuarioLogado: 'demo_user'),
                ),
              ),
            ),
            _buildButton(
              context,
              'Assinar selo',
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TelaAssinaturaSeloPago(
                    idUsuarioLogado: 'demo_user',
                    tipoSeloDesejado: 'influencer',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Atenção: este app usa Firebase/Agora. Para testar com dados reais, configure seu projeto e gere as opções do Firebase.',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          minimumSize: const Size.fromHeight(52),
        ),
        child: Text(label),
      ),
    );
  }
}
