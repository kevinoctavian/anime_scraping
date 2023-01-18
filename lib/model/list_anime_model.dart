class ListAnimeModel {
  final String id;
  final String title;
  final String image;
  final String day;
  final String date;
  final String totalEpisode;

  ListAnimeModel(
    this.id,
    this.title,
    this.image,
    this.day,
    this.date,
    this.totalEpisode,
  );

  @override
  String toString() {
    return '''

\tid: $id
\ttitle: $title
\timage: $image
\tday: $day
\tdate: $date
\ttotalEpisode: $totalEpisode
''';
  }
}
