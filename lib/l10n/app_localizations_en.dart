// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Podcasks';

  @override
  String get podcast => 'podcast';

  @override
  String get play => 'Play';

  @override
  String get pause => 'Pause';

  @override
  String get skip => 'Skip';

  @override
  String get markAsFinished => 'Mark as finished';

  @override
  String get cancelProgress => 'Cancel progress';

  @override
  String get follow => 'Follow';

  @override
  String following(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Following',
      one: 'Following',
    );
    return '$_temp0';
  }

  @override
  String get finished => 'Finished';

  @override
  String get listening => 'Listening';

  @override
  String get started => 'Started';

  @override
  String get welcome => 'welcome!';

  @override
  String get notListeningMessage => 'you\'re not listening to anything yet';

  @override
  String get notFavouritesMessage => 'you don\'t have favourites yet';

  @override
  String get favourites => 'Favourites';

  @override
  String get bohEmoji => '¯\\_(ツ)_/¯';

  @override
  String get explorePodcasts => 'explore podcasts';

  @override
  String get markAllFinished => 'Mark all as finished';

  @override
  String markAllFinishedMessage(Object title) {
    return 'Mark all episodes of $title as finished?';
  }

  @override
  String get confirm => 'Confirm';

  @override
  String get deleteProgress => 'Delete progress';

  @override
  String deleteProgressMessage(Object title) {
    return 'Are you sure you want to delete all progress for $title?';
  }

  @override
  String get delete => 'Delete';

  @override
  String get deleteAllEmoji => '\"ಠ_ಠ';

  @override
  String searchIn(Object podcast) {
    return 'Search in $podcast';
  }

  @override
  String get error => 'Error';

  @override
  String get olderFirst => 'Older first';

  @override
  String get newerFirst => 'Newer first';

  @override
  String get cancel => 'Cancel';

  @override
  String get searchFilters => 'Search Filters';

  @override
  String get region => 'region:';

  @override
  String get genre => 'genre:';

  @override
  String get ok => 'Ok';

  @override
  String get searchOrRssHint => 'Search or add RSS feed...';

  @override
  String get noResults => 'sorry, I didn\'t find anything';

  @override
  String get noResultsEmoji => '(◡︵◡)';

  @override
  String get share => 'Share';

  @override
  String get download => 'Download';

  @override
  String get all => 'All';

  @override
  String get arts => 'Arts';

  @override
  String get business => 'Business';

  @override
  String get comedy => 'Comedy';

  @override
  String get education => 'Education';

  @override
  String get fiction => 'Fiction';

  @override
  String get government => 'Government';

  @override
  String get healthFitness => 'Health & Fitness';

  @override
  String get history => 'History';

  @override
  String get kidsFamily => 'Kids & Family';

  @override
  String get leisure => 'Leisure';

  @override
  String get music => 'Music';

  @override
  String get news => 'News';

  @override
  String get religionSpirituality => 'Religion & Spirituality';

  @override
  String get science => 'Science';

  @override
  String get societyCulture => 'Society & Culture';

  @override
  String get sports => 'Sports';

  @override
  String get tvFilm => 'TV & Film';

  @override
  String get technology => 'Technology';

  @override
  String get trueCrime => 'True Crime';

  @override
  String get addToQueue => 'Add to queue';

  @override
  String get removeFromQueue => 'Remove from queue';

  @override
  String get addedToQueue => 'added to queue';

  @override
  String get alreadyInQueue => 'already in queue';

  @override
  String get clearAll => 'clear all';

  @override
  String get nextInQueue => 'Next in queue:';

  @override
  String get emptyQueue => 'empty queue';

  @override
  String get searchHint => 'Search or insert RSS feed';

  @override
  String get importOpml => 'Import OPML';

  @override
  String get importTitle => 'Confirm import OMPL';

  @override
  String get import => 'Import';

  @override
  String importMessage(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '$count item',
    );
    return 'Do you really want to add $_temp0 to you favorites?';
  }

  @override
  String get settings => 'Settings';

  @override
  String get downloadAll => 'Download all';

  @override
  String get stopDownloads => 'Stop downloads';

  @override
  String get stop => 'Stop';

  @override
  String downloadMessage(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count episodes',
      one: '$count episode',
    );
    return 'Are you sure you want to download $_temp0?';
  }

  @override
  String get stopMessage =>
      'Are you sure you want to stop all the current downloads?';

  @override
  String get hide => 'hide';

  @override
  String get readMore => 'read more';

  @override
  String get added => 'Added';

  @override
  String get nothingToImport => 'Nothing new to import';

  @override
  String get sync => 'Sync';

  @override
  String get home => 'Home';

  @override
  String get explore => 'Explore';
}
