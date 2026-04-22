import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:podcasks/data/entities/episode/podcast_episode.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PrefsRepo {
  Future<void> setCountry(Country country);

  Future<Country> getCountry();

  Future<void> setLanguage(String language);

  Future<String> getLanguage();

  Map<String, String> getAllGenres(BuildContext context);

  Future<void> setDownloadsPath(String path);

  Future<String?> getDownloadsPath();

  Future<void> setSyncFrequency(int hours);

  Future<int> getSyncFrequency();

  Future<void> setDynamicColor(bool enabled);

  Future<bool> getDynamicColor();
}

class PrefsRepoSharedPref extends PrefsRepo {
  static const String countryKey = 'country_sp_key';
  static const String languageKey = 'language_sp_key';
  static const String downloadsPathKey = 'downloads_path_sp_key';
  static const String syncFrequencyKey = 'sync_frequency_sp_key';
  static const String dynamicColorKey = 'dynamic_color_sp_key';

  Future<SharedPreferences> get _getSp async =>
      await SharedPreferences.getInstance();

  @override
  Future<Country> getCountry() async {
    final sp = await _getSp;
    return Country.values
            .firstWhereOrNull((e) => e.code == sp.getString(countryKey)) ??
        Country.none;
  }

  @override
  Future<void> setCountry(Country country) async {
    final sp = await _getSp;
    await sp.setString(countryKey, country.code);
  }

  @override
  Future<String> getLanguage() async {
    final sp = await _getSp;
    return sp.getString(languageKey) ?? 'none';
  }

  @override
  Future<void> setLanguage(String language) async {
    final sp = await _getSp;
    await sp.setString(languageKey, language);
  }

  @override
  Map<String, String> getAllGenres(BuildContext context) => itunesGenres(context);

  @override
  Future<String?> getDownloadsPath() async {
    final sp = await _getSp;
    return sp.getString(downloadsPathKey);
  }

  @override
  Future<void> setDownloadsPath(String path) async {
    final sp = await _getSp;
    await sp.setString(downloadsPathKey, path);
  }

  @override
  Future<int> getSyncFrequency() async {
    final sp = await _getSp;
    return sp.getInt(syncFrequencyKey) ?? 2;
  }

  @override
  Future<void> setSyncFrequency(int hours) async {
    final sp = await _getSp;
    await sp.setInt(syncFrequencyKey, hours);
  }

  @override
  Future<bool> getDynamicColor() async {
    final sp = await _getSp;
    return sp.getBool(dynamicColorKey) ?? true;
  }

  @override
  Future<void> setDynamicColor(bool enabled) async {
    final sp = await _getSp;
    await sp.setBool(dynamicColorKey, enabled);
  }
}
