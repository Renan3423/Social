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
    debugPrint('Firebase não configurado. App em modo demo local.');
  }

  runApp(const SocialAppDemo());
}

class SocialAppDemo extends StatelessWidget {
  const SocialAppDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF080B14),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        fontFamily: 'Roboto',
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF090B13),
              Color(0xFF121827),
              Color(0xFF0D1525),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.deepPurple,
                      child: Text('R', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Renan',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Painel principal',
                            style: TextStyle(color: Colors.white60, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'AO VIVO',
                        style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E1B4B), Color(0xFF3B2D7D)],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.35),
                        blurRadius: 18,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Seu impacto hoje',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text(
                            '4.8M',
                            style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'seguidores',
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      LinearProgressIndicator(
                        value: 0.78,
                        minHeight: 8,
                        backgroundColor: Colors.white12,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  children: const [
                    _StatCard(label: 'Views', value: '88k', color: Colors.blue),
                    SizedBox(width: 12),
                    _StatCard(label: 'Live', value: '12', color: Colors.orange),
                    SizedBox(width: 12),
                    _StatCard(label: 'Ranking', value: '#1', color: Colors.green),
                  ],
                ),

                const SizedBox(height: 26),

                const Text(
                  'Ações rápidas',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                _buildActionButton(
                  title: 'Ranking das Asas',
                  subtitle: 'Veja quem está na corrida',
                  color: Colors.deepPurple,
                  onTap: () => null,
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  title: 'Painel do Dono',
                  subtitle: 'Acesso restrito e gestão de perfil',
                  color: Colors.indigo,
                  onTap: () => null,
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  title: 'Solicitar Selo Laranja',
                  subtitle: 'Validação de CNPJ e marca',
                  color: Colors.orange,
                  onTap: () => null,
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  title: 'Assinar selo',
                  subtitle: 'Pagamento e ativação do selo',
                  color: Colors.green,
                  onTap: () => null,
                ),

                const SizedBox(height: 22),

                const Text(
                  'Atenção',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: const Text(
                    'Esta é uma versão visual de demonstração. Para conectar com o backend real do Firebase, configure as chaves do projeto depois.',
                    style: TextStyle(color: Colors.white70, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildActionButton({
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.9), color.withOpacity(0.6)],
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

// A navegação para as telas do módulo principal continua disponível nos widgets do sistema.
// Estas telas ficam em lib/sistema_completo_app.dart.

