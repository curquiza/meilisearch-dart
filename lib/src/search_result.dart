class SearchResult {
  SearchResult({
    this.hits,
    this.offset,
    this.limit,
    this.processingTimeMs,
    this.query,
    this.nbHits,
    this.exhaustiveNbHits,
    this.facetDistribution,
    this.exhaustiveFacetsCount,
  });

  /// Results of the query
  final List<Map<String, dynamic>> hits;

  /// Number of documents skipped
  final int offset;

  /// Number of documents to take
  final int limit;

  /// Processing time of the query
  final int processingTimeMs;

  /// Total number of matches
  final int nbHits;

  /// Whether [nbHits] is exhaustive
  final bool exhaustiveNbHits;

  /// [Distribution of the given facets](https://docs.meilisearch.com/guides/advanced_guides/search_parameters.html#the-facets-distribution)
  final dynamic facetDistribution;

  /// Whether [facetDistribution] is exhaustive
  final bool exhaustiveFacetsCount;

  /// Query originating the response
  final String query;

  factory SearchResult.fromMap(Map<String, dynamic> map) {
    return SearchResult(
      hits: (map['hits'] as List).cast<Map<String, dynamic>>(),
      query: map['query'] as String,
      limit: map['limit'] as int,
      offset: map['offset'] as int,
      processingTimeMs: map['processingTimeMs'] as int,
      nbHits: map['nbHits'] as int,
      exhaustiveNbHits: map['exhaustiveNbHits'] as bool,
      facetDistribution: map['facetDistribution'],
      exhaustiveFacetsCount: map['exhaustiveFacetsCount'] as bool,
    );
  }
}
