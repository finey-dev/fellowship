import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fellowship/src/data/repositories/repositories.dart';

final studyToolsRepositoryProvider =
    ChangeNotifierProvider<StudyToolsRepository>((ref) {
  return StudyToolsRepository();
});
