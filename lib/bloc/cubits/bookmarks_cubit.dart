import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/bookmark.dart';
import '../../data/models/card_data.dart';

class BookmarksCubit extends Cubit<List<Bookmark>> {
  BookmarksCubit() : super([]);

  void toggleBookmark(CardData cardData) {
    final currentBookmarks = List<Bookmark>.from(state);

    final existingBookmarkIndex = currentBookmarks.indexWhere(
      (bookmark) => bookmark.cardData.id == cardData.id,
    );

    if (existingBookmarkIndex != -1) {
      currentBookmarks.removeAt(existingBookmarkIndex);
    } else {
      currentBookmarks.add(Bookmark(cardData: cardData));
    }

    emit(currentBookmarks);
  }

  bool isBookmarked(CardData cardData) {
    return state.any((bookmark) => bookmark.cardData.id == cardData.id);
  }
}
