class SearchItem {
  final String query;
  final String timestamp;

  SearchItem(this.query, this.timestamp);

  // Convert a SearchItem into a Map
  Map<String, String> toMap() {
    return {
      'query': query,
      'timestamp': timestamp,
    };
  }

  // Convert a Map into a SearchItem
  static SearchItem fromMap(Map<String, dynamic> map) {
    return SearchItem(
      map['query'] as String,
      map['timestamp'] as String,
    );
  }
}
