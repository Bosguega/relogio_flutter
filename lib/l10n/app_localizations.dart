import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// No description provided for @relMundial.
  ///
  /// In en, this message translates to:
  /// **'World Clock'**
  String get relMundial;

  /// No description provided for @alarmes.
  ///
  /// In en, this message translates to:
  /// **'Alarms'**
  String get alarmes;

  /// No description provided for @timer.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get timer;

  /// No description provided for @cronometro.
  ///
  /// In en, this message translates to:
  /// **'Stopwatch'**
  String get cronometro;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @relogio.
  ///
  /// In en, this message translates to:
  /// **'Clock'**
  String get relogio;

  /// No description provided for @appTitulo.
  ///
  /// In en, this message translates to:
  /// **'Flutter Clock'**
  String get appTitulo;

  /// No description provided for @tempoEscolhido.
  ///
  /// In en, this message translates to:
  /// **'Selected time'**
  String get tempoEscolhido;

  /// No description provided for @horaProvavelTermino.
  ///
  /// In en, this message translates to:
  /// **'Estimated end time'**
  String get horaProvavelTermino;

  /// No description provided for @pausar.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pausar;

  /// No description provided for @continuar.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continuar;

  /// No description provided for @cancelar.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelar;

  /// No description provided for @timerFinalizado.
  ///
  /// In en, this message translates to:
  /// **'Timer finished!'**
  String get timerFinalizado;

  /// No description provided for @tempoTerminado.
  ///
  /// In en, this message translates to:
  /// **'Time is up.'**
  String get tempoTerminado;

  /// No description provided for @desligar.
  ///
  /// In en, this message translates to:
  /// **'Turn off'**
  String get desligar;

  /// No description provided for @reiniciar.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get reiniciar;

  /// No description provided for @horas.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get horas;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get min;

  /// No description provided for @seg.
  ///
  /// In en, this message translates to:
  /// **'Sec'**
  String get seg;

  /// No description provided for @iniciar.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get iniciar;

  /// No description provided for @tempoMaiorZero.
  ///
  /// In en, this message translates to:
  /// **'Choose a time greater than zero'**
  String get tempoMaiorZero;

  /// No description provided for @editarAlarme.
  ///
  /// In en, this message translates to:
  /// **'Edit Alarm'**
  String get editarAlarme;

  /// No description provided for @horario.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get horario;

  /// No description provided for @portuguese.
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get portuguese;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @temaClassicoDark.
  ///
  /// In en, this message translates to:
  /// **'Classic Dark'**
  String get temaClassicoDark;

  /// No description provided for @temaClaro.
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get temaClaro;

  /// No description provided for @adicionar.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get adicionar;

  /// No description provided for @editar.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editar;

  /// No description provided for @excluir.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get excluir;

  /// No description provided for @selecioneHora.
  ///
  /// In en, this message translates to:
  /// **'Select alarm time'**
  String get selecioneHora;

  /// No description provided for @nenhumAlarme.
  ///
  /// In en, this message translates to:
  /// **'No alarms set.\nTap the + button to add one.'**
  String get nenhumAlarme;

  /// No description provided for @alarmExcluido.
  ///
  /// In en, this message translates to:
  /// **'Alarm deleted'**
  String get alarmExcluido;

  /// No description provided for @desfazer.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get desfazer;

  /// No description provided for @repeticaoVaziaUmaVez.
  ///
  /// In en, this message translates to:
  /// **'Once'**
  String get repeticaoVaziaUmaVez;

  /// No description provided for @repetir.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get repetir;

  /// No description provided for @salvar.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get salvar;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
