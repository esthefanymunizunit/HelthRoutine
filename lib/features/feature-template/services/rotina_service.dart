import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Uma atividade da rotina do usuario (o que aparece em "Atividades de Hoje").
class Atividade {
  final String id;
  final String title;
  final String cor; // hex, ex: "#F5BCDD"
  final bool hasTimer;
  final int? timerDurationMinutes;
  final bool isPomodoro;
  final bool concluida;
  final Timestamp? concluidaEm; // quando foi marcada como concluida
  final String origem;
  final String criadoPor;

  Atividade({
    required this.id,
    required this.title,
    required this.cor,
    required this.hasTimer,
    required this.timerDurationMinutes,
    required this.isPomodoro,
    required this.concluida,
    required this.concluidaEm,
    required this.origem,
    required this.criadoPor,
  });

  factory Atividade.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return Atividade(
      id: doc.id,
      title: d['title'] ?? '',
      cor: d['cor'] ?? '#BACDED',
      hasTimer: d['hasTimer'] ?? false,
      timerDurationMinutes: d['timerDurationMinutes'],
      isPomodoro: d['isPomodoro'] ?? false,
      concluida: d['concluida'] ?? false,
      concluidaEm: d['concluida_em'] as Timestamp?,
      origem: d['origem'] ?? '',
      criadoPor: d['criado_por'] ?? '',
    );
  }
}

/// Persistencia da rotina. O e-mail nunca e estatico: vem do Firebase Auth.
class RotinaService {
  final _col = FirebaseFirestore.instance.collection('rotinas');

  User get _user {
    final u = FirebaseAuth.instance.currentUser;
    if (u == null) {
      throw Exception('Nenhum usuario logado.');
    }
    return u;
  }

  // ---------------- READ (tempo real) — usado na Home ----------------
  /// Esconde atividades concluidas ha mais de 24h.
  Stream<List<Atividade>> ouvirAtividades() {
    return _col.where('uid', isEqualTo: _user.uid).snapshots().map((snap) {
      final tempos = <String, Timestamp>{};
      for (final d in snap.docs) {
        tempos[d.id] = (d.data()['criado_em'] as Timestamp?) ?? Timestamp(0, 0);
      }

      final agora = DateTime.now();
      final lista = snap.docs.map(Atividade.fromDoc).where((a) {
        if (a.concluida && a.concluidaEm != null) {
          final marcada = a.concluidaEm!.toDate();
          if (agora.difference(marcada).inHours >= 24) {
            return false; // some da lista depois de 24h
          }
        }
        return true;
      }).toList();

      lista.sort((a, b) => tempos[a.id]!.compareTo(tempos[b.id]!));
      return lista;
    });
  }

  // ---------------- SEED (uma vez) ----------------
  Future<void> seedPadraoSeVazio() async {
    final existentes = await _col
        .where('uid', isEqualTo: _user.uid)
        .limit(1)
        .get();
    if (existentes.docs.isNotEmpty) return;

    final padrao = [
      {'title': 'Caminhar com o cachorro', 'cor': '#F5BCDD', 'hasTimer': false},
      {'title': 'Estudar', 'cor': '#BACDED', 'hasTimer': false},
      {
        'title': 'Meditação Rápida',
        'cor': '#9EB071',
        'hasTimer': true,
        'timerDurationMinutes': 10,
        'isPomodoro': false,
      },
    ];

    final batch = FirebaseFirestore.instance.batch();
    for (final p in padrao) {
      final ref = _col.doc();
      batch.set(ref, {
        ...p,
        'concluida': false,
        'origem': '',
        'criado_por': _user.email,
        'uid': _user.uid,
        'criado_em': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }

  // ---------------- CREATE (append) ----------------
  Future<void> adicionarVarias({
    required String origem,
    required String cor,
    required List<Map<String, dynamic>> tarefas,
  }) async {
    final batch = FirebaseFirestore.instance.batch();
    for (final t in tarefas) {
      final ref = _col.doc();
      batch.set(ref, {
        'title': t['title'],
        'cor': cor,
        'hasTimer': false,
        'concluida': false,
        'origem': origem,
        'criado_por': _user.email, // <- DINAMICO, do Firebase Auth
        'uid': _user.uid,
        'criado_em': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }

  // ---------------- CREATE (uma) — usado pelo "+" (FAB) ----------------
  Future<void> adicionarUma({
    required String title,
    String cor = '#BACDED',
    bool hasTimer = false,
    int? timerDurationMinutes,
    bool isPomodoro = false,
  }) {
    return _col.add({
      'title': title,
      'cor': cor,
      'hasTimer': hasTimer,
      'timerDurationMinutes': timerDurationMinutes,
      'isPomodoro': isPomodoro,
      'concluida': false,
      'origem': '',
      'criado_por': _user.email,
      'uid': _user.uid,
      'criado_em': FieldValue.serverTimestamp(),
    });
  }

  // ---------------- UPDATE genérico (editar título/timer) ----------------
  Future<void> atualizar(String id, Map<String, dynamic> campos) {
    return _col.doc(id).update(campos);
  }

  // ---------------- UPDATE de conclusão (com horário) ----------------
  Future<void> definirConcluida(String id, bool concluida) {
    return _col.doc(id).update({
      'concluida': concluida,
      'concluida_em': concluida ? FieldValue.serverTimestamp() : null,
    });
  }

  // ---------------- DELETE ----------------
  Future<void> remover(String id) {
    return _col.doc(id).delete();
  }
}
