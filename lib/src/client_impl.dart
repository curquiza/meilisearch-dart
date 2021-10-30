import 'http_request.dart';
import 'http_request_impl.dart';

import 'client.dart';
import 'index.dart';
import 'index_impl.dart';
import 'exception.dart';
import 'stats.dart' show AllStats;

class MeiliSearchClientImpl implements MeiliSearchClient {
  MeiliSearchClientImpl(this.serverUrl, [this.apiKey, this.connectTimeout])
      : http = HttpRequestImpl(serverUrl, apiKey, connectTimeout);

  @override
  final String serverUrl;

  @override
  final String? apiKey;

  @override
  final int? connectTimeout;

  final HttpRequest http;

  @override
  MeiliSearchIndex index(String uid) {
    return new MeiliSearchIndexImpl(this, uid);
  }

  @override
  Future<MeiliSearchIndex> createIndex(String uid, {String? primaryKey}) async {
    final data = <String, dynamic>{
      'uid': uid,
      if (primaryKey != null) 'primaryKey': primaryKey,
    };
    data.removeWhere((k, v) => v == null);
    final response = await http.postMethod<Map<String, dynamic>>(
      '/indexes',
      data: data,
    );

    return MeiliSearchIndexImpl.fromMap(this, response.data!);
  }

  @override
  Future<MeiliSearchIndex> getIndex(String uid) async {
    final response =
        await http.getMethod<Map<String, dynamic>>('/indexes/$uid');

    return MeiliSearchIndexImpl.fromMap(this, response.data!);
  }

  @override
  Future<List<MeiliSearchIndex>> getIndexes() async {
    final response = await http.getMethod<List<dynamic>>('/indexes');

    return response.data!
        .cast<Map<String, dynamic>>()
        .map((item) => MeiliSearchIndexImpl.fromMap(this, item))
        .toList();
  }

  @override
  Future<MeiliSearchIndex> getOrCreateIndex(
    String uid, {
    String? primaryKey,
  }) async {
    try {
      return await getIndex(uid);
    } on MeiliSearchApiException catch (e) {
      if (e.code != 'index_not_found') {
        throw (e);
      }
      return await createIndex(uid, primaryKey: primaryKey);
    }
  }

  @override
  Future<void> deleteIndex(String uid) async {
    final index = this.index(uid);
    await index.delete();
  }

  @override
  Future<void> updateIndex(String uid, String primaryKey) async {
    final index = this.index(uid);
    await index.update(primaryKey: primaryKey);
  }

  @override
  Future<Map<String, dynamic>> health() async {
    final response = await http.getMethod<Map<String, dynamic>>('/health');

    return response.data!;
  }

  @override
  Future<bool> isHealthy() async {
    try {
      await health();
    } on Exception catch (_) {
      return false;
    }
    return true;
  }

  @override
  Future<Map<String, String>> createDump() async {
    final response = await http.postMethod<Map<String, dynamic>>('/dumps');
    return response.data!.map((k, v) => MapEntry(k, v.toString()));
  }

  @override
  Future<Map<String, String>> getDumpStatus(String uid) async {
    final response =
        await http.getMethod<Map<String, dynamic>>('/dumps/$uid/status');
    return response.data!.map((k, v) => MapEntry(k, v.toString()));
  }

  @override
  Future<Map<String, String>> getKeys() async {
    final response = await http.getMethod<Map<String, dynamic>>('/keys');
    return response.data!.map((k, v) => MapEntry(k, v.toString()));
  }

  @override
  Future<Map<String, String>> getVersion() async {
    final response = await http.getMethod<Map<String, dynamic>>('/version');
    return response.data!.map((k, v) => MapEntry(k, v.toString()));
  }

  @override
  Future<AllStats> getStats() async {
    final response = await http.getMethod('/stats');

    return AllStats.fromMap(response.data);
  }
}
