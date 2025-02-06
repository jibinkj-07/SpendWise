import 'package:shared_preferences/shared_preferences.dart';

import '../constant/constants.dart';

class SharedPrefHelper {
  final SharedPreferences _sharedPreference;

  SharedPrefHelper(this._sharedPreference);

  List<String> getTransactionSuggestions() =>
      _sharedPreference.getStringList(kTransTitleSuggestionKey) ?? [];

  Future<void> addTransactionSuggestion(String title) async {
    final list =
        _sharedPreference.getStringList(kTransTitleSuggestionKey) ?? [];
    if (!list.contains(title)) {
      list.add(title);
      await _sharedPreference.setStringList(kTransTitleSuggestionKey, list);
    }
  }

  Future<void> clearStorage() async => await _sharedPreference.clear();
}
