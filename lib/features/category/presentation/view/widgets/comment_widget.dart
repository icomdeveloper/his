import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:his/constants.dart';
import 'package:his/core/helpers/calculate_time_ago.dart';
import 'package:his/core/utils/app_colors.dart';
import 'package:his/core/utils/app_text_styles.dart';
import 'package:his/core/utils/assets.dart';
import 'package:his/features/authentication/data/models/user_data/user_information.dart';
import 'package:his/features/category/presentation/cubits/add_comments_cubit/comments_cubit.dart';
import 'package:his/features/category/presentation/view/widgets/comment_text_field.dart';
import 'package:his/features/category/presentation/view/widgets/replies_list_view_widget.dart';
import 'package:his/features/home/data/models/comments_model/comments_model.dart';
import 'package:his/features/home/presentation/cubits/comment_likes_cubit/comment_like_cubit.dart';

class CommentWidget extends StatefulWidget {
  const CommentWidget({
    super.key,
    required this.comment,
    required this.status,
  });
  final CommentsModel comment;
  final String status;
  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool showReplyTextField = false;
  late bool _isLiked;
  @override
  initState() {
    super.initState();
    _isLiked = widget.comment.isLiked ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final UserInformation userInformation = widget.comment.user!;
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          isThreeLine: true,
          leading: InkWell(
            onTap: () {
              if (userInformation.profileImage != null) {
                showDialog(
                  context: context,
                  builder: (_) => Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 220.h),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: userInformation.profileImage!,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }
            },
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                userInformation.profileImage ?? avatarImage,
              ),
              radius: 20.r,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                userInformation.name!,
                style: Styles.semiBoldPoppins14,
              ),
              Text(getRelativeTime(widget.comment.createdAt!),
                  style: Styles.regularPoppins12.copyWith(
                    fontSize: 10,
                    color: AppColors.grey,
                  ))
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7),
                    child: Text(
                      widget.comment.content!,
                      style: Styles.regularPoppins12.copyWith(
                        color: AppColors.darkGrey,
                      ),
                    ),
                  ),
                  const Spacer(),
                  widget.status == 'pending'
                      ? const SizedBox.shrink()
                      : InkWell(
                          onTap: () {
                            if (_isLiked) {
                              context
                                  .read<CommentLikeCubit>()
                                  .deleteLike(commentId: widget.comment.id!);
                            } else {
                              context
                                  .read<CommentLikeCubit>()
                                  .addLike(commentId: widget.comment.id!);
                            }
                          },
                          child:
                              BlocListener<CommentLikeCubit, CommentLikeState>(
                            listener: (context, state) {
                              if (state is AddLikeSuccess) {
                                _isLiked = true;
                              }
                              if (state is DeleteLikeSuccess) {
                                _isLiked = false;
                              }
                              if (state is AddLikeFailure) {
                                Fluttertoast.showToast(msg: state.message);
                              }
                              if (state is DeleteLikeFailure) {
                                Fluttertoast.showToast(msg: state.message);
                              }
                              setState(() {});
                            },
                            child: Icon(
                              _isLiked
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                              size: 18,
                              color: AppColors.darkGrey,
                            ),
                          ),
                        )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    showReplyTextField = !showReplyTextField;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(Assets.assetsImagesReply),
                    const SizedBox(
                      width: 8,
                    ),
                    Text('Reply',
                        style: Styles.regularPoppins12
                            .copyWith(color: AppColors.grey)),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              widget.comment.replies?.isEmpty ?? true
                  ? const SizedBox.shrink()
                  : RepliesListViewWidget(
                      replies: widget.comment.replies,
                    ),
              showReplyTextField
                  ? CommentTextField(
                      autofocus: true,
                      controller: context.read<CommentsCubit>().replyController,
                      onTap: () {
                        context.read<CommentsCubit>().addReply(
                            isPending: widget.status == 'pending',
                            mediaId: widget.comment.mediaId!,
                            parentId: widget.comment.id!);
                      })
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }
}
