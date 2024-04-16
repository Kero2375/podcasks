import 'package:collection/collection.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PrefsRepo {
  Future<void> setCountry(Country country);

  Future<Country> getCountry();
}

class PrefsRepoSharedPref extends PrefsRepo {
  static const String countryKey = 'country_sp_key';

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
}
