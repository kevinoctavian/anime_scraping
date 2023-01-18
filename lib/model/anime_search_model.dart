class AnimeSearchModel {
  final String id;
  final String title;
  final String image;

  AnimeSearchModel(this.id, this.title, this.image);

  @override
  String toString() {
    return '''
\tId: $id
\tTitle: $title
\tImage: $image
''';
  }
}
