
import 'package:fellowship/src/data/repositories/repositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider = ChangeNotifierProvider<UserRepository>((ref) {
  return UserRepository();
});
