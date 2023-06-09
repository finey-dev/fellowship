import 'dart:convert';

import 'package:fellowship/src/data/models/models.dart';
import 'package:fellowship/src/data/repositories/study_tools_repository.dart';

class Verse {
  int id;
  int chapterId;
  int verseId;
  String text;
  Book book;
  bool favorite;

  Verse({
    required this.id,
    required this.chapterId,
    required this.verseId,
    required this.text,
    required this.book,
    required this.favorite,
  });

  String get bookChapterVerse =>
      book.name! + ' ' + chapterId.toString() + ':' + verseId.toString();

  bool get isFavorite => StudyToolsRepository()
      .favoriteVerses
      .where((element) => element.id == id)
      .isNotEmpty;

  Verse copyWith({
    int? id,
    int? chapterId,
    int? verseId,
    String? text,
    Book? book,
    bool? favorite,
  }) {
    return Verse(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      verseId: verseId ?? this.verseId,
      text: text ?? this.text,
      book: book ?? this.book,
      favorite: favorite ?? this.favorite,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chapterId': chapterId,
      'verseId': verseId,
      'text': text,
      'book': book.toMap(),
      'favorite': favorite,
    };
  }

  factory Verse.fromMap(Map<String, dynamic> map) {
    return Verse(
      id: map['id'],
      chapterId: map['chapterId'],
      verseId: map['verseId'],
      text: map['verse'] ?? map['text'],
      book: Book.fromMap(map['book']),
      favorite: map['favorite'] ?? false,
    );
  }

  factory Verse.fromList(List<dynamic> list) {
    return Verse(
      id: list[0],
      chapterId: list[2],
      verseId: list[3],
      text: list[4],
      book: list[1].runtimeType == int ? Book() : list[1][0],
      favorite: false,
    );
  }

  factory Verse.fromMapFromVOTD(Map<String, dynamic> map, int verseNum) {
    final data = map['1'] as Map<String, dynamic>;

    final chapterId = data['chapter'] as int;
    final verseId = verseNum;
    final book = Book(
        id: data['bookNumber'],
        name: data['book'],
        testament: 'New',
        chapters: const []);

    return Verse(
      id: verseId,
      chapterId: chapterId,
      verseId: verseId,
      text: '',
      book: book,
      favorite: false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Verse.fromJson(String source) => Verse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Verse(id: $id, chapterId: $chapterId, verseId: $verseId, text: $text, book: $book, favorite: $favorite)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Verse &&
        other.id == id &&
        other.chapterId == chapterId &&
        other.verseId == verseId &&
        other.text == text &&
        other.book == book &&
        other.favorite == favorite;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        chapterId.hashCode ^
        verseId.hashCode ^
        text.hashCode ^
        book.hashCode ^
        favorite.hashCode;
  }
}
