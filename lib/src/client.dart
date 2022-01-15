import 'package:meilisearch/src/pending_update.dart';

import 'http_request.dart';
import 'index.dart';
import 'client_impl.dart';
import 'stats.dart' show AllStats;

abstract class MeiliSearchClient {
  factory MeiliSearchClient(String serverUrl,
      [String? apiKey, int? connectTimeout]) = MeiliSearchClientImpl;

  /// Http client instance.
  HttpRequest get http;

  /// MeiliSearch server URL.
  String get serverUrl;

  /// Master key for authenticating with meilisearch server.
  String? get apiKey;

  /// Timeout in milliseconds for opening a url.
  int? get connectTimeout;

  /// Create an index object by given [uid].
  MeiliSearchIndex index(String uid);

  /// Return list of all existing indexes.
  Future<List<MeiliSearchIndex>> getIndexes();

  /// Find index by matching [uid]. Throws error if index is not exists.
  Future<MeiliSearchIndex> getIndex(String uid);

  /// Create a new index by given [uid] and optional [primaryKey] parameter.
  /// Throws an error if index is already exists.
  Future<PendingUpdate> createIndex(String uid, {String primaryKey});

  /// Delete the index by matching [uid].
  Future<PendingUpdate> deleteIndex(String uid);

  /// Update the primary Key of the index by matching [uid].
  Future<PendingUpdate> updateIndex(String uid, String primaryKey);

  /// Return health of the MeiliSearch server.
  /// Throws an error if containing details if MeiliSearch can't process your request.
  Future<Map<String, dynamic>> health();

  /// Get health of the MeiliSearch server.
  /// Return true or false.
  Future<bool> isHealthy();

  /// Trigger a dump creation process.
  Future<Map<String, String>> createDump();

  /// Get the status of a dump creation process.
  Future<Map<String, String>> getDumpStatus(String uid);

  /// Get the public and private keys.
  Future<Map<String, String>> getKeys();

  /// Get the MeiliSearch version
  Future<Map<String, String>> getVersion();

  /// Get all index stats.
  Future<AllStats> getStats();
}
