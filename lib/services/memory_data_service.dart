import 'package:fluttertube/utils/data_keys_enum.dart';

class MemoryDataService {
  static Map<String, String> _data = {};

  static void loadDataToMemory(Map<String, String> data) {
    _data = data;
  }

  static String getData(DataKeys dataKey) {
    return _data[dataKey];
  }
}
