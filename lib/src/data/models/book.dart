import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:fellowship/src/data/models/models.dart';

class Book {
  int? id;
  String? name;
  String? bookCode;
  String? testament;
  List<ChapterId>? chapters;

  Book({
    this.id,
    this.name,
    this.bookCode,
    this.testament,
    this.chapters,
  });

  Book copyWith({
    int? id,
    String? name,
    String? bookCode,
    String? testament,
    List<ChapterId>? chapters,
  }) {
    return Book(
      id: id ?? this.id,
      name: name ?? this.name,
      bookCode: bookCode ?? this.bookCode,
      testament: testament ?? this.testament,
      chapters: chapters ?? this.chapters,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'bookCode': bookCode,
      'testament': testament,
      'chapters': chapters?.map((x) => x.toMap()).toList(),
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      name: map['name'],
      bookCode: map['bookCode'],
      testament: map['testament'],
      chapters: [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Book.fromJson(String source) => Book.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Book(id: $id, name: $name, bookCode: $bookCode, testament: $testament, chapters: $chapters)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Book &&
        other.id == id &&
        other.name == name &&
        other.bookCode == bookCode &&
        other.testament == testament &&
        listEquals(other.chapters, chapters);
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ bookCode.hashCode ^ testament.hashCode ^ chapters.hashCode;
  }
}
