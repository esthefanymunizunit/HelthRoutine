import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MoodModel {
  final String id;
  final String type;
  final DateTime date;

  MoodModel({required this.id, required this.type, required this.date});

  factory MoodModel.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return MoodModel(
      id: doc.id,
      type: d['type'] ?? 'happy',
      date: d['date'] != null ? (d['date'] as Timestamp).toDate() : DateTime.now(),
    );
  }
}

class MoodService {
  final _col = FirebaseFirestore.instance.collection('moods');

  User get _user {
    final u = FirebaseAuth.instance.currentUser;
    if (u == null) throw Exception('Nenhum usuário logado.');
    return u;
  }

  // CREATE / UPDATE: Agora aceita uma data opcional (se for nula, usa hoje)
  Future<void> registrarHumor(String tipo, {DateTime? dataDesejada}) async {
    final data = dataDesejada ?? DateTime.now();
    
    // O ID do documento será: uid_ano_mes_dia
    final docId = '${_user.uid}_${data.year}_${data.month}_${data.day}';

    // O comando .set() cria o documento se não existir, ou substitui se já existir!
    await _col.doc(docId).set({
      'uid': _user.uid,
      'type': tipo,
      // Se estamos salvando um dia passado, guardamos o dia exato ao meio-dia
      'date': Timestamp.fromDate(DateTime(data.year, data.month, data.day, 12, 0, 0)),
    });
  }

  // READ: Escuta o histórico de humores do usuário
  Stream<List<MoodModel>> ouvirHumores() {
    return _col
        .where('uid', isEqualTo: _user.uid)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => MoodModel.fromDoc(doc)).toList());
  }
}