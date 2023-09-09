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
import 'package:new_reddit_clone/features/post/controller/addpostController.dart';
import 'package:new_reddit_clone/theme/pallete.dart';

class AddPostypeScreen extends ConsumerStatefulWidget {
  AddPostypeScreen({
    required this.type,
  });

  final String type;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostypeScreenState();
}

class _AddPostypeScreenState extends ConsumerState<AddPostypeScreen> {
  final titelcontroller = TextEditingController();
  final descriptioncontroller = TextEditingController();
  final linkcontroller = TextEditingController();
  File? bannerFile;
  File? profileFile;
  List<Community> communities = [];
  Community? selectedCommunity;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titelcontroller.dispose();
    descriptioncontroller.dispose();
  }

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

  void sharePost() {
    if (widget.type == 'image' &&
        bannerFile != null &&
        titelcontroller.text.isNotEmpty) {
      ref.read(PostControllerProvider.notifier).shareImagePost(
          context: context,
          titel: titelcontroller.text.trim(),
          selectedCommunity: selectedCommunity ?? communities[0],
          file: bannerFile);
    } else if (widget.type == 'text' && titelcontroller.text.isNotEmpty) {
      ref.read(PostControllerProvider.notifier).shareTextPost(
          context: context,
          titel: titelcontroller.text.trim(),
          selectedCommunity: selectedCommunity ?? communities[0],
          description: descriptioncontroller.text.trim());
    } else if (widget.type == 'link' &&
        linkcontroller.text.isNotEmpty &&
        titelcontroller.text.isNotEmpty) {
      ref.read(PostControllerProvider.notifier).shareLinkPost(
          context: context,
          titel: titelcontroller.text.trim(),
          selectedCommunity: selectedCommunity ?? communities[0],
          link: linkcontroller.text.trim());
    } else {
      showSnackBar(context, 'Enter all filed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';
    final isLoading = ref.watch(PostControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Post ${widget.type}')),
        actions: [TextButton(onPressed: sharePost, child: Text('Share'))],
      ),
      body: isLoading
          ? Loader()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: titelcontroller,
                    decoration: InputDecoration(
                        filled: true,
                        hintText: 'Enter Titel Hare',
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.blue,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(18)),
                    maxLength: 30,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (isTypeImage)
                    GestureDetector(
                      onTap: selectBannerImage,
                      child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          dashPattern: const [10, 4],
                          strokeCap: StrokeCap.round,
                          color: currentTheme.textTheme.bodyText2!.color!,
                          child: Container(
                            child: bannerFile != null
                                ? Image.file(bannerFile!)
                                : Center(
                                    child: Icon(Icons.camera_alt_outlined),
                                  ),
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          )),
                    ),
                  if (isTypeText)
                    TextField(
                      controller: titelcontroller,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Enter Titel Hare',
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.blue,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      maxLines: 5,
                    ),
                  if (isTypeLink)
                    TextField(
                      controller: linkcontroller,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Enter Titel Hare',
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.blue,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text('Select Community'),
                  ),
                  ref.watch(userCommunitiesProvider).when(
                      data: (data) {
                        communities = data;
                        if (data.isEmpty) {
                          return const SizedBox();
                        }
                        return DropdownButton(
                            value: selectedCommunity ?? data[0],
                            items: data
                                .map((e) => DropdownMenuItem(
                                    value: e, child: Text(e.name)))
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedCommunity = val;
                              });
                            });
                      },
                      error: ((error, stackTrace) => ErrorText(
                            error: error.toString(),
                          )),
                      loading: () => const Loader())
                ],
              ),
            ),
    );
  }
}
