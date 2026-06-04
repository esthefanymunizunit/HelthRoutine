class AppStrings {
  // Home
  static const String greeting = 'Olá, Mariana !';
  static const String checkInTitle = 'Check-in';
  static const String checkInSubtitle = 'Como você está hoje?';
  static const String activitiesTitle = 'Atividades de Hoje';
  static const String btnLowEnergy = 'Baixa energia';
  static const String btnDisable = 'Desativar';
  static const String suggestionsTitle = 'Sugerido para você';
  static const String btnSeeAll = 'Ver todas';

  // Low Energy Mode
  static const String lowEnergyBannerTitle = 'Modo Baixa Energia Ativado';
  static const String lowEnergyBannerSubtitle =
      'Suas metas complexas foram ocultadas para focar apenas no mínimo viável de saúde';

  // Bottom Nav
  static const String navHome = 'Home';
  static const String navTemplates = 'Templates';
  static const String navReports = 'Relatórios';
  static const String navProfile = 'Perfil';

  // Create Task
  static const String newTaskTitle = 'Nova Tarefa';
  static const String taskNameLabel = 'Nome da tarefa';
  static const String taskNameHint = 'Meditação Guiada';
  static const String essentialLabel = 'Marcar como essencial';
  static const String untilLabel = 'Até';
  static const String addDateBtn = 'Adicionar Data';
  static const String quantityBtn = 'Quantidade';
  static const String repeatLabel = 'Repetir em';
  static const String addTimerLabel = 'Adicionar Temporizador';
  static const String createTaskDurationLabel = 'Duração';
  static const String notificationsLabel = 'Notificações';
  static const String btnAddTask = 'Adicionar Tarefa';

  static String createTaskDurationValue(int minutes) => '$minutes min';

  // Reports
  static const String reportsTitle = 'Sua Jornada';
  static const String reportsSubtitle =
      'Celebrando cada passo em direção ao equilíbrio.';
  static const String weeklySummary = 'Resumo Semanal';
  static const String weeklyComparison = '+10% vs semana passada';
  static const String sundayReset = 'Domingo Reset';
  static const String physicalActivity = 'Atividade Física';
  static const String insightTitle = 'Insight';
  static const String constancyIndex = 'Índice de constância';

  // Templates
  static const String templatesHeader = 'Domingo Reset';
  static const String templatesDesc =
      'Recarregue a mente e organize sua semana com um catálogo de rotinas prontas para você escolher e adaptar à sua semana.';
  static const String templatesSectionTitle = 'Templates';
  static const String tplFocoTitle = 'Foco nos estudos';
  static const String tplFocoDesc =
      'uma sessão de estudos perfeita: mais foco e pausas inteligentes para não esgotar a mente.';
  static const String tplSemanaTitle = 'Semana Sob Controle';
  static const String tplSemanaDesc =
      'Organize seus compromissos e metas para evitar a ansiedade da segunda-feira.';
  static const String tplAmbienteTitle = 'Ambiente Renovado';
  static const String tplAmbienteDesc =
      'Um espaço limpo traz clareza mental. Prepare seu ambiente físico.';
  static const String tplCorpoTitle = 'Corpo Ativo e Nutrido';
  static const String tplCorpoDesc =
      'Acorde o corpo suavemente e prepare sua rotina de saúde física.';

  // --- Tela de Detalhes do Template ---
  static const String templatePersonalizeTitle = 'Personalizar Template';
  static const String templateAddRoutineBtn = '+ Adicionar a minha Rotina';
  static const String templateTimeLabel = 'Horário : ';
  static const String templateNotificationsLabel = 'Notificações';

  // Timer
  static const String timerTitle = 'Timer';
  static const String timerMethodPomodoro = 'Método Pomodoro';
  static const String timerDemoTaskTitle = 'Estudar 2h';
  static const String timerDemoEndTime = 'Término às  10:00h';
  static const String timerPauseActive = 'Pausa Ativa !';
  static const String timerStartSession = 'Começar sessão';
  static const String timerPause = 'Pausar';
  static const String timerResume = 'Retomar';
  static const String timerFinish = 'Finalizar';
  static const String timerSuccessKicker = 'Tarefa';
  static const String timerSuccessTitle = 'Finalizada com Sucesso';

  static String timerBreakLabel(int minutes) => 'Pausa de $minutes min';

  // Mood Calendar
  static const String moodTitleLeading = 'Mood';
  static const String moodTitleHighlighted = 'Calendar';
  static const String moodDateMock = 'Ma 26';
  static const List<String> weekdaysShort = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];
  static const String moodMonthTitle = 'Mood do mês';
  static const String moodMonthStatus = 'Animada';
  static const String moodMonthDescription = 'Você está calma e otimista. Continue\ncom essa energia boa!';
  
  static const String statStepsValueMock = '101,65';
  static const String statStepsSubtitle = 'Passos';
  static const String statMeditationTitle = 'Meditação';
  static const String statMeditationValueMock = '25/30';
  static const String statMeditationSubtitle = 'Sessões';
  static const String statDisciplineTitle = 'Disciplina';
  static const String statDisciplineValueMock = '89%';
  static const String statDisciplineSubtitle = 'Foco';

  // Auth
  static const String authAllowedDomainSuffix = '@souunit.com.br';
  static const String authErrorInvalidDomain =
      'Acesso permitido apenas para contas @souunit.com.br';
  static const String authErrorInvalidCredentials = 'Email ou senha inválidos';
  static const String authErrorUserExists =
      'Já existe uma conta cadastrada com esse email';
  static const String authErrorWeakPassword =
      'Senha muito fraca (mínimo 6 caracteres)';
  static const String authErrorInvalidEmail = 'Email inválido';
  static const String authErrorPasswordMismatch = 'As senhas não conferem';
  static const String authErrorEmptyFields =
      'Preencha email e senha para continuar';
  static const String authErrorGoogleSignInAborted = 'Login com Google cancelado';
  static const String authErrorGeneric = 'Erro inesperado. Tente novamente.';
}
