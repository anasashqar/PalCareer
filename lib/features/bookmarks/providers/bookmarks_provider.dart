import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BookmarksNotifier extends StateNotifier<Set<String>> {
  final Box<List<String>> _box = Hive.box<List<String>>('bookmarks');

  BookmarksNotifier() : super({}) {
    final saved = _box.get('job_bookmarks') ?? [];
    state = saved.toSet();
  }

  void toggleBookmark(String jobId) {
    if (state.contains(jobId)) {
      state = {...state}..remove(jobId);
    } else {
      state = {...state}..add(jobId);
    }
    _box.put('job_bookmarks', state.toList());
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
