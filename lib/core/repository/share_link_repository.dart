import 'package:paperless_mobile/core/repository/remote_data_cache.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

const defaultShareLinksPageSize = 100000;

class ShareLinkRepository {
  final RemoteDataCache _staticDataRepository;
  final PaperlessNgxApiV9 _api;

  const ShareLinkRepository(this._staticDataRepository, this._api);

  Future<ShareLink?> findAll({
    int? page,
    int? pageSize,
  }) async {
    try {
      final response = await _api.getShareLinksApi().shareLinksList(
            page: page,
            pageSize: pageSize ?? defaultShareLinksPageSize,
          );
      if (response.data?.results != null && response.data!.results.isNotEmpty) {
        for (final shareLink in response.data!.results) {
          _staticDataRepository.shareLinks[shareLink.id] = shareLink;
        }
        _staticDataRepository.update(
          shareLinks: Map.fromEntries(
            response.data!.results.map(
              (sl) => MapEntry(sl.id, sl),
            ),
          ),
        );
        return response.data!.results.first;
      }
    } catch (e) {
      // Handle error appropriately, e.g., log it or rethrow
    }
    return null;
  }

  Future<ShareLink?> find({
    required int id,
  }) async {
    final response = await _api.getShareLinksApi().shareLinksRetrieve(id: id);
    if (response.data != null) {
      final existing = _staticDataRepository.shareLinks;
      _staticDataRepository.update(
        shareLinks: {...existing, response.data!.id: response.data!},
      );
    }
    return response.data!;
  }

  Future<ShareLink> create({
    required ShareLinkRequest shareLinkRequest,
  }) async {
    final response = await _api.getShareLinksApi().shareLinksCreate(
          shareLinkRequest: shareLinkRequest,
        );
    if (response.data != null) {
      final existing = _staticDataRepository.shareLinks;
      _staticDataRepository.update(
        shareLinks: {...existing, response.data!.id: response.data!},
      );
    }
    return response.data!;
  }

  Future<ShareLink> update({
    required int id,
    required ShareLinkRequest shareLinkRequest,
  }) async {
    final response = await _api.getShareLinksApi().shareLinksUpdate(
          id: id,
          shareLinkRequest: shareLinkRequest,
        );
    if (response.data != null) {
      final existing = _staticDataRepository.shareLinks;
      _staticDataRepository.update(
        shareLinks: {...existing, response.data!.id: response.data!},
      );
    }
    return response.data!;
  }

  Future<void> delete({required int id}) async {
    await _api.getShareLinksApi().shareLinksDestroy(id: id);
    final existing = _staticDataRepository.shareLinks;
    existing.remove(id);
    _staticDataRepository.update(shareLinks: existing);
  }
}
