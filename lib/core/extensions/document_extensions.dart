import 'package:collection/collection.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

extension DocumentModelIterableExtension on Iterable<Document> {
  Iterable<int> get ids => map((e) => e.id);

  Iterable<Document> withDocumentreplaced(Document document) {
    return map((e) => e.id == document.id ? document : e);
  }

  bool containsDocument(Document document) {
    return ids.contains(document.id);
  }

  Iterable<Document> withDocumentRemoved(Document document) {
    return whereNot((element) => element.id == document.id);
  }
}
