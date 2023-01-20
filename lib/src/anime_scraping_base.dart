import 'package:anime_scraping/model/model.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

class AnimeScraping {
  late String? baseUrl;

  AnimeScraping({this.baseUrl = 'https://otakudesu.is'});

  Future<String> _request(String path) async {
    Uri uri = Uri.parse(baseUrl! + path);

    var res = await http.get(uri);
    return res.body;
  }

  Future<List<ListAnimeModel>> ongoing() async {
    var anime = await _listAnime('ongoing-anime/');
    anime.remove(anime.last);

    return anime;
  }

  Future<List<ListAnimeModel>> complete() async {
    var anime = await _listAnime('complete-anime/');
    anime.remove(anime.last);

    return anime;
  }

  Future<List<ListAnimeModel>> _listAnime(String path) async {
    String body = await _request('/$path');

    List<ListAnimeModel> res = [];

    if (body.isNotEmpty) {
      var $ = parse(body);
      var listAnime =
          $.getElementsByClassName('rseries')[0].getElementsByTagName('li');

      for (int i = 0; i < listAnime.length; i++) {
        var anime = listAnime[i];

        Uri id = Uri.parse(
            anime.getElementsByTagName('a')[0].attributes['href'] ?? "");

        res.add(ListAnimeModel(
          id.pathSegments[1], // id
          anime.getElementsByClassName('jdlflm')[0].text, // title
          anime.getElementsByTagName('img')[0].attributes['src']!, // image
          anime.getElementsByClassName('epztipe')[0].text, // day
          anime.getElementsByClassName('newnime')[0].text, // date
          anime.querySelector('.epz')!.text, // totalEpisode
        ));
      }
    }

    return res;
  }

  Future<AnimeModel> anime(String id) async {
    String body = await _request('/anime/$id');

    AnimeModel res = animeModelDefault;

    if (body.isNotEmpty) {
      var $ = parse(body);
      var episodes = $
          .getElementsByClassName('episodelist')[1]
          .getElementsByTagName('li')
          .map((e) {
        Uri id =
            Uri.parse(e.getElementsByTagName('a')[0].attributes['href'] ?? "");

        return EpisodesListModel(
          id.pathSegments[1],
          e.getElementsByTagName('a')[0].text,
          e.getElementsByClassName('zeebr')[0].text,
        );
      }).toList();

      var fotoAnime = $.getElementsByClassName('fotoanime')[0];

      var info = $
          .getElementsByClassName('infozin')[0]
          .getElementsByTagName('p')
          .map(
              (e) => {e.text.split(':')[0].trim(): e.text.split(':')[1].trim()})
          .toList();

      res = AnimeModel(
        episodes,
        fotoAnime.querySelector('img')!.attributes['src']!,
        fotoAnime.querySelectorAll('.sinopc p').map((e) => e.text).join('\n'),
        info,
      );
    }

    return res;
  }

  Future<List<EpisodeModel>> episode(String id) async {
    String body = await _request('/episode/$id');

    List<EpisodeModel> res = [];

    if (body.isNotEmpty) {
      var $ = parse(body);

      var download = $
          .querySelector('.download')!
          .getElementsByTagName('li')
          .map<EpisodeModel>((e) {
        var title = e.getElementsByTagName('strong')[0].text.toLowerCase();

        if (RegExp(r'mkv').hasMatch(title)) return EpisodeModel('', '', '');

        String url = '';
        for (var a in e.getElementsByTagName('a')) {
          // print(a.text);
          String text = a.text.toLowerCase().trim();
          if (text == 'zippyshare' || text == 'zippy') {
            url = a.attributes['href']!;
            break;
          }
        }

        return EpisodeModel(
          title.replaceAll(RegExp(r'mp4+'), '').trim(),
          url,
          e.getElementsByTagName('i')[0].text,
        );
      }).toList();

      for (var d in download) {
        if (d.url.isNotEmpty && d.resolusi.isNotEmpty && d.size.isNotEmpty)
          res.add(d);
      }
    }

    return res;
  }

  Future<List<AnimeSearchModel>> searchAnime(String query) async {
    String body = await _request('/?s=$query&post_type=anime');

    List<AnimeSearchModel> res = [];

    if (body.isNotEmpty) {
      var $ = parse(body);

      res = $
          .getElementsByClassName('chivsrc')[0]
          .getElementsByTagName('li')
          .map<AnimeSearchModel>((e) {
        Uri id =
            Uri.parse(e.getElementsByTagName('a')[0].attributes['href'] ?? "");

        return AnimeSearchModel(
          id.pathSegments[1],
          e.getElementsByTagName('a')[0].text,
          e.getElementsByTagName('img')[0].attributes['src']!,
        );
      }).toList();
    }

    return res;
  }

  Future<String> downloadLink(EpisodeModel episodeModel) async {
    var value = await http.get(
      Uri.parse(episodeModel.url),
    );

    var $ = parse(value.body);
    var url =
        'https:${$.querySelector('meta[property="og:url"]')?.attributes['content']}';

    url = Uri.parse(url).host;
    var downloadUrl = $.body
        ?.getElementsByTagName('script')[2]
        .text
        .trim()
        .split(';')[0]
        .split(RegExp(r'(=|\+)'));
    downloadUrl?.removeRange(0, 1);

    int id = _fixId(downloadUrl![1]) + _fixId(downloadUrl[2]);

    return 'https://$url${downloadUrl[0].replaceAll('"', '').trim()}$id${downloadUrl[3].replaceAll('"', '').trim()}';
  }

  Future<List<String>> downloadLinks(List<EpisodeModel> episodeModels) async {
    List<String> url = [];

    for (var episode in episodeModels) {
      url.add(
        await downloadLink(episode),
      );
    }

    return url;
  }

  int _fixId(String input) {
    var ids = input.replaceAll(RegExp(r'(\(|\))'), '').split('%');

    return int.parse(ids[0]) % int.parse(ids[1]);
  }
}
