import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:his/core/helpers/get_user_data.dart';
import 'package:his/core/utils/app_colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:his/core/utils/app_text_styles.dart';
import 'package:his/core/utils/assets.dart';
import 'package:his/core/widgets/custom_text_button.dart';
import 'package:his/features/home/presentation/view/widgets/custom_text_field.dart';
import 'package:his/features/profile/data/model/upload_video_model.dart';
import 'package:his/features/profile/presentation/cubits/upload_media_cubit/upload_media_cubit.dart';
import 'package:his/features/profile/presentation/view/widgets/choose_file_button.dart';
import 'package:his/features/profile/presentation/view/widgets/custom_drop_down_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:his/features/profile/presentation/view/widgets/date_drop_down_button.dart';

class UploadVideoTab extends StatefulWidget {
  const UploadVideoTab({super.key});

  @override
  State<UploadVideoTab> createState() => _UploadVideoTabState();
}

class _UploadVideoTabState extends State<UploadVideoTab> {
  PlatformFile? videoFile, thumbnailFile, pdfFile;
  bool isSelecting = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12.h),
            Center(
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                padding: EdgeInsets.zero,
                color: AppColors.primaryColor,
                dashPattern: const [5, 5],
                child: Container(
                    width: MediaQuery.of(context).size.width - 48 - 10,
                    decoration: const ShapeDecoration(
                        color: AppColors.lightPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        )),
                    child: InkWell(
                        onTap: () async {
                          setState(() => isSelecting = true);
                          videoFile = await selectFile(type: FileType.video);
                          setState(() => isSelecting = false);
                        },
                        child: isSelecting
                            ? Center(
                                child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 65.h, horizontal: 65.w),
                                child: const CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                ),
                              ))
                            : videoFile == null
                                ? Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 40.h),
                                    child: Column(
                                      children: [
                                        SvgPicture.asset(
                                            Assets.assetsImagesUpload),
                                        Text.rich(TextSpan(children: [
                                          TextSpan(
                                            text: 'Drag & drop files or ',
                                            style: Styles.semiBoldPoppins14
                                                .copyWith(
                                                    color: const Color(
                                                        0xff0F0F0F)),
                                          ),
                                          TextSpan(
                                            text: 'Browse',
                                            style: Styles.semiBoldPoppins14
                                                .copyWith(
                                                    color:
                                                        AppColors.primaryColor),
                                          )
                                        ])),
                                        Text('Supported formates: videos, GIF',
                                            style: Styles.regularRoboto10
                                                .copyWith(
                                                    color: const Color(
                                                        0xff7B7B7B)))
                                      ],
                                    ),
                                  )
                                : Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 40.h),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                            width: 50.w,
                                            child: AspectRatio(
                                                aspectRatio: 1,
                                                child: SvgPicture.asset(Assets
                                                    .assetsImagesUploadVideo))),
                                        SizedBox(height: 16.h),
                                        Text(
                                          videoFile?.name ?? '',
                                          style: Styles.semiBoldPoppins14,
                                        )
                                      ],
                                    ),
                                  ))),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Upload image',
              style: Styles.semiBoldPoppins14,
            ),
            const SizedBox(
              height: 4,
            ),
            CustomTextField(
              hintText: 'Select your image ',
              controller:
                  TextEditingController(text: thumbnailFile?.name ?? ''),
              isSearch: false,
              readOnly: true,
              suffixIcon: ChooseFileButton(
                onTapped: () async {
                  thumbnailFile = await selectFile(type: FileType.image);
                },
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Upload PDF',
              style: Styles.semiBoldPoppins14,
            ),
            const SizedBox(
              height: 4,
            ),
            CustomTextField(
              hintText: 'Select your PDF ',
              isSearch: false,
              readOnly: true,
              controller: TextEditingController(text: pdfFile?.name ?? ''),
              suffixIcon: ChooseFileButton(
                onTapped: () async {
                  pdfFile = await selectFile(
                      type: FileType.custom,
                      allowedExtensions: ['pdf', 'doc', 'docx']);
                },
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Select Author',
              style: Styles.semiBoldPoppins14,
            ),
            // const SizedBox(height: 4),
            const CustomDropDownButton(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Year',
                      style: Styles.semiBoldPoppins14,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    DateDropDownButton(),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select month',
                      style: Styles.semiBoldPoppins14,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    DateDropDownButton(
                      isMonth: true,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Title',
              style: Styles.semiBoldPoppins14,
            ),
            const SizedBox(height: 4),
            CustomTextField(
              hintText: 'Write your title here ..',
              controller: titleController,
              isSearch: false,
            ),
            const SizedBox(height: 12),
            const Text(
              'Add Description',
              style: Styles.semiBoldPoppins14,
            ),
            const SizedBox(height: 4),
            CustomTextField(
              hintText: 'Write your description here ..',
              isSearch: false,
              maxLines: 7,
              controller: descriptionController,
            ),
            const SizedBox(height: 12),
            videoFile == null
                ? const SizedBox.shrink()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Uploading - 1/1 files',
                        style: Styles.semiBoldPoppins14
                            .copyWith(color: AppColors.grey),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              side: const BorderSide(
                                width: 1,
                                color: AppColors.lightGrey,
                              )),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  videoFile?.name ?? '',
                                  style: Styles.regularRoboto12
                                      .copyWith(color: const Color(0xff0F0F0F)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    videoFile = null;
                                  });
                                },
                                child: const CircleAvatar(
                                  backgroundColor: AppColors.lightGrey,
                                  radius: 8,
                                  child: Icon(
                                    Icons.close,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 24),
            BlocConsumer<UploadMediaCubit, UploadMediaState>(
              listener: (context, state) {
                if (state is UploadMediaSuccess) {
                  Fluttertoast.showToast(
                      msg: 'Video uploaded successfully',
                      backgroundColor: Colors.green);
                }
                if (state is UploadMediaFailure) {
                  Fluttertoast.showToast(msg: state.message);
                }
              },
              builder: (context, state) {
                return state is UploadMediaLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomTextButton(
                        text: 'Upload file',
                        onPressed: () {
                          if (videoFile == null) {
                            Fluttertoast.showToast(
                                msg: 'Please select a video file');
                          }
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            UploadVideoModel uploadVideoModel =
                                UploadVideoModel(
                                    userId: getUserData().userInfo!.id!,
                                    categoryId: 1,
                                    title: titleController.text,
                                    description: descriptionController.text,
                                    videoFile: platformFileToFile(videoFile!)!,
                                    thumbnailFile:
                                        platformFileToFile(thumbnailFile!)!,
                                    pdfFile: platformFileToFile(pdfFile!)!);
                            context.read<UploadMediaCubit>().uploadVideo(
                                uploadVideoModel: uploadVideoModel);
                          } else {
                            setState(() {
                              autovalidateMode = AutovalidateMode.always;
                            });
                          }
                        });
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Future selectFile(
      {required FileType type, List<String>? allowedExtensions}) async {
    final result = await FilePicker.platform.pickFiles(
      type: type,
      allowedExtensions: allowedExtensions,
    );

    if (result == null) {
      return;
    }
    setState(() {});
    return result.files.first;
  }
}

File? platformFileToFile(PlatformFile platformFile) {
  if (platformFile.path == null) return null; // Not available on web
  return File(platformFile.path!);
}
