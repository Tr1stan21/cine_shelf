import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/config/env.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      headers: <String, dynamic>{
        'Authorization': 'Bearer ${Env.tmdbReadToken}',
        'Accept': 'application/json',
      },
    ),
  );
});
