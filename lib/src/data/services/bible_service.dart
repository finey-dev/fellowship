import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:fellowship/src/configs/configs.dart';
import 'package:fellowship/src/data/models/models.dart';
import 'package:fellowship/src/data/providers/providers.dart';
import 'package:fellowship/src/data/repositories/repositories.dart';

class BibleService {
  BibleService();

  final jsonText = rootBundle.loadString('lib/api/bible/$translationAbb.json');

  Future<List<Book>> getBooks(String? bookID) async {
    try {
      if (!['', null].contains(bookID)) {
        final text = await jsonText;

        final map = json.decode(text) as Map<String, dynamic>;

        final bibleText = map['resultset']['row'] as List<dynamic>;

        final bookText = bibleText
            .where((element) => element['field']![1].toString() == bookID)
            .toList();

        final chapters = {
          for (var item in bookText) ChapterId(id: item['field']![2]),
        }.toList();

        final book = Book(
          id: bookText[0]['field']![1],
          name: BibleRepository().mapOfBibleBooks[int.parse(bookID!)],
          testament: bookText[0]['field']![1] >= 40 ? 'New' : 'Old',
          chapters: chapters,
        );

        return [book];
      } else {
        final books = BibleRepository().getBooks();

        return books;
      }
    } on DioError catch (e) {
      await FirebaseCrashlytics.instance.recordError(e, e.stackTrace);
      throw Exceptions.fromDioError(e);
    }
  }

  Future<Chapter> getChapter(
      String bookID, String chapterID, String translationID) async {
    try {
      final text = await jsonText;

      final books = await getBooks(bookID);

      final map = json.decode(text) as Map<String, dynamic>;

      final bibleText = map['resultset']['row'] as List<dynamic>;

      final bookText = bibleText
          .where((element) => element['field']![1].toString() == bookID)
          .toList();

      final chapterText = bookText
          .where((element) => element['field']![2].toString() == chapterID)
          .toList();

      final verses = {
        for (var item in chapterText)
          Verse.fromList(item['field']).copyWith(book: books[0]),
      }.toList();

      final chapter = Chapter(
        id: int.parse(chapterID),
        number: chapterID,
        translation: translationID,
        verses: verses,
        bookmarked: false,
      );

      return chapter;
    } on DioError catch (e) {
      await FirebaseCrashlytics.instance.recordError(e, e.stackTrace);
      throw Exceptions.fromDioError(e);
    }
  }

  Future<List<Chapter>> getChapters(String? bookID) async {
    try {
      final text = await jsonText;

      final map = json.decode(text) as Map<String, dynamic>;

      final bibleText = map['resultset']['row'] as List<dynamic>;

      final bookText = bibleText
          .where((element) => element['field']![1].toString() == bookID)
          .toList();

      final verses = {
        for (var item in bookText) Verse.fromList(item['field']),
      }.toList();

      final chapters = [
        for (var item in bookText)
          Chapter(
            id: bookText[0]['field']![2],
            number: bookText[0]['field']![2].toString(),
            translation: translationID,
            verses: verses
                .where((element) => element.chapterId == item['field']![2])
                .toList(),
            bookmarked: false,
          )
      ];

      return chapters;
    } on DioError catch (e) {
      await FirebaseCrashlytics.instance.recordError(e, e.stackTrace);
      throw Exceptions.fromDioError(e);
    }
  }

  Future<List<Verse>> getVerses(
      String bookID, String chapterID, String? verseID) async {
    try {
      final text = await jsonText;

      final map = json.decode(text) as Map<String, dynamic>;

      final bibleText = map['resultset']['row'] as List<dynamic>;

      final books = await getBooks(bookID);

      if (!['', null].contains(verseID)) {
        var vId = bookID;

        switch (chapterID.length) {
          case 1:
            vId += '00' + chapterID;
            break;
          case 2:
            vId += '0' + chapterID;
            break;
          default:
            vId += chapterID;
        }
        switch (verseID!.length) {
          case 1:
            vId += '00' + verseID;
            break;
          case 2:
            vId += '0' + verseID;
            break;
          default:
            vId += verseID;
        }

        final verseElement = bibleText
            .where((element) => element['field']![0].toString() == vId)
            .toList()[0]['field'] as List<dynamic>;

        verseElement[1] = books;

        final verses = [Verse.fromList(verseElement)];

        return verses;
      } else {
        final bookText = bibleText
            .where((element) => element['field']![1].toString() == bookID)
            .toList();

        final chapterText = bookText
            .where((element) => element['field']![2].toString() == chapterID);

        final books = await getBooks(bookID);

        final verses = {
          for (var item in chapterText)
            Verse.fromList(item['field']).copyWith(book: books[0]),
        }.toList();

        return verses;
      }
    } on DioError catch (e) {
      await FirebaseCrashlytics.instance.recordError(e, e.stackTrace);
      throw Exceptions.fromDioError(e);
    }
  }
}
