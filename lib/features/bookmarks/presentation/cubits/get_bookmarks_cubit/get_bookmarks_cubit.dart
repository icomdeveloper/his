import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:his/features/bookmarks/data/repos/bookmarks_repo.dart';
import 'package:his/features/category/data/model/media_model.dart';
import 'package:meta/meta.dart';

part 'get_bookmarks_state.dart';

class GetBookmarksCubit extends Cubit<GetBookmarksState> {
  GetBookmarksCubit(this.bookmarksRepo) : super(GetBookmarksInitial());
  final BookmarksRepo bookmarksRepo;

  Future<void> getBookmarksVideos({required BuildContext context}) async {
    emit(GetBookmarksLoading());
    final result = await bookmarksRepo.getBookmarksVideos(
      context: context,
    );
    if (isClosed) return;
    result.fold(
        (error) => emit(GetBookmarksFailure(errMessage: error.errMesage)),
        (success) => emit(GetBookmarksSuccess(mediaList: success)));
  }
}
