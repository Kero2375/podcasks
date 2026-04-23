import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_it.dart';

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
    Locale('es'),
    Locale('it')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Podcasks'**
  String get appTitle;

  /// No description provided for @podcast.
  ///
  /// In en, this message translates to:
  /// **'podcast'**
  String get podcast;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @markAsFinished.
  ///
  /// In en, this message translates to:
  /// **'Mark as finished'**
  String get markAsFinished;

  /// No description provided for @cancelProgress.
  ///
  /// In en, this message translates to:
  /// **'Cancel progress'**
  String get cancelProgress;

  /// No description provided for @follow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get follow;

  /// No description provided for @following.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Following} other{Following}}'**
  String following(num count);

  /// No description provided for @finished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get finished;

  /// No description provided for @listening.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get listening;

  /// No description provided for @started.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get started;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'welcome!'**
  String get welcome;

  /// No description provided for @notListeningMessage.
  ///
  /// In en, this message translates to:
  /// **'you\'re not listening to anything yet'**
  String get notListeningMessage;

  /// No description provided for @notFavouritesMessage.
  ///
  /// In en, this message translates to:
  /// **'you don\'t have favourites yet'**
  String get notFavouritesMessage;

  /// No description provided for @favourites.
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get favourites;

  /// No description provided for @bohEmoji.
  ///
  /// In en, this message translates to:
  /// **'¯\\_(ツ)_/¯'**
  String get bohEmoji;

  /// No description provided for @explorePodcasts.
  ///
  /// In en, this message translates to:
  /// **'Explore podcasts'**
  String get explorePodcasts;

  /// No description provided for @markAllFinished.
  ///
  /// In en, this message translates to:
  /// **'Mark all as finished'**
  String get markAllFinished;

  /// No description provided for @markAllFinishedMessage.
  ///
  /// In en, this message translates to:
  /// **'Mark all episodes of {title} as finished?'**
  String markAllFinishedMessage(Object title);

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @deleteProgress.
  ///
  /// In en, this message translates to:
  /// **'Delete progress'**
  String get deleteProgress;

  /// No description provided for @deleteProgressMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all progress for {title}?'**
  String deleteProgressMessage(Object title);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteEpisodeMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {title}?'**
  String deleteEpisodeMessage(Object title);

  /// No description provided for @deleteAllEmoji.
  ///
  /// In en, this message translates to:
  /// **'\"ಠ_ಠ'**
  String get deleteAllEmoji;

  /// No description provided for @searchIn.
  ///
  /// In en, this message translates to:
  /// **'Search in {podcast}'**
  String searchIn(Object podcast);

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @olderFirst.
  ///
  /// In en, this message translates to:
  /// **'Older first'**
  String get olderFirst;

  /// No description provided for @newerFirst.
  ///
  /// In en, this message translates to:
  /// **'Newer first'**
  String get newerFirst;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @searchFilters.
  ///
  /// In en, this message translates to:
  /// **'Search Filters'**
  String get searchFilters;

  /// No description provided for @region.
  ///
  /// In en, this message translates to:
  /// **'region:'**
  String get region;

  /// No description provided for @genre.
  ///
  /// In en, this message translates to:
  /// **'genre:'**
  String get genre;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @searchOrRssHint.
  ///
  /// In en, this message translates to:
  /// **'Search / RSS'**
  String get searchOrRssHint;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'sorry, I didn\'t find anything'**
  String get noResults;

  /// No description provided for @noResultsEmoji.
  ///
  /// In en, this message translates to:
  /// **'(◡︵◡)'**
  String get noResultsEmoji;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @arts.
  ///
  /// In en, this message translates to:
  /// **'Arts'**
  String get arts;

  /// No description provided for @business.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get business;

  /// No description provided for @comedy.
  ///
  /// In en, this message translates to:
  /// **'Comedy'**
  String get comedy;

  /// No description provided for @education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

  /// No description provided for @fiction.
  ///
  /// In en, this message translates to:
  /// **'Fiction'**
  String get fiction;

  /// No description provided for @government.
  ///
  /// In en, this message translates to:
  /// **'Government'**
  String get government;

  /// No description provided for @healthFitness.
  ///
  /// In en, this message translates to:
  /// **'Health & Fitness'**
  String get healthFitness;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @kidsFamily.
  ///
  /// In en, this message translates to:
  /// **'Kids & Family'**
  String get kidsFamily;

  /// No description provided for @leisure.
  ///
  /// In en, this message translates to:
  /// **'Leisure'**
  String get leisure;

  /// No description provided for @music.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get music;

  /// No description provided for @news.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get news;

  /// No description provided for @religionSpirituality.
  ///
  /// In en, this message translates to:
  /// **'Religion & Spirituality'**
  String get religionSpirituality;

  /// No description provided for @science.
  ///
  /// In en, this message translates to:
  /// **'Science'**
  String get science;

  /// No description provided for @societyCulture.
  ///
  /// In en, this message translates to:
  /// **'Society & Culture'**
  String get societyCulture;

  /// No description provided for @sports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get sports;

  /// No description provided for @tvFilm.
  ///
  /// In en, this message translates to:
  /// **'TV & Film'**
  String get tvFilm;

  /// No description provided for @technology.
  ///
  /// In en, this message translates to:
  /// **'Technology'**
  String get technology;

  /// No description provided for @trueCrime.
  ///
  /// In en, this message translates to:
  /// **'True Crime'**
  String get trueCrime;

  /// No description provided for @addToQueue.
  ///
  /// In en, this message translates to:
  /// **'Add to queue'**
  String get addToQueue;

  /// No description provided for @removeFromQueue.
  ///
  /// In en, this message translates to:
  /// **'Remove from queue'**
  String get removeFromQueue;

  /// No description provided for @addedToQueue.
  ///
  /// In en, this message translates to:
  /// **'added to queue'**
  String get addedToQueue;

  /// No description provided for @alreadyInQueue.
  ///
  /// In en, this message translates to:
  /// **'already in queue'**
  String get alreadyInQueue;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'clear all'**
  String get clearAll;

  /// No description provided for @nextInQueue.
  ///
  /// In en, this message translates to:
  /// **'Next in queue:'**
  String get nextInQueue;

  /// No description provided for @emptyQueue.
  ///
  /// In en, this message translates to:
  /// **'empty queue'**
  String get emptyQueue;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search / RSS'**
  String get searchHint;

  /// No description provided for @importOpml.
  ///
  /// In en, this message translates to:
  /// **'Import Backup'**
  String get importOpml;

  /// No description provided for @exportOpml.
  ///
  /// In en, this message translates to:
  /// **'Export Backup'**
  String get exportOpml;

  /// No description provided for @importTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Import'**
  String get importTitle;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @importMessage.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to add {count, plural, =1{{count} item} other{{count} items}} to your favorites?'**
  String importMessage(num count);

  /// No description provided for @selectBackupLocation.
  ///
  /// In en, this message translates to:
  /// **'Please select where to save your backup:'**
  String get selectBackupLocation;

  /// No description provided for @backupSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Backup saved successfully'**
  String get backupSavedSuccessfully;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get pleaseWait;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @downloadAll.
  ///
  /// In en, this message translates to:
  /// **'Download all'**
  String get downloadAll;

  /// No description provided for @stopDownloads.
  ///
  /// In en, this message translates to:
  /// **'Stop downloads'**
  String get stopDownloads;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @downloadMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to download {count, plural, =1{{count} episode} other{{count} episodes}}?'**
  String downloadMessage(num count);

  /// No description provided for @stopMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to stop all the current downloads?'**
  String get stopMessage;

  /// No description provided for @hide.
  ///
  /// In en, this message translates to:
  /// **'hide'**
  String get hide;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'read more'**
  String get readMore;

  /// No description provided for @added.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get added;

  /// No description provided for @nothingToImport.
  ///
  /// In en, this message translates to:
  /// **'Nothing new to import'**
  String get nothingToImport;

  /// No description provided for @sync.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get sync;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @downloads.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get downloads;

  /// No description provided for @downloadsDir.
  ///
  /// In en, this message translates to:
  /// **'Downloads directory'**
  String get downloadsDir;

  /// No description provided for @selectDownloadsDir.
  ///
  /// In en, this message translates to:
  /// **'Please select a directory to look for MP3 files.'**
  String get selectDownloadsDir;

  /// No description provided for @changeDownloadsDir.
  ///
  /// In en, this message translates to:
  /// **'Change downloads directory'**
  String get changeDownloadsDir;

  /// No description provided for @newEpisodesTitle.
  ///
  /// In en, this message translates to:
  /// **'There are new episodes!'**
  String get newEpisodesTitle;

  /// No description provided for @andOthers.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{, and one other} other{, and {count} others}}'**
  String andOthers(num count);

  /// No description provided for @notificationChannelName.
  ///
  /// In en, this message translates to:
  /// **'Podcasks sync'**
  String get notificationChannelName;

  /// No description provided for @notificationChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Notification channel for podcast episodes sync'**
  String get notificationChannelDescription;

  /// No description provided for @notificationGroupName.
  ///
  /// In en, this message translates to:
  /// **'Podcasks notifications'**
  String get notificationGroupName;

  /// No description provided for @unknownPlayerError.
  ///
  /// In en, this message translates to:
  /// **'Unknown player error'**
  String get unknownPlayerError;

  /// No description provided for @playbackInterrupted.
  ///
  /// In en, this message translates to:
  /// **'Playback interrupted'**
  String get playbackInterrupted;

  /// No description provided for @anErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {error}'**
  String anErrorOccurred(Object error);

  /// No description provided for @todo.
  ///
  /// In en, this message translates to:
  /// **'TODO'**
  String get todo;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @dynamicColor.
  ///
  /// In en, this message translates to:
  /// **'Dynamic Color'**
  String get dynamicColor;

  /// No description provided for @dynamicColorDescription.
  ///
  /// In en, this message translates to:
  /// **'Use system colors (Android 12+)'**
  String get dynamicColorDescription;

  /// No description provided for @backup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// No description provided for @syncTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get syncTitle;

  /// No description provided for @syncFrequency.
  ///
  /// In en, this message translates to:
  /// **'Sync Frequency'**
  String get syncFrequency;

  /// No description provided for @syncFrequencyDescription.
  ///
  /// In en, this message translates to:
  /// **'How often the app checks for new episodes in the background'**
  String get syncFrequencyDescription;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'hour'**
  String get hour;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @storage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storage;

  /// No description provided for @downloadDirectory.
  ///
  /// In en, this message translates to:
  /// **'Download Directory'**
  String get downloadDirectory;

  /// No description provided for @defaultPath.
  ///
  /// In en, this message translates to:
  /// **'Default (app internal)'**
  String get defaultPath;
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
      <String>['en', 'es', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
