import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:his/core/services/get_it.dart';
import 'package:his/core/utils/app_colors.dart';
import 'package:his/core/utils/app_text_styles.dart';
import 'package:his/features/bookmarks/data/repos/bookmarks_repo.dart';
import 'package:his/features/bookmarks/presentation/cubits/bookmarks_cubit/bookmarks_cubit.dart';
import 'package:his/features/category/data/model/media_model.dart';
import 'package:his/features/home/presentation/view/widgets/featured_video_card_widget.dart';
import 'package:his/features/home/presentation/view/widgets/likes_and_comment_widget.dart';

class FeaturedVideosItem extends StatelessWidget {
  const FeaturedVideosItem({super.key, required this.mediaModel});
  final MediaModel mediaModel;
  @override
  Widget build(BuildContext context) {
    String? text = mediaModel.description ?? '';
    final isHtml = text.contains(RegExp(r'<[a-z][\s\S]*>'));
    return Container(
      width: MediaQuery.of(context).size.width - 48.w,
      height: 338.h,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.lightGrey, width: 1)),
      ),
      child: Column(children: [
        BlocProvider(
          create: (context) => BookmarksCubit(getIt<BookmarksRepo>()),
          child: FeaturedVideoCardWidget(
            mediaModel: mediaModel,
          ),
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.only(
            left: 24.w,
            right: 24.w,
            top: 4.h,
          ),
          child: Column(
            children: [
              Text(
                mediaModel.title ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Styles.semiBoldPoppins14,
              ),
              isHtml
                  ? Html(data: mediaModel.description ?? '', style: {
                      "p": Style(
                          padding: HtmlPaddings.zero,
                          margin: Margins.zero,
                          textOverflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          color: AppColors.grey,
                          fontSize: FontSize(12),
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins')
                    })
                  : Column(
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          mediaModel.description ?? '',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Styles.regularPoppins12.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
          child: Column(
            children: [
              const Divider(
                color: AppColors.lightGrey,
              ),
              const SizedBox(
                height: 8,
              ),
              LikesAndCommentsWidget(
                isLiked: mediaModel.isLiked ?? false,
                mediaId: mediaModel.id!,
                numberOfComments: mediaModel.commentsCount ?? 0,
                numberOfLikes: mediaModel.likesCount ?? 0,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
