import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/locator.dart';
import 'package:podcasks/repository/prefs_repo.dart';
import 'package:podcasks/ui/vms/vm.dart';

final settingsViewmodel = ChangeNotifierProvider((ref) => SettingsViewmodel(ref));

class SettingsViewmodel extends Vm {
  final Ref ref;
  final _prefs = locator.get<PrefsRepo>();

  SettingsViewmodel(this.ref);

  Country _country = Country.none;
  Country get country => _country;

  String _language = 'none';
  String get language => _language;

  int _syncFrequency = 2;
  int get syncFrequency => _syncFrequency;

  bool _dynamicColor = true;
  bool get dynamicColor => _dynamicColor;

  String? _downloadPath;
  String? get downloadPath => _downloadPath;

  Future<void> init() async {
    loading();
    _country = await _prefs.getCountry();
    _language = await _prefs.getLanguage();
    _syncFrequency = await _prefs.getSyncFrequency();
    _dynamicColor = await _prefs.getDynamicColor();
    _downloadPath = await _prefs.getDownloadsPath();
    success();
  }

  Future<void> setCountry(Country? country) async {
    if (country == null) return;
    _country = country;
    await _prefs.setCountry(country);
    notifyListeners();
  }

  Future<void> setLanguage(String? language) async {
    if (language == null) return;
    _language = language;
    await _prefs.setLanguage(language);
    notifyListeners();
  }

  Future<void> setSyncFrequency(int? hours) async {
    if (hours == null) return;
    _syncFrequency = hours;
    await _prefs.setSyncFrequency(hours);
    notifyListeners();
    // In a real app, you'd reschedule the Workmanager task here.
  }

  Future<void> setDynamicColor(bool enabled) async {
    _dynamicColor = enabled;
    await _prefs.setDynamicColor(enabled);
    notifyListeners();
  }

  Future<void> pickDownloadPath() async {
    String? result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      _downloadPath = result;
      await _prefs.setDownloadsPath(result);
      notifyListeners();
    }
  }
}
