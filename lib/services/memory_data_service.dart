import 'package:fluttertube/models/enums/data_key_types.dart';

class MemoryDataService {
  static Map<String, String> _data = {};

  static void loadDataToMemory(Map<String, String> data) {
    _data = data;
  }

  static String getData(DataKeyTypes dataKey) {
    return _data[dataKey];
  }
}
