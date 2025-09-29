abstract class BaseService<T, RequestType> {
  Future<List<T>> getAll();
  Future<T?> getById(int id);
  Future<T> create(RequestType request);
  Future<T> update(int id, RequestType request);
  Future<void> delete(int id);
}
