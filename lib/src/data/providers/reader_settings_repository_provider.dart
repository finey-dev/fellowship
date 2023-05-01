import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fellowship/src/data/repositories/repositories.dart';

final readerSettingsRepositoryProvider =
    ChangeNotifierProvider<ReaderSettingsRepository>((ref) {
  return ReaderSettingsRepository();
});
