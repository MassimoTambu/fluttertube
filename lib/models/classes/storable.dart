import 'package:fluttertube/models/enums/local_storage_key_types.dart';

abstract class Storable {
  final LocalStorageKeyTypes lsKey;

  const Storable(this.lsKey);

  Future<bool> save<T>(T value);
}
