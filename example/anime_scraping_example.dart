import 'dart:io';

import 'package:anime_scraping/anime_scraping.dart';
import 'package:anime_scraping/model/list_anime_model.dart';

void main(List<String> args) async {
  AnimeScraping anime = AnimeScraping();

  List<ListAnimeModel> ongoing = await anime.ongoing();

  print(ongoing);

  // AnimeScraping().home().then(print);
  // AnimeScraping().anime('chaisaw-sub-indo').then(print);
  // AnimeScraping().episode('cm-episode-12-sub-indo').then(print);
  //   AnimeScraping().downloadLink(value[0]).then(print);
  //   sleep(Duration(seconds: 2));
  //   AnimeScraping().downloadLinks(value).then(print);
  // });
  // AnimeScraping().ongoing().then(print);
  // AnimeScraping().complete().then(print);
}
