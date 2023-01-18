import 'package:anime_scraping/anime_scraping.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final anime = AnimeScraping();

    setUp(() {
      // Additional setup goes here.
    });

    test("test keluaran anime", anime.ongoing);
  });
}
