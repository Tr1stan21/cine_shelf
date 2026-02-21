import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import 'tmdb_remote_data_source.dart';

final tmdbRemoteDataSourceProvider = Provider<TmdbRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return TmdbRemoteDataSource(dio);
});
