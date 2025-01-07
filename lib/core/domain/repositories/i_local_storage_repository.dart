abstract class ILocalStorageRepository {
  Future<void> save<T>(String key, T value);
  Future<T?> get<T>(String key);
  Future<void> remove(String key);
  Future<void> clear();

}
