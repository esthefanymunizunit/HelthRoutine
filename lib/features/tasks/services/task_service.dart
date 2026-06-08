import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskModel {
  final String id;
  final String title;
  final bool isEssential;
  final bool hasTimer;
  final int? timerDurationMinutes;
  final bool isPomodoro;
  final bool concluida;
  final Timestamp? concluidaEm; 
  final String criadoPor;
  final String colorKey;

  TaskModel({
    required this.id,
    required this.title,
    required this.isEssential,
    required this.hasTimer,
    this.timerDurationMinutes,
    required this.isPomodoro,
    required this.concluida,
    this.concluidaEm, 
    required this.criadoPor,
    required this.colorKey,
  });

  factory TaskModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return TaskModel(
      id: doc.id,
      title: d['title'] ?? '',
      isEssential: d['isEssential'] ?? false,
      hasTimer: d['hasTimer'] ?? false,
      timerDurationMinutes: d['timerDurationMinutes'],
      isPomodoro: d['isPomodoro'] ?? false,
      concluida: d['concluida'] ?? false,
      concluidaEm: d['concluida_em'] as Timestamp?,
      criadoPor: d['criado_por'] ?? '',
      colorKey: d['colorKey'] ?? 'blue',
    );
  }
}

class TaskService {
  final _col = FirebaseFirestore.instance.collection('tasks');

  User get _user {
    final u = FirebaseAuth.instance.currentUser;
    if (u == null) throw Exception('Nenhum usuário logado.');
    return u;
  }

 
  Future<void> createTask(Map<String, dynamic> dados) async {
    await _col.add({
      ...dados,
      'concluida': false,
      'concluida_em': null, 
      'origem': 'Tarefa Avulsa',
      'criado_por': _user.email,
      'uid': _user.uid,
      'criado_em': FieldValue.serverTimestamp(),
    });
  }


  Stream<List<TaskModel>> ouvirTasks() {
    return _col.where('uid', isEqualTo: _user.uid).snapshots().map((snap) {
      final tempos = <String, Timestamp>{};
      for (final d in snap.docs) {
        tempos[d.id] = (d.data()['criado_em'] as Timestamp?) ?? Timestamp(0, 0);
      }

      final agora = DateTime.now();
      final lista = snap.docs.map(TaskModel.fromDoc).where((t) {
        if (t.concluida && t.concluidaEm != null) {
          final marcada = t.concluidaEm!.toDate();
          if (agora.difference(marcada).inHours >= 24) return false;
        }
        return true;
      }).toList();

      lista.sort((a, b) => tempos[a.id]!.compareTo(tempos[b.id]!));
      return lista;
    });
  }


  Future<void> updateTask(String id, Map<String, dynamic> dados) async {
    await _col.doc(id).update({
      ...dados,
      'atualizado_em': FieldValue.serverTimestamp(),
    });
  }

  Future<void> toggleConcluida(String id, bool concluida) async {
    await _col.doc(id).update({
      'concluida': concluida,
      'concluida_em': concluida
          ? FieldValue.serverTimestamp()
          : null,
    });
  }

  Future<void> deleteTask(String id) async {
    await _col.doc(id).delete();
  }
}
