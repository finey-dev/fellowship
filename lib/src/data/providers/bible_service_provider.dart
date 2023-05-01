import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fellowship/src/data/services/services.dart';

final bibleServiceProvider = Provider<BibleService>((ref) {
  return BibleService();
});
