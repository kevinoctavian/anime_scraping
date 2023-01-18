class AnimeModel {
  final List<EpisodesListModel> episodes;
  final String image;
  final String sinopsis;
  final List<Map<String, String>> info;

  AnimeModel(this.episodes, this.image, this.sinopsis, this.info);

  @override
  String toString() {
    return '''
\timage: $image

\tsinopsis: $sinopsis

episodes: [${episodes.map((e) => '\n\tid: ${e.id}\n\ttitle: ${e.title}\n\tdate: ${e.date}').join(', ')}\n]

info: $info
''';
  }
}

class EpisodesListModel {
  final String id;
  final String title;
  final String date;

  EpisodesListModel(this.id, this.title, this.date);
}

AnimeModel animeModelDefault = AnimeModel(
  [EpisodesListModel('', '', '')],
  '',
  '',
  [
    {'': ''}
  ],
);
