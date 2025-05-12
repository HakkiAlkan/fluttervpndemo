import 'package:get_storage/get_storage.dart';

class StorageService {
  final GetStorage _storage;
  static StorageService? _instance;

  StorageService._(this._storage);

  static Future<StorageService> getInstance() async {
    await GetStorage.init();
    _instance ??= StorageService._(GetStorage());
    return _instance!;
  }

  Future<void> clearAll() async => await _storage.erase();

  Future<void> removeKey(String key) async => await _storage.remove(key);

  Future<void> setStringValue(String key, String value) async => await _storage.write(key, value);

  Future<void> setBoolValue(String key, bool value) async => await _storage.write(key, value);

  Future<void> setDouble(String key, double value) async => await _storage.write(key, value);

  Future<void> setInt(String key, int value) async => await _storage.write(key, value);

  String? getStringValue(String key) => _storage.read<String>(key);

  bool? getBoolValue(String key) => _storage.read<bool>(key);

  int? getInt(String key) => _storage.read<int>(key);

  double? getDouble(String key) => _storage.read<double>(key);
}
