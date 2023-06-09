import 'package:dio/dio.dart';
import 'package:fellowship/src/data/models/models.dart';
import 'package:fellowship/src/data/services/services.dart';

class VerseOfTheDayService {
  const VerseOfTheDayService(this._dio);
  final Dio _dio;
  final _rootUrl = 'https://devotionalium.com/api/v2';

  Future<List<Verse>> get getVerseOfTheDay async {
    try {
      final response = await _dio.get(_rootUrl);

      final result = response.data;

      var verses = <Verse>[];

      for (int item in result['1']['verses']) {
        var verse = Verse.fromMapFromVOTD(result, item);
        var newVerse = await BibleService().getVerses(
          verse.book.id.toString(),
          verse.chapterId.toString(),
          verse.verseId.toString(),
        );

        verses.add(newVerse[0]);
      }

      return verses;
    } catch (e) {
      return [
        Verse(
          id: 40028020,
          chapterId: 28,
          verseId: 20,
          text:
              'teaching them to observe all things whatsoever I have commanded you: and, lo, I am with you alway, even unto the end of the world. Amen.',
          book: Book(
            id: 40,
            name: 'Matthew',
            testament: 'New',
            chapters: [],
          ),
          favorite: false,
        ),
      ];
    }
  }
}
