import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fellowship/src/data/models/models.dart';
import 'package:fellowship/src/data/providers/providers.dart';

final verseOfTheDayFutureProvider = FutureProvider.autoDispose<List<Verse>>((ref) {
  ref.maintainState = true;

  return ref.watch(verseOfTheDayServiceProvider).getVerseOfTheDay;
});
