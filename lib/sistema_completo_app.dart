import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

Widget exibirNomeComSeloExclusivo({
  required String nome,
  required bool isVerificado,
  required String categoriaSelo,
}) {
  final textoNome = Text(
    nome,
    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
  );

  if (!isVerificado) return textoNome;

  Widget iconeSelo;

  if (categoriaSelo == 'empresa_roupas') {
    iconeSelo = const Icon(Icons.storefront_rounded, color: Colors.orange, size: 18);
  } else if (categoriaSelo == 'supremo_com_asas') {
    iconeSelo = ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue, Colors.purple],
      ).createShader(bounds),
      child: const Icon(Icons.flutter_dash_rounded, color: Colors.white, size: 22),
    );
  } else {
    iconeSelo = const Icon(Icons.verified_rounded, color: Colors.blue, size: 18);
  }

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      textoNome,
      const SizedBox(width: 6),
      iconeSelo,
    ],
  );
}

class PainelDonoApp extends StatefulWidget {
  const PainelDonoApp({super.key});

  @override
  State<PainelDonoApp> createState() => _PainelDonoAppState();
}

class _PainelDonoAppState extends State<PainelDonoApp> {
  final _controllerNome = TextEditingController();
  final _controllerSeguidores = TextEditingController();
  String _seloSelecionado = 'influencer';

  final String emailDoDono = 'renantavaresromanato@gmail.com';

  Future<void> aplicarConfiguracaoDoDono() async {
    if (FirebaseAuth.instance.currentUser?.email != emailDoDono) return;

    final nomeAlvo = _controllerNome.text.trim();
    final novosSeguidores = int.tryParse(_controllerSeguidores.text) ?? 0;

    final busca = await FirebaseFirestore.instance
        .collection('usuarios')
        .where('nome_usuario', isEqualTo: nomeAlvo)
        .get();

    if (busca.docs.isEmpty) return;

    final idDocumento = busca.docs.first.id;
    String seloFinal = _seloSelecionado;

    if (novosSeguidores >= 200000000) {
      seloFinal = 'supremo_com_asas';
    }

    await FirebaseFirestore.instance.collection('usuarios').doc(idDocumento).update({
      'seguidores_count': novosSeguidores,
      'categoriaSelo': seloFinal,
      'isVerificado': _seloSelecionado != 'nenhum',
      'isAssinantePago': false,
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Modificação aplicada com sucesso por você, Renan! 👑')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser?.email != emailDoDono) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            '❌ Erro 403: Acesso Restrito ao Dono',
            style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(title: const Text('Controle Supremo'), backgroundColor: Colors.black),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controllerNome,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Nome do Usuário'),
            ),
            TextField(
              controller: _controllerSeguidores,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Quantidade de Seguidores'),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: _seloSelecionado,
              dropdownColor: Colors.black,
              style: const TextStyle(color: Colors.white),
              items: const [
                DropdownMenuItem(value: 'influencer', child: Text('🔵 Azul (Influenciador)')),
                DropdownMenuItem(value: 'empresa_roupas', child: Text('🟠 Laranja (Empresa/Moda)')),
                DropdownMenuItem(value: 'supremo_com_asas', child: Text('🌈 Com Asas (Supremo)')),
                DropdownMenuItem(value: 'nenhum', child: Text('❌ Remover Selos')),
              ],
              onChanged: (valor) {
                if (valor != null) {
                  setState(() => _seloSelecionado = valor);
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: aplicarConfiguracaoDoDono,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              child: const Text('Mudar Perfil Agora'),
            ),
          ],
        ),
      ),
    );
  }
}

class CadastroSeloLaranja extends StatefulWidget {
  final String idUsuarioLogado;
  const CadastroSeloLaranja({super.key, required this.idUsuarioLogado});

  @override
  State<CadastroSeloLaranja> createState() => _CadastroSeloLaranjaState();
}

class _CadastroSeloLaranjaState extends State<CadastroSeloLaranja> {
  final _controllerNomeMarca = TextEditingController();
  final _controllerCnpj = TextEditingController();
  final _controllerSiteModa = TextEditingController();

  Future<void> enviarPedidoSeloLaranja() async {
    if (_controllerNomeMarca.text.trim().isEmpty || _controllerCnpj.text.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('❌ ERRO: Informe o Nome da Marca e o CNPJ Comercial!'),
          ),
        );
      }
      return;
    }

    await FirebaseFirestore.instance.collection('pedidos_selo_laranja').add({
      'idUsuario': widget.idUsuarioLogado,
      'nome_marca': _controllerNomeMarca.text.trim(),
      'cnpj': _controllerCnpj.text.trim(),
      'site_loja': _controllerSiteModa.text.trim(),
      'status_pedido': 'pendente',
      'data_solicitacao': FieldValue.serverTimestamp(),
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.green, content: Text('Pedido enviado com sucesso! 🟠')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitar Selo Laranja')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controllerNomeMarca,
              decoration: const InputDecoration(labelText: 'Nome da Loja de Roupas (Obrigatório)*'),
            ),
            TextField(
              controller: _controllerCnpj,
              decoration: const InputDecoration(labelText: 'CNPJ Comercial (Obrigatório)*'),
            ),
            TextField(
              controller: _controllerSiteModa,
              decoration: const InputDecoration(labelText: 'Link do Catálogo'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: enviarPedidoSeloLaranja,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('Enviar para Análise'),
            ),
          ],
        ),
      ),
    );
  }
}

class RankingCorridaDasAsas extends StatelessWidget {
  const RankingCorridaDasAsas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('🏆 Corrida pelas Asas Arco-íris', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('usuarios')
            .orderBy('seguidores_count', descending: true)
            .limit(50)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final criadores = snapshot.data!.docs;

          return ListView.builder(
            itemCount: criadores.length,
            itemBuilder: (context, index) {
              final criador = criadores[index];
              final seguidores = criador['seguidores_count'] ?? 0;
              double progresso = seguidores / 200000000;
              if (progresso > 1.0) progresso = 1.0;

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.purpleAccent,
                  child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
                ),
                title: exibirNomeComSeloExclusivo(
                  nome: criador['nome_usuario'] ?? 'Usuário',
                  isVerificado: criador['isVerificado'] ?? false,
                  categoriaSelo: criador['categoriaSelo'] ?? 'influencer',
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$seguidores seguidores', style: const TextStyle(color: Colors.white70)),
                    if (seguidores < 200000000) ...[
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: progresso,
                        backgroundColor: Colors.white10,
                        color: Colors.orangeAccent,
                      ),
                    ] else ...[
                      const Text(
                        '👑 RECORDISTA SUPREMO',
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class MotoresDoAplicativo {
  Future<void> postarNoFeed(String legenda, String usuario) async {
    final ImagePicker picker = ImagePicker();
    final XFile? midia = await picker.pickMedia();
    if (midia == null) return;

    final arquivo = File(midia.path);
    final idFoto = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = FirebaseStorage.instance.ref().child('posts/$idFoto');
    final upload = ref.putFile(arquivo);
    final snap = await upload;
    final urlFinal = await snap.ref.getDownloadURL();

    await FirebaseFirestore.instance.collection('posts').add({
      'usuario': usuario,
      'legenda': legenda,
      'midia_url': urlFinal,
      'data_postagem': FieldValue.serverTimestamp(),
    });
  }

  Future<void> curtirPost(String idPost, String idUsuario) async {
    final ref = FirebaseFirestore.instance.collection('posts').doc(idPost);
    await ref.update({'curtidas': FieldValue.arrayUnion([idUsuario])});
  }

  Future<void> enviarDirect(String idChat, String de, String texto) async {
    await FirebaseFirestore.instance.collection('chats').doc(idChat).collection('mensagens').add({
      'idRemetente': de,
      'texto': texto,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

class SistemaLive {
  late final RtcEngine engine;

  Future<void> ligarLive(String appId, String salaId) async {
    await [Permission.camera, Permission.microphone].request();
    engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(appId: appId));
    await engine.enableVideo();
    await engine.setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
    await engine.setClientRole(ClientRoleType.clientRoleBroadcaster);
    await engine.joinChannel(
      token: '',
      channelId: salaId,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }
}

class TelaAssinaturaSeloPago extends StatelessWidget {
  final String idUsuarioLogado;
  final String tipoSeloDesejado;

  const TelaAssinaturaSeloPago({
    super.key,
    required this.idUsuarioLogado,
    required this.tipoSeloDesejado,
  });

  Future<void> aprovarAssinaturaMensal(BuildContext context) async {
    await FirebaseFirestore.instance.collection('usuarios').doc(idUsuarioLogado).update({
      'isVerificado': true,
      'categoriaSelo': tipoSeloDesejado,
      'isAssinantePago': true,
    });
    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final preco = tipoSeloDesejado == 'influencer' ? 19.90 : 49.90;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Assinar Verificado', style: TextStyle(color: Colors.white, fontSize: 24)),
            const SizedBox(height: 20),
            Text(
              'Preço: R\$ ${preco.toStringAsFixed(2)} / mês',
              style: const TextStyle(color: Colors.green, fontSize: 28),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => aprovarAssinaturaMensal(context),
              child: const Text('Confirmar Pagamento'),
            ),
          ],
        ),
      ),
    );
  }
}
