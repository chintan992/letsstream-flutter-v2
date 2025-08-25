class TmdbResponse<T> {
  final int page;
  final List<T> results;
  final int totalPages;
  final int totalResults;

  TmdbResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory TmdbResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return TmdbResponse(
      page: json['page'] as int,
      results: (json['results'] as List)
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(),
      totalPages: json['total_pages'] as int,
      totalResults: json['total_results'] as int,
    );
  }

  Map<String, dynamic> toJson(
    Map<String, dynamic> Function(T) toJsonT,
  ) {
    return {
      'page': page,
      'results': results.map((e) => toJsonT(e)).toList(),
      'total_pages': totalPages,
      'total_results': totalResults,
    };
  }
}