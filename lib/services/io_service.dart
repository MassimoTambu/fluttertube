import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class IOService {
  // Create storage
  static final _storage = new FlutterSecureStorage();

  // Read all values
  static Future<Map<String, String>> readAll() async {
    return await _storage.readAll();
  }

  static Future<String> readValue(String key) async {
    return await _storage.read(key: key);
  }

  static void write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  static void deleteAll() async {
    await _storage.deleteAll();
  }

  static void deleteValue(String key) async {
    await _storage.delete(key: key);
  }
}
