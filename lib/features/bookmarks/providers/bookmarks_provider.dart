import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookmarksNotifier extends StateNotifier<Set<String>> {
  BookmarksNotifier() : super({});

  void toggleBookmark(String jobId) {
    if (state.contains(jobId)) {
      state = {...state}..remove(jobId);
    } else {
      state = {...state}..add(jobId);
    }
  }

  bool isBookmarked(String jobId) {
    return state.contains(jobId);
  }
}

final bookmarksProvider = StateNotifierProvider<BookmarksNotifier, Set<String>>(
  (ref) {
    return BookmarksNotifier();
  },
);
