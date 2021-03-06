import 'package:fluttertube/models/enums/local_storage_key_types.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static final _prefs = SharedPreferences.getInstance();

  /// Ritorna [Set] di [String] tutte le keys presenti
  static Future<Set<String>> getAll() async {
    final prefs = await _prefs;

    return prefs.getKeys();
  }

  /// Ottiene il valore registrato in [key]
  static Future<T?> getValue<T>(LocalStorageKeyTypes lsKey) async {
    final key = lsKey.toShortString();
    final prefs = await _prefs;

    switch (T) {
      case bool:
        return prefs.getBool(key) as T?;
        break;
      case double:
        return prefs.getDouble(key) as T?;
        break;
      case int:
        return prefs.getInt(key) as T?;
        break;
      case String:
        return prefs.getString(key) as T?;
        break;
      case List:
        if (T as List<String> != null)
          return prefs.getStringList(key) as T?;
        else
          throw 'List Type not managed.';
        break;
      default:
        throw 'Type not managed.';
    }
  }

  /// Imposta [value] in [key]. Se [value] viene chiamato [deleteValue()] sulla [key].
  /// Ritorna [bool] indicante l'esito.
  static Future<bool> setValue<T>(LocalStorageKeyTypes lsKey, T value) async {
    final key = lsKey.toShortString();

    if (value == null) {
      return deleteValue(lsKey);
    }

    final prefs = await _prefs;

    switch (T) {
      case bool:
        return prefs.setBool(key, value as bool);
        break;
      case double:
        return prefs.setDouble(key, value as double);
        break;
      case int:
        return prefs.setInt(key, value as int);
        break;
      case String:
        return prefs.setString(key, value as String);
        break;
      case List:
        if (T as List<String> != null)
          return prefs.setStringList(key, value as List<String>);
        else
          throw 'List Type not managed.';
        break;
      default:
        throw 'Type not managed.';
    }
  }

  /// Cancella la entry [key][value] dato [key]
  static Future<bool> deleteValue(LocalStorageKeyTypes lsKey) async {
    final key = lsKey.toShortString();
    final prefs = await _prefs;

    return prefs.remove(key);
  }

  /// Verifica se esiste [key]
  static Future<bool> containsKey(LocalStorageKeyTypes lsKey) async {
    final key = lsKey.toShortString();
    final prefs = await _prefs;

    return prefs.containsKey(key);
  }
}
