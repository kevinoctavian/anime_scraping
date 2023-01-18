class EpisodeModel {
  final String resolusi;
  final String url;
  final String size;

  EpisodeModel(this.resolusi, this.url, this.size);

  @override
  String toString() {
    return '''

Resolusi: $resolusi
Url: $url
Size: $size''';
  }
}
