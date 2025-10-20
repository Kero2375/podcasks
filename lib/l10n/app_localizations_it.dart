// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Podcasks';

  @override
  String get podcast => 'podcast';

  @override
  String get play => 'Play';

  @override
  String get pause => 'Pausa';

  @override
  String get skip => 'Salta';

  @override
  String get markAsFinished => 'Segna come ascoltato';

  @override
  String get cancelProgress => 'Cancella progressi';

  @override
  String get follow => 'Segui';

  @override
  String following(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Seguiti',
      one: 'Seguito',
    );
    return '$_temp0';
  }

  @override
  String get finished => 'Ascoltato';

  @override
  String get listening => 'In ascolto';

  @override
  String get started => 'Iniziato';

  @override
  String get welcome => 'ciao!';

  @override
  String get notListeningMessage => 'non stai ancora ascoltando nulla';

  @override
  String get notFavouritesMessage => 'non hai ancora preferiti';

  @override
  String get favourites => 'Preferiti';

  @override
  String get bohEmoji => '¯\\_(ツ)_/¯';

  @override
  String get explorePodcasts => 'esplora podcast';

  @override
  String get markAllFinished => 'Segna tutti come ascoltati';

  @override
  String markAllFinishedMessage(Object title) {
    return 'Segnare tutti gli episodi di $title come ascoltati?';
  }

  @override
  String get confirm => 'Conferma';

  @override
  String get deleteProgress => 'Elimina progressi';

  @override
  String deleteProgressMessage(Object title) {
    return 'Sei sicur* di voler eliminare tutti i progressi di $title?';
  }

  @override
  String get delete => 'Elimina';

  @override
  String get deleteAllEmoji => '\"ಠ_ಠ';

  @override
  String searchIn(Object podcast) {
    return 'Cerca in $podcast';
  }

  @override
  String get error => 'Errore';

  @override
  String get olderFirst => 'Meno recenti';

  @override
  String get newerFirst => 'Più recenti';

  @override
  String get cancel => 'Annulla';

  @override
  String get searchFilters => 'Filtri di ricerca';

  @override
  String get region => 'regione:';

  @override
  String get genre => 'genere:';

  @override
  String get ok => 'Ok';

  @override
  String get searchOrRssHint => 'Cerca o aggiungi feed RSS...';

  @override
  String get noResults => 'ops, non ho trovato niente';

  @override
  String get noResultsEmoji => '(◡︵◡)';

  @override
  String get share => 'Condividi';

  @override
  String get download => 'Download';

  @override
  String get all => 'Tutti';

  @override
  String get arts => 'Arte';

  @override
  String get business => 'Business';

  @override
  String get comedy => 'Commedia';

  @override
  String get education => 'Educazione';

  @override
  String get fiction => 'Narrativa';

  @override
  String get government => 'Governo';

  @override
  String get healthFitness => 'Salute & Fitness';

  @override
  String get history => 'Storia';

  @override
  String get kidsFamily => 'Bambini & Famiglia';

  @override
  String get leisure => 'Intrattenimento';

  @override
  String get music => 'Musica';

  @override
  String get news => 'News';

  @override
  String get religionSpirituality => 'Religione & Spiritualità';

  @override
  String get science => 'Scienze';

  @override
  String get societyCulture => 'Società & Cultura';

  @override
  String get sports => 'Sport';

  @override
  String get tvFilm => 'TV & Film';

  @override
  String get technology => 'Tecnologia';

  @override
  String get trueCrime => 'True Crime';

  @override
  String get addToQueue => 'Aggiungi alla coda';

  @override
  String get removeFromQueue => 'Rimuovi dalla coda';

  @override
  String get addedToQueue => 'aggiunto alla coda';

  @override
  String get alreadyInQueue => 'già presente nella coda';

  @override
  String get clearAll => 'cancella';

  @override
  String get nextInQueue => 'Prossimi in coda:';

  @override
  String get emptyQueue => 'coda vuota';

  @override
  String get searchHint => 'Cerca o inserisci Feed RSS';

  @override
  String get importOpml => 'Importa OPML';

  @override
  String get importTitle => 'Conferma importazione OMPL';

  @override
  String get import => 'Importa';

  @override
  String importMessage(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementi',
      one: '$count elementi',
    );
    return 'Vuoi veramente aggiungere $_temp0 ai preferiti?';
  }

  @override
  String get settings => 'Impostazioni';

  @override
  String get downloadAll => 'Scarica tutti';

  @override
  String get stopDownloads => 'Interrompi download';

  @override
  String get stop => 'Interrompi';

  @override
  String downloadMessage(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count episodi',
      one: '$count episoio',
    );
    return 'Vuoi veramente scaricare $_temp0?';
  }

  @override
  String get stopMessage =>
      'Vuoi veramente interrompere tutti i download in corso?';

  @override
  String get hide => 'nascondi';

  @override
  String get readMore => 'leggi di più';

  @override
  String get added => 'Aggiunti';

  @override
  String get nothingToImport => 'Niente di nuovo da importare';

  @override
  String get sync => 'Aggiorna';

  @override
  String get home => 'Home';

  @override
  String get explore => 'Esplora';
}
