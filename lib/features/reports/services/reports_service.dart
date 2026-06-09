import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportsService {
  final _db = FirebaseFirestore.instance;

  User get _user {
    final u = FirebaseAuth.instance.currentUser;
    if (u == null) throw Exception('Nenhum usuário logado.');
    return u;
  }

  static const _iniciais = {1: 'S', 2: 'T', 3: 'Q', 4: 'Q', 5: 'S', 6: 'S', 7: 'D'};

  Stream<QuerySnapshot<Map<String, dynamic>>> ouvirTasks() =>
      _db.collection('tasks').where('uid', isEqualTo: _user.uid).snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> ouvirRotinas() =>
      _db.collection('rotinas').where('uid', isEqualTo: _user.uid).snapshots();

  Map<String, dynamic> montarRelatorio(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> tasks,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> rotinas,
  ) {
    final hoje = DateTime.now();
    final meiaNoite = DateTime(hoje.year, hoje.month, hoje.day);
    final inicioSemana = meiaNoite.subtract(const Duration(days: 6));
    final inicioAnterior = inicioSemana.subtract(const Duration(days: 7));

    final porDia = List<int>.filled(7, 0);
    var totalSemana = 0;
    var totalAnterior = 0;

    for (final d in [...tasks, ...rotinas]) {
      final ts = d.data()['concluida_em'] as Timestamp?;
      if (ts == null) continue;
      final dt = ts.toDate();
      final dia = DateTime(dt.year, dt.month, dt.day);
      if (!dia.isBefore(inicioSemana)) {
        totalSemana++;
        final idx = dia.difference(inicioSemana).inDays;
        if (idx >= 0 && idx < 7) porDia[idx]++;
      } else if (!dia.isBefore(inicioAnterior)) {
        totalAnterior++;
      }
    }

    final maxDia = porDia.fold(0, (a, b) => a > b ? a : b);
    final weeklyChart = List.generate(7, (i) {
      final dia = inicioSemana.add(Duration(days: i));
      return {
        'day': _iniciais[dia.weekday] ?? '',
        'value': maxDia == 0 ? 0.0 : porDia[i] / maxDia,
        'highlight': i == 6,
      };
    });

    final fisRatio = _ratioCategoria(tasks, 'Atividade Física');
    final estRatio = _ratioCategoria(tasks, 'Estudos');
    final medRatio = _ratioCategoria(tasks, 'Meditação');
    final fisTotal =
        tasks.where((d) => d.data()['categoria'] == 'Atividade Física').length;

    return {
      'weeklyChart': weeklyChart,
      'stats': {
        'activity': fisTotal == 0 ? '—' : '${(fisRatio * 100).round()}%',
        'activityRatio': fisRatio,
      },
      'rings': {'green': fisRatio, 'blue': estRatio, 'pink': medRatio},
      'insight': _montarInsight(totalSemana, totalAnterior),
      'weeklyChange': totalAnterior == 0
          ? null
          : ((totalSemana - totalAnterior) / totalAnterior * 100).round(),
    };
  }

  double _ratioCategoria(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
    String categoria,
  ) {
    var total = 0;
    var feitas = 0;
    for (final d in docs) {
      if (d.data()['categoria'] == categoria) {
        total++;
        if (d.data()['concluida'] == true) feitas++;
      }
    }
    return total == 0 ? 0.0 : feitas / total;
  }

  String _montarInsight(int semana, int anterior) {
    if (semana == 0 && anterior == 0) {
      return 'Conclua tarefas durante a semana para ver seu progresso aqui.';
    }
    if (anterior == 0) {
      return 'Você concluiu $semana tarefas esta semana. Continue assim!';
    }
    final variacao = ((semana - anterior) / anterior * 100).round();
    if (variacao > 0) {
      return 'Sua constância subiu $variacao% em relação à semana passada.';
    }
    if (variacao < 0) {
      return 'Você concluiu ${variacao.abs()}% menos que na semana passada.';
    }
    return 'Você manteve a mesma constância da semana passada.';
  }
}