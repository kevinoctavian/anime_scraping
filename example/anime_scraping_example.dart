import 'package:anime_scraping/anime_scraping.dart';

void main(List<String> args) async {
  AnimeScraping anime = AnimeScraping();

  List<ListAnimeModel> ongoing = await anime.complete(1);

  print(ongoing);

  // AnimeScraping().home().then(print);
  // AnimeScraping().anime('chaisaw-sub-indo').then(print);
  // AnimeScraping().episode('mipon-episode-1-sub-indo').then(print);
  //   AnimeScraping().downloadLink(value[0]).then(print);
  //   sleep(Duration(seconds: 2));
  //   AnimeScraping().downloadLinks(value).then(print);
  // });
  // AnimeScraping().ongoing().then(print);
  // AnimeScraping().complete().then(print);
}
