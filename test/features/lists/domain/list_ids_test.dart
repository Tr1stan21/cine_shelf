import 'package:cine_shelf/features/lists/domain/list_ids.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('list_ids constants', () {
    test('watchedListId equals "watched"', () {
      expect(watchedListId, 'watched');
    });

    test('watchlistListId equals "watchlist"', () {
      expect(watchlistListId, 'watchlist');
    });

    test('favoritesListId equals "favorites"', () {
      expect(favoritesListId, 'favorites');
    });

    test('all three constants are distinct', () {
      final ids = {watchedListId, watchlistListId, favoritesListId};
      expect(ids, hasLength(3));
    });
  });
}
