import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  const AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  static const delegate = _AppLocalizationsDelegate();

  static const supportedLocales = [
    Locale('pt', 'BR'),
    Locale('en'),
    Locale('es'),
  ];

  // ── Translation tables ──────────────────────────────────────────────────────

  static const _pt = {
    // Home
    'welcomeBack': 'BEM-VINDO DE VOLTA',
    'defineYour': 'Defina Seu',
    'signature': 'Estilo',
    'look': 'Único.',
    // Booking page
    'bookTitle': 'Agendar\nHorário',
    'bookSubtitle': 'Personalize sua experiência em nossa\nObsidian Atelier.',
    'step1Label': 'PASSO 01',
    'step1Title': 'Serviço Premium',
    'step2Label': 'PASSO 02',
    'step2Title': 'O Mestre',
    'step3Label': 'PASSO 03',
    'step3Title': 'Data & Hora',
    'fillAllSteps': 'Por favor, preencha todas as etapas.',
    'invalidTime': 'Horário inválido. Selecione novamente.',
    'bookingConfirmed': 'Agendamento confirmado com sucesso!',
    'bookingError': 'Erro: ',
    // Booking summary card
    'bookingSummary': 'Resumo da Reserva',
    'serviceLabel': 'SERVIÇO',
    'barberLabel': 'BARBEIRO',
    'dateTimeLabel': 'DATA & HORA',
    'subtotal': 'Subtotal',
    'total': 'Total',
    'confirmBooking': 'Confirmar Agendamento',
    // Loyalty page
    'loyaltyTitle1': 'Programa de',
    'loyaltyTitle2': 'Fidelidade',
    'loyaltySubtitle':
        'A excelência merece recompensa. Continue sua jornada de cuidado pessoal e desbloqueie benefícios exclusivos.',
    'currentStatus': 'STATUS ATUAL',
    'almostThere': 'Quase lá,',
    'vipBenefits': 'Vantagens VIP',
    'memberCode': 'Código de Membro',
    'memberCodeSubtitle':
        'Apresente seu QR Code no balcão para validar sua visita atual.',
    'redeem': 'RESGATAR',
    'recentHistory': 'Histórico Recente',
    'viewFullHistory': 'VER HISTÓRICO COMPLETO',
    // Profile
    'memberPremium': 'MEMBRO PREMIUM',
    'memberStandard': 'MEMBRO PADRÃO',
    'stylePreferences': 'Preferências de Estilo',
    'editStylePreferences': 'Editar Preferências de Estilo',
    'haircutLabel': 'CORTE DE CABELO',
    'beardStyleLabel': 'ESTILO DE BARBA',
    'beardContourLabel': 'CONTORNO DE BARBA',
    'favoriteProductsLabel': 'PRODUTOS FAVORITOS',
    'preferredBarberLabel': 'BARBEIRO PREFERIDO',
    'lastService': 'Último serviço',
    'contour': 'Contorno',
    'nextReward': 'Próxima Recompensa',
    'settings': 'Configurações',
    'personalData': 'Dados Pessoais',
    'notifications': 'Notificações',
    'paymentMethods': 'Métodos de Pagamento',
    'privacySecurity': 'Privacidade e Segurança',
    'language': 'Idioma',
    'signOut': 'Sair da Conta',
    'save': 'SALVAR',
    'cancel': 'Cancelar',
    'name': 'Nome',
    'email': 'E-mail',
    'photoPickerTitle': 'Foto de Perfil',
    'takePhoto': 'Tirar foto',
    'chooseFromGallery': 'Escolher da galeria',
    'cameraComingSoon': 'Câmera disponível após configurar autenticação',
    'galleryComingSoon': 'Galeria disponível após configurar autenticação',
    'noPaymentMethod': 'Nenhum método de pagamento cadastrado',
    'addCard': 'Adicionar cartão',
    'comingSoon': 'Disponível em breve',
    'changePassword': 'Alterar senha',
    'downloadMyData': 'Baixar meus dados',
    'deleteAccount': 'Excluir conta',
    'deleteAccountTitle': 'Excluir Conta',
    'deleteAccountMessage':
        'Esta ação é irreversível. Todos os seus dados, histórico e pontos de fidelidade serão perdidos permanentemente.',
    'delete': 'Excluir',
    'signOutTitle': 'Sair da Conta',
    'signOutMessage': 'Tem certeza de que deseja sair?',
    'signOutConfirm': 'Sair',
    'authRequired': 'Disponível após configurar autenticação Firebase',
    'preferencesSaved': 'Preferências salvas!',
    'dataUpdated': 'Dados atualizados!',
    'saveError': 'Erro ao salvar. Tente novamente.',
    'separateByComma': 'Separe por vírgula',
    // Date selector
    'selectDay': 'SELECIONE O DIA',
    'availableSlots': 'HORÁRIOS DISPONÍVEIS',
    'slotsError': 'Erro ao carregar horários.',
    'noSlotsAvailable': 'Nenhum horário disponível neste dia.',
    'selected': 'selecionado',
    // Booking confirmation
    'bookingConfirmedTitle': 'Agendamento\nConfirmado!',
    'dateLabel': 'DATA',
    'timeLabel': 'HORÁRIO',
    'bookingDateFormat': "EEEE, d 'de' MMM",
    'goHome': 'IR PARA O INÍCIO',
    'viewMyAppointments': 'Ver meus agendamentos',
    // Date
    'dateLocale': 'pt_BR',
  };

  static const _en = {
    // Home
    'welcomeBack': 'WELCOME BACK',
    'defineYour': 'Define Your',
    'signature': 'Signature',
    'look': 'Look.',
    // Booking page
    'bookTitle': 'Book\nAppointment',
    'bookSubtitle': 'Customize your experience at our\nObsidian Atelier.',
    'step1Label': 'STEP 01',
    'step1Title': 'Premium Service',
    'step2Label': 'STEP 02',
    'step2Title': 'The Master',
    'step3Label': 'STEP 03',
    'step3Title': 'Date & Time',
    'fillAllSteps': 'Please fill in all steps.',
    'invalidTime': 'Invalid time. Please select again.',
    'bookingConfirmed': 'Appointment confirmed successfully!',
    'bookingError': 'Error: ',
    // Booking summary card
    'bookingSummary': 'Booking Summary',
    'serviceLabel': 'SERVICE',
    'barberLabel': 'BARBER',
    'dateTimeLabel': 'DATE & TIME',
    'subtotal': 'Subtotal',
    'total': 'Total',
    'confirmBooking': 'Confirm Appointment',
    // Loyalty page
    'loyaltyTitle1': 'Loyalty',
    'loyaltyTitle2': 'Program',
    'loyaltySubtitle':
        'Excellence deserves reward. Continue your personal care journey and unlock exclusive benefits.',
    'currentStatus': 'CURRENT STATUS',
    'almostThere': 'Almost there,',
    'vipBenefits': 'VIP Benefits',
    'memberCode': 'Member Code',
    'memberCodeSubtitle':
        'Present your QR Code at the counter to validate your current visit.',
    'redeem': 'REDEEM',
    'recentHistory': 'Recent History',
    'viewFullHistory': 'VIEW FULL HISTORY',
    // Profile
    'memberPremium': 'PREMIUM MEMBER',
    'memberStandard': 'STANDARD MEMBER',
    'stylePreferences': 'Style Preferences',
    'editStylePreferences': 'Edit Style Preferences',
    'haircutLabel': 'HAIRCUT',
    'beardStyleLabel': 'BEARD STYLE',
    'beardContourLabel': 'BEARD CONTOUR',
    'favoriteProductsLabel': 'FAVORITE PRODUCTS',
    'preferredBarberLabel': 'PREFERRED BARBER',
    'lastService': 'Last service',
    'contour': 'Contour',
    'nextReward': 'Next Reward',
    'settings': 'Settings',
    'personalData': 'Personal Data',
    'notifications': 'Notifications',
    'paymentMethods': 'Payment Methods',
    'privacySecurity': 'Privacy & Security',
    'language': 'Language',
    'signOut': 'Sign Out',
    'save': 'SAVE',
    'cancel': 'Cancel',
    'name': 'Name',
    'email': 'E-mail',
    'photoPickerTitle': 'Profile Photo',
    'takePhoto': 'Take a photo',
    'chooseFromGallery': 'Choose from gallery',
    'cameraComingSoon': 'Camera available after setting up authentication',
    'galleryComingSoon': 'Gallery available after setting up authentication',
    'noPaymentMethod': 'No payment method on file',
    'addCard': 'Add card',
    'comingSoon': 'Coming soon',
    'changePassword': 'Change password',
    'downloadMyData': 'Download my data',
    'deleteAccount': 'Delete account',
    'deleteAccountTitle': 'Delete Account',
    'deleteAccountMessage':
        'This action is irreversible. All your data, history and loyalty points will be permanently lost.',
    'delete': 'Delete',
    'signOutTitle': 'Sign Out',
    'signOutMessage': 'Are you sure you want to sign out?',
    'signOutConfirm': 'Sign Out',
    'authRequired': 'Available after setting up Firebase authentication',
    'preferencesSaved': 'Preferences saved!',
    'dataUpdated': 'Data updated!',
    'saveError': 'Error saving. Try again.',
    'separateByComma': 'Separate by comma',
    // Date selector
    'selectDay': 'SELECT A DAY',
    'availableSlots': 'AVAILABLE TIMES',
    'slotsError': 'Failed to load available times.',
    'noSlotsAvailable': 'No times available for this day.',
    'selected': 'selected',
    // Booking confirmation
    'bookingConfirmedTitle': 'Appointment\nConfirmed!',
    'dateLabel': 'DATE',
    'timeLabel': 'TIME',
    'bookingDateFormat': 'EEEE, MMM d',
    'goHome': 'GO TO HOME',
    'viewMyAppointments': 'View my appointments',
    // Date
    'dateLocale': 'en',
  };

  static const _es = {
    // Home
    'welcomeBack': 'BIENVENIDO DE VUELTA',
    'defineYour': 'Define Tu',
    'signature': 'Estilo',
    'look': 'Único.',
    // Booking page
    'bookTitle': 'Reservar\nCita',
    'bookSubtitle':
        'Personaliza tu experiencia en nuestro\nObsidian Atelier.',
    'step1Label': 'PASO 01',
    'step1Title': 'Servicio Premium',
    'step2Label': 'PASO 02',
    'step2Title': 'El Maestro',
    'step3Label': 'PASO 03',
    'step3Title': 'Fecha y Hora',
    'fillAllSteps': 'Por favor, completa todos los pasos.',
    'invalidTime': 'Hora no válida. Selecciona de nuevo.',
    'bookingConfirmed': '¡Cita confirmada con éxito!',
    'bookingError': 'Error: ',
    // Booking summary card
    'bookingSummary': 'Resumen de Reserva',
    'serviceLabel': 'SERVICIO',
    'barberLabel': 'BARBERO',
    'dateTimeLabel': 'FECHA Y HORA',
    'subtotal': 'Subtotal',
    'total': 'Total',
    'confirmBooking': 'Confirmar Cita',
    // Loyalty page
    'loyaltyTitle1': 'Programa de',
    'loyaltyTitle2': 'Fidelidad',
    'loyaltySubtitle':
        'La excelencia merece recompensa. Continúa tu viaje de cuidado personal y desbloquea beneficios exclusivos.',
    'currentStatus': 'ESTADO ACTUAL',
    'almostThere': 'Casi ahí,',
    'vipBenefits': 'Ventajas VIP',
    'memberCode': 'Código de Miembro',
    'memberCodeSubtitle':
        'Presenta tu código QR en el mostrador para validar tu visita actual.',
    'redeem': 'CANJEAR',
    'recentHistory': 'Historial Reciente',
    'viewFullHistory': 'VER HISTORIAL COMPLETO',
    // Profile
    'memberPremium': 'MIEMBRO PREMIUM',
    'memberStandard': 'MIEMBRO ESTÁNDAR',
    'stylePreferences': 'Preferencias de Estilo',
    'editStylePreferences': 'Editar Preferencias de Estilo',
    'haircutLabel': 'CORTE DE PELO',
    'beardStyleLabel': 'ESTILO DE BARBA',
    'beardContourLabel': 'CONTORNO DE BARBA',
    'favoriteProductsLabel': 'PRODUCTOS FAVORITOS',
    'preferredBarberLabel': 'BARBERO PREFERIDO',
    'lastService': 'Último servicio',
    'contour': 'Contorno',
    'nextReward': 'Próxima Recompensa',
    'settings': 'Configuración',
    'personalData': 'Datos Personales',
    'notifications': 'Notificaciones',
    'paymentMethods': 'Métodos de Pago',
    'privacySecurity': 'Privacidad y Seguridad',
    'language': 'Idioma',
    'signOut': 'Cerrar Sesión',
    'save': 'GUARDAR',
    'cancel': 'Cancelar',
    'name': 'Nombre',
    'email': 'E-mail',
    'photoPickerTitle': 'Foto de Perfil',
    'takePhoto': 'Tomar foto',
    'chooseFromGallery': 'Elegir desde la galería',
    'cameraComingSoon':
        'Cámara disponible después de configurar autenticación',
    'galleryComingSoon':
        'Galería disponible después de configurar autenticación',
    'noPaymentMethod': 'Ningún método de pago registrado',
    'addCard': 'Agregar tarjeta',
    'comingSoon': 'Próximamente',
    'changePassword': 'Cambiar contraseña',
    'downloadMyData': 'Descargar mis datos',
    'deleteAccount': 'Eliminar cuenta',
    'deleteAccountTitle': 'Eliminar Cuenta',
    'deleteAccountMessage':
        'Esta acción es irreversible. Todos tus datos, historial y puntos de fidelidad se perderán permanentemente.',
    'delete': 'Eliminar',
    'signOutTitle': 'Cerrar Sesión',
    'signOutMessage': '¿Estás seguro de que deseas cerrar sesión?',
    'signOutConfirm': 'Salir',
    'authRequired':
        'Disponible después de configurar la autenticación de Firebase',
    'preferencesSaved': '¡Preferencias guardadas!',
    'dataUpdated': '¡Datos actualizados!',
    'saveError': 'Error al guardar. Inténtalo de nuevo.',
    'separateByComma': 'Separar por coma',
    // Date selector
    'selectDay': 'SELECCIONA EL DÍA',
    'availableSlots': 'HORARIOS DISPONIBLES',
    'slotsError': 'Error al cargar los horarios.',
    'noSlotsAvailable': 'No hay horarios disponibles para este día.',
    'selected': 'seleccionado',
    // Booking confirmation
    'bookingConfirmedTitle': '¡Cita\nConfirmada!',
    'dateLabel': 'FECHA',
    'timeLabel': 'HORA',
    'bookingDateFormat': "EEEE, d 'de' MMM",
    'goHome': 'IR AL INICIO',
    'viewMyAppointments': 'Ver mis citas',
    // Date
    'dateLocale': 'es',
  };

  // ── Lookup ──────────────────────────────────────────────────────────────────

  Map<String, String> get _strings {
    switch (locale.languageCode) {
      case 'en':
        return _en;
      case 'es':
        return _es;
      default:
        return _pt;
    }
  }

  String _t(String key) => _strings[key] ?? _pt[key] ?? key;

  // ── Simple getters ──────────────────────────────────────────────────────────

  // Home
  String get welcomeBack => _t('welcomeBack');
  String get defineYour => _t('defineYour');
  String get signature => _t('signature');
  String get look => _t('look');
  // Booking
  String get bookTitle => _t('bookTitle');
  String get bookSubtitle => _t('bookSubtitle');
  String get step1Label => _t('step1Label');
  String get step1Title => _t('step1Title');
  String get step2Label => _t('step2Label');
  String get step2Title => _t('step2Title');
  String get step3Label => _t('step3Label');
  String get step3Title => _t('step3Title');
  String get fillAllSteps => _t('fillAllSteps');
  String get invalidTime => _t('invalidTime');
  String get bookingConfirmed => _t('bookingConfirmed');
  String get bookingError => _t('bookingError');
  String get bookingSummary => _t('bookingSummary');
  String get serviceLabel => _t('serviceLabel');
  String get barberLabel => _t('barberLabel');
  String get dateTimeLabel => _t('dateTimeLabel');
  String get subtotal => _t('subtotal');
  String get total => _t('total');
  String get confirmBooking => _t('confirmBooking');
  // Loyalty
  String get loyaltyTitle1 => _t('loyaltyTitle1');
  String get loyaltyTitle2 => _t('loyaltyTitle2');
  String get loyaltySubtitle => _t('loyaltySubtitle');
  String get currentStatus => _t('currentStatus');
  String get almostThere => _t('almostThere');
  String get vipBenefits => _t('vipBenefits');
  String get memberCode => _t('memberCode');
  String get memberCodeSubtitle => _t('memberCodeSubtitle');
  String get redeem => _t('redeem');
  String get recentHistory => _t('recentHistory');
  String get viewFullHistory => _t('viewFullHistory');
  // Profile
  String get memberPremium => _t('memberPremium');
  String get memberStandard => _t('memberStandard');
  String get stylePreferences => _t('stylePreferences');
  String get editStylePreferences => _t('editStylePreferences');
  String get haircutLabel => _t('haircutLabel');
  String get beardStyleLabel => _t('beardStyleLabel');
  String get beardContourLabel => _t('beardContourLabel');
  String get favoriteProductsLabel => _t('favoriteProductsLabel');
  String get preferredBarberLabel => _t('preferredBarberLabel');
  String get lastService => _t('lastService');
  String get contour => _t('contour');
  String get nextReward => _t('nextReward');
  String get settings => _t('settings');
  String get personalData => _t('personalData');
  String get notifications => _t('notifications');
  String get paymentMethods => _t('paymentMethods');
  String get privacySecurity => _t('privacySecurity');
  String get language => _t('language');
  String get signOut => _t('signOut');
  String get save => _t('save');
  String get cancel => _t('cancel');
  String get name => _t('name');
  String get email => _t('email');
  String get photoPickerTitle => _t('photoPickerTitle');
  String get takePhoto => _t('takePhoto');
  String get chooseFromGallery => _t('chooseFromGallery');
  String get cameraComingSoon => _t('cameraComingSoon');
  String get galleryComingSoon => _t('galleryComingSoon');
  String get noPaymentMethod => _t('noPaymentMethod');
  String get addCard => _t('addCard');
  String get comingSoon => _t('comingSoon');
  String get changePassword => _t('changePassword');
  String get downloadMyData => _t('downloadMyData');
  String get deleteAccount => _t('deleteAccount');
  String get deleteAccountTitle => _t('deleteAccountTitle');
  String get deleteAccountMessage => _t('deleteAccountMessage');
  String get delete => _t('delete');
  String get signOutTitle => _t('signOutTitle');
  String get signOutMessage => _t('signOutMessage');
  String get signOutConfirm => _t('signOutConfirm');
  String get authRequired => _t('authRequired');
  String get preferencesSaved => _t('preferencesSaved');
  String get dataUpdated => _t('dataUpdated');
  String get saveError => _t('saveError');
  String get separateByComma => _t('separateByComma');
  String get selectDay => _t('selectDay');
  String get availableSlots => _t('availableSlots');
  String get slotsError => _t('slotsError');
  String get noSlotsAvailable => _t('noSlotsAvailable');
  String get selected => _t('selected');
  String get bookingConfirmedTitle => _t('bookingConfirmedTitle');
  String get dateLabel => _t('dateLabel');
  String get timeLabel => _t('timeLabel');
  String get bookingDateFormat => _t('bookingDateFormat');
  String get goHome => _t('goHome');
  String get viewMyAppointments => _t('viewMyAppointments');
  String get dateLocale => _t('dateLocale');

  // ── Parameterized methods ───────────────────────────────────────────────────

  String cutsRemainingAlert(int remaining) {
    if (remaining == 1) {
      switch (locale.languageCode) {
        case 'en':
          return 'Next cut is on us!';
        case 'es':
          return '¡El próximo corte corre por nuestra cuenta!';
        default:
          return 'Próximo corte é por nossa conta!';
      }
    }
    switch (locale.languageCode) {
      case 'en':
        return 'Only $remaining cuts left for your reward!';
      case 'es':
        return '¡Solo faltan $remaining cortes para tu recompensa!';
      default:
        return 'Faltam $remaining cortes para sua recompensa!';
    }
  }

  String completeVisitMessage(int visitNumber, String reward) {
    switch (locale.languageCode) {
      case 'en':
        return 'Complete visit #$visitNumber and receive a free $reward.';
      case 'es':
        return 'Completa la visita #$visitNumber y recibe un $reward gratis.';
      default:
        return 'Complete seu $visitNumberº atendimento e receba um $reward gratuito.';
    }
  }

  String rewardAvailableMessage(String reward) {
    switch (locale.languageCode) {
      case 'en':
        return 'Your reward "$reward" is available!';
      case 'es':
        return '¡Tu recompensa "$reward" está disponible!';
      default:
        return 'Sua recompensa "$reward" está disponível!';
    }
  }

  String loyaltyProgressLabel(int percent) {
    switch (locale.languageCode) {
      case 'en':
        return '$percent% of the loyalty program completed';
      case 'es':
        return '$percent% del programa de fidelidad completado';
      default:
        return '$percent% do programa de fidelidade concluído';
    }
  }

  String memberSinceLabel(DateTime date) {
    switch (locale.languageCode) {
      case 'en':
        const months = [
          'January', 'February', 'March', 'April', 'May', 'June',
          'July', 'August', 'September', 'October', 'November', 'December',
        ];
        return 'Member since ${months[date.month - 1]} ${date.year}';
      case 'es':
        const months = [
          'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
          'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
        ];
        return 'Cliente desde ${months[date.month - 1]} de ${date.year}';
      default:
        const months = [
          'janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho',
          'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro',
        ];
        return 'Cliente desde ${months[date.month - 1]} de ${date.year}';
    }
  }

  String lastServiceLabel(DateTime? date) {
    if (date == null) {
      switch (locale.languageCode) {
        case 'en': return 'No service yet';
        case 'es': return 'Ningún servicio aún';
        default:   return 'Nenhum serviço ainda';
      }
    }
    final diff = DateTime.now().difference(date).inDays;
    if (diff == 0) {
      switch (locale.languageCode) {
        case 'en': return 'Today';
        case 'es': return 'Hoy';
        default:   return 'Hoje';
      }
    }
    if (diff == 1) {
      switch (locale.languageCode) {
        case 'en': return 'Yesterday';
        case 'es': return 'Ayer';
        default:   return 'Ontem';
      }
    }
    switch (locale.languageCode) {
      case 'en': return '$diff days ago';
      case 'es': return 'Hace $diff días';
      default:   return 'Há $diff dias';
    }
  }
}

// ── Delegate ─────────────────────────────────────────────────────────────────

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['pt', 'en', 'es'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_) => false;
}
