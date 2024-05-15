import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:podcasks/data/entities/episode/podcast_episode.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PrefsRepo {
  Future<void> setCountry(Country country);

  Future<Country> getCountry();

  Future<void> setGenre(String g);

  Map<String,String> getAllGenres(BuildContext context);

  Future<String> getGenre();
}

class PrefsRepoSharedPref extends PrefsRepo {
  static const String countryKey = 'country_sp_key';
  static const String genreKey = 'genre_sp_key';
  String genre = 'All';

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
  Map<String,String> getAllGenres(BuildContext context) => itunesGenres(context);

  @override
  Future<String> getGenre() async {
    return Future.value(genre);
  }

  @override
  Future<void> setGenre(String g) async {
    genre = g;
  }
}
