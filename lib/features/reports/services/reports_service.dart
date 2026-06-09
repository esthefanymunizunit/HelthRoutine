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

  Future<Map<String, dynamic>> gerarRelatorioSemanal() async {
    final hoje = DateTime.now();
    final meiaNoite = DateTime(hoje.year, hoje.month, hoje.day);
    final inicioSemana = meiaNoite.subtract(const Duration(days: 6));     
    final inicioAnterior = inicioSemana.subtract(const Duration(days: 7)); 
    
    final datas = await _conclusoesDesde(inicioAnterior);

    final porDia = List<int>.filled(7, 0);
    var totalSemana = 0;
    var totalAnterior = 0;

    for (final ts in datas) {
      final dia = DateTime(ts.year, ts.month, ts.day);
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
        'highlight': i == 6, // destaca hoje
      };
    });

    final tasksSnap = await _db
        .collection('tasks')
        .where('uid', isEqualTo: _user.uid)
        .get();

    var fisTotal = 0;
    var fisFeitas = 0;
    for (final d in tasksSnap.docs) {
      if (d.data()['categoria'] == 'Atividade Física') {
        fisTotal++;
        if (d.data()['concluida'] == true) fisFeitas++;
      }
    }
    final fisRatio = fisTotal == 0 ? 0.0 : fisFeitas / fisTotal;

    return {
      'weeklyChart': weeklyChart,
      'stats': {
        'activity': fisTotal == 0 ? '—' : '${(fisRatio * 100).round()}%',
        'activityRatio': fisRatio,
      },
      'insight': _montarInsight(totalSemana, totalAnterior),
      'weeklyChange': totalAnterior == 0
          ? null
          : ((totalSemana - totalAnterior) / totalAnterior * 100).round(),
    };
  }

  Future<List<DateTime>> _conclusoesDesde(DateTime inicio) async {
    final ini = Timestamp.fromDate(inicio);
    final results = await Future.wait([
      _db.collection('tasks')
          .where('uid', isEqualTo: _user.uid)
          .where('concluida_em', isGreaterThanOrEqualTo: ini)
          .get(),
      _db.collection('rotinas')
          .where('uid', isEqualTo: _user.uid)
          .where('concluida_em', isGreaterThanOrEqualTo: ini)
          .get(),
    ]);
    final datas = <DateTime>[];
    for (final snap in results) {
      for (final d in snap.docs) {
        final ts = d.data()['concluida_em'] as Timestamp?;
        if (ts != null) datas.add(ts.toDate());
      }
    }
    return datas;
  }

  String _montarInsight(int semana, int anterior) {
    if (semana == 0 && anterior == 0) {
      return 'Conclua tarefas durante a semana para ver seu progresso aqui.';
    }
    if (anterior == 0) {
      return 'Você concluiu $semana tarefas esta semana. Continue assim!';
    }
    final variacao = ((semana - anterior) / anterior * 100).round();
    if (variacao > 0) return 'Sua constância subiu $variacao% em relação à semana passada.';
    if (variacao < 0) return 'Você concluiu ${variacao.abs()}% menos que na semana passada.';
    return 'Você manteve a mesma constância da semana passada.';
  }
}