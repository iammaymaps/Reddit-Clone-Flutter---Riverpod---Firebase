// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_reddit_clone/core/common/Error_text.dart';
import 'package:new_reddit_clone/core/common/Loader.dart';
import 'package:new_reddit_clone/core/constants/constants.dart';
import 'package:new_reddit_clone/core/modules/Community_Model.dart';

import 'package:new_reddit_clone/core/utils.dart';
import 'package:new_reddit_clone/features/auth/controller/CommunityController.dart';
import 'package:new_reddit_clone/theme/pallete.dart';

class EditCommunity extends ConsumerStatefulWidget {
  const EditCommunity({
    required this.name,
  });

  final String name;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditCommunityState();
}

class _EditCommunityState extends ConsumerState<EditCommunity> {
  File? bannerFile;
  File? profileFile;

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectprofileImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  void save(Community community) {
    ref.read(CommunityControllerProvider.notifier).editCommunity(
        profileFile: profileFile,
        bannerFile: bannerFile,
        context: context,
        community: community);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(CommunityControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    return ref.watch(getCommunityByNameProvider(widget.name)).when(
        data: (community) => Scaffold(
              backgroundColor: currentTheme.backgroundColor,
              appBar: AppBar(
                title: const Text('Edit Community'),
                centerTitle: false,
                actions: [
                  TextButton(
                      onPressed: () => save(community),
                      child: const Text('Save'))
                ],
              ),
              body: isLoading
                  ? Loader()
                  : Column(
                      children: [
                        SizedBox(
                          height: 250,
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: selectBannerImage,
                                child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(10),
                                    dashPattern: const [10, 4],
                                    strokeCap: StrokeCap.round,
                                    color: currentTheme
                                        .textTheme.bodyText2!.color!,
                                    child: Container(
                                      child: bannerFile != null
                                          ? Image.file(bannerFile!)
                                          : community.banner.isEmpty ||
                                                  community.banner ==
                                                      Constants.bannerDefault
                                              ? const Center(
                                                  child: Icon(Icons
                                                      .camera_alt_outlined),
                                                )
                                              : Image.network(community.banner),
                                      width: double.infinity,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    )),
                              ),
                              Positioned(
                                bottom: 20,
                                left: 20,
                                child: GestureDetector(
                                  onTap: selectprofileImage,
                                  child: profileFile != null
                                      ? CircleAvatar(
                                          radius: 32,
                                          backgroundImage:
                                              FileImage(profileFile!),
                                        )
                                      : CircleAvatar(
                                          radius: 32,
                                          backgroundImage:
                                              NetworkImage(community.avater),
                                        ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
        loading: () => const Loader(),
        error: (error, stackTrace) => ErrorText(error: error.toString()));
  }
}
