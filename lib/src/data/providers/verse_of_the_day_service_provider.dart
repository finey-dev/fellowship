import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fellowship/src/data/services/services.dart';

final verseOfTheDayServiceProvider = Provider<VerseOfTheDayService>((ref) {
  return VerseOfTheDayService(Dio());
});
