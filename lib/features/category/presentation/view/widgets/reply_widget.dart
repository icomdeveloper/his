import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:his/constants.dart';
import 'package:his/core/helpers/calculate_time_ago.dart';
import 'package:his/core/utils/app_text_styles.dart';
import 'package:his/features/home/data/models/comments_model/reply_model.dart';

import '../../../../../core/utils/app_colors.dart';

class ReplyWidget extends StatelessWidget {
  const ReplyWidget({
    super.key,
    required this.reply,
  });

  final ReplyModel reply;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          minTileHeight: 62.h,
          contentPadding: EdgeInsets.zero,
          isThreeLine: true,
          leading: InkWell(
            onTap: () {
              if (reply.user?.profileImage != null) {
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
                        imageUrl: reply.user?.profileImage ?? avatarImage,
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
                  reply.user?.profileImage ?? avatarImage),
              radius: 12.r,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                reply.user?.name ?? '',
                style: Styles.semiBoldPoppins12,
              ),
              Text(getRelativeTime(reply.createdAt ?? DateTime.now()),
                  style: Styles.regularPoppins12.copyWith(
                    fontSize: 10,
                    color: AppColors.grey,
                  )),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(reply.content ?? '',
                  style: Styles.regularPoppins12.copyWith(
                    color: AppColors.grey,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
